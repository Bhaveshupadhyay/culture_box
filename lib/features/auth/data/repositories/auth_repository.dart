import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../../../core/models/auth_models.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/storage/auth_local_storage.dart';
import '../api/auth_api_service.dart';

class AuthRepository {
  final AuthApiService authApiService;
  final AuthLocalStorage authLocalStorage;
  final firebase.FirebaseAuth _firebaseAuth;

  AuthRepository({
    required this.authApiService,
    required this.authLocalStorage,
    firebase.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  String get _defaultDeviceType {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      default:
        return 'web';
    }
  }

  /// Firebase Sign In + Backend Authentication
  Future<User> login({
    required String email,
    required String password,
    String? deviceId,
    String? deviceType,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final idToken = await credential.user?.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Failed to retrieve Firebase ID token');
    }

    final loginResponse = await authApiService.loginWithFirebaseToken(
      FirebaseLoginRequest(
        idToken: idToken,
        deviceId: deviceId,
        deviceType: deviceType ?? _defaultDeviceType,
      ),
    );

    final token = loginResponse.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception(
        loginResponse.reasonCode ?? 'Backend authentication failed',
      );
    }

    await authLocalStorage.saveTokens(
      accessToken: token,
      refreshToken: '',
    );

    final user = loginResponse.user ??
        User(
          id: credential.user?.uid ?? '',
          email: credential.user?.email ?? email,
        );

    await authLocalStorage.saveUserInfo(
      userId: user.id,
      userEmail: user.email,
    );

    return user;
  }

  /// Firebase Sign Up + Backend Authentication
  Future<User> register({
    required String email,
    required String password,
    String? deviceId,
    String? deviceType,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final idToken = await credential.user?.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Failed to retrieve Firebase ID token');
    }

    final loginResponse = await authApiService.loginWithFirebaseToken(
      FirebaseLoginRequest(
        idToken: idToken,
        deviceId: deviceId,
        deviceType: deviceType ?? _defaultDeviceType,
      ),
    );

    final token = loginResponse.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception(
        loginResponse.reasonCode ?? 'Backend authentication failed',
      );
    }

    await authLocalStorage.saveTokens(
      accessToken: token,
      refreshToken: '',
    );

    final user = loginResponse.user ??
        User(
          id: credential.user?.uid ?? '',
          email: credential.user?.email ?? email,
        );

    await authLocalStorage.saveUserInfo(
      userId: user.id,
      userEmail: user.email,
    );

    return user;
  }

  /// Get profile from backend
  Future<User?> getCurrentUser() async {
    if (!authLocalStorage.hasValidToken && _firebaseAuth.currentUser == null) {
      return null;
    }
    try {
      return await authApiService.getProfile();
    } catch (_) {
      final fbUser = _firebaseAuth.currentUser;
      if (fbUser != null) {
        return User(id: fbUser.uid, email: fbUser.email ?? '');
      }
      return null;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await authApiService.logout();
    } catch (_) {}
    await _firebaseAuth.signOut();
    await authLocalStorage.clearSession();
  }

  /// Delete Account
  Future<void> deleteAccount() async {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser == null) {
      throw Exception('User is not authenticated with Firebase.');
    }

    // Delete Firebase Auth user first (throws re-auth error if required before backend deletion)
    await fbUser.delete();

    try {
      await authApiService.deleteAccount();
    } catch (_) {}

    await authLocalStorage.clearSession();
  }

  bool get isAuthenticated =>
      authLocalStorage.hasValidToken || _firebaseAuth.currentUser != null;
}
