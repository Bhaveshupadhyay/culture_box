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
        deviceType: deviceType ?? 'android',
      ),
    );

    if (loginResponse.accessToken != null) {
      await authLocalStorage.saveTokens(
        accessToken: loginResponse.accessToken!,
        refreshToken: '',
      );
    }

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
        deviceType: deviceType ?? 'android',
      ),
    );

    if (loginResponse.accessToken != null) {
      await authLocalStorage.saveTokens(
        accessToken: loginResponse.accessToken!,
        refreshToken: '',
      );
    }

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
    try {
      await authApiService.deleteAccount();
    } catch (_) {}
    await _firebaseAuth.currentUser?.delete();
    await authLocalStorage.clearSession();
  }

  bool get isAuthenticated =>
      authLocalStorage.hasValidToken || _firebaseAuth.currentUser != null;
}
