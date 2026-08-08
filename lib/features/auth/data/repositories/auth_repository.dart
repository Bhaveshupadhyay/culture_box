import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../../../core/models/auth_models.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/storage/auth_local_storage.dart';
import '../../../../core/storage/device_id_service.dart';
import '../../../subscription/data/api/subscription_api_service.dart';
import '../api/auth_api_service.dart';

class AuthRepository {
  final AuthApiService authApiService;
  final AuthLocalStorage authLocalStorage;
  final DeviceIdService? deviceIdService;
  final SubscriptionApiService? subscriptionApiService;
  final firebase.FirebaseAuth _firebaseAuth;

  AuthRepository({
    required this.authApiService,
    required this.authLocalStorage,
    this.deviceIdService,
    this.subscriptionApiService,
    firebase.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  String get _currentDeviceId => deviceIdService?.getDeviceId() ?? 'CBX123456789';
  String get _currentDeviceType => deviceIdService?.getDeviceType() ?? 'android';

  String _mapFirebaseAuthError(firebase.FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email address is already registered. Please sign in instead.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'invalid-email':
        return 'The email address format is invalid.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  /// Firebase Sign In + Backend Authentication Sync
  Future<User> login({
    required String email,
    required String password,
    String? deviceId,
    String? deviceType,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).catchError((e) {
      if (e is firebase.FirebaseAuthException) {
        throw Exception(_mapFirebaseAuthError(e));
      }
      throw e;
    });

    final idToken = await credential.user?.getIdToken(true);
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Failed to retrieve Firebase ID token');
    }

    debugPrint('[AuthRepository] Firebase ID Token: $idToken');

    LoginResponse? loginResponse;
    try {
      loginResponse = await authApiService.loginWithFirebaseToken(
        FirebaseLoginRequest(
          idToken: idToken,
          deviceId: deviceId ?? _currentDeviceId,
          deviceType: deviceType ?? _currentDeviceType,
        ),
      );
    } catch (e) {
      debugPrint('[AuthRepository] loginWithFirebaseToken error: $e');
    }

    final token = (loginResponse?.accessToken != null && loginResponse!.accessToken!.isNotEmpty)
        ? loginResponse.accessToken!
        : idToken;

    debugPrint('[AuthRepository] Final Saved Access Token: $token');

    await authLocalStorage.saveTokens(
      accessToken: token,
      refreshToken: '',
    );

    var user = loginResponse?.user ??
        User(
          id: credential.user?.uid ?? '',
          email: credential.user?.email ?? email,
        );

    // Fetch live subscription status
    if (subscriptionApiService != null) {
      try {
        final statusMap = await subscriptionApiService!.getStatus();
        if (statusMap.containsKey('data') && statusMap['data'] is Map) {
          final data = statusMap['data'] as Map<String, dynamic>;
          final isActive = data['isActive'] == true || data['status'] == 'active';
          final subDetails = SubscriptionDetails.fromJson(data);

          user = user.copyWith(
            isSubscribed: isActive ? 1 : 0,
            subscriptionDetails: isActive ? subDetails : null,
          );
        }
      } catch (_) {}
    }

    await authLocalStorage.saveUserInfo(
      userId: user.id,
      userEmail: user.email,
    );

    return user;
  }

  /// Firebase Sign Up + Backend Authentication Sync
  Future<User> register({
    required String email,
    required String password,
    String? deviceId,
    String? deviceType,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).catchError((e) {
      if (e is firebase.FirebaseAuthException) {
        throw Exception(_mapFirebaseAuthError(e));
      }
      throw e;
    });

    final idToken = await credential.user?.getIdToken(true);
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Failed to retrieve Firebase ID token');
    }

    debugPrint('[AuthRepository] Firebase ID Token: $idToken');

    LoginResponse? loginResponse;
    try {
      loginResponse = await authApiService.loginWithFirebaseToken(
        FirebaseLoginRequest(
          idToken: idToken,
          deviceId: deviceId ?? _currentDeviceId,
          deviceType: deviceType ?? _currentDeviceType,
        ),
      );
    } catch (e) {
      debugPrint('[AuthRepository] loginWithFirebaseToken error: $e');
    }

    final token = (loginResponse?.accessToken != null && loginResponse!.accessToken!.isNotEmpty)
        ? loginResponse.accessToken!
        : idToken;

    debugPrint('[AuthRepository] Final Saved Access Token: $token');

    await authLocalStorage.saveTokens(
      accessToken: token,
      refreshToken: '',
    );

    final user = loginResponse?.user ??
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

  /// Get profile from backend & check live subscription status (GET /payments/status)
  Future<User?> getCurrentUser() async {
    if (!authLocalStorage.hasValidToken && _firebaseAuth.currentUser == null) {
      return null;
    }

    User? user;
    try {
      user = await authApiService.getProfile();
    } catch (_) {
      final fbUser = _firebaseAuth.currentUser;
      if (fbUser != null) {
        user = User(id: fbUser.uid, email: fbUser.email ?? '');
      }
    }

    if (user != null && subscriptionApiService != null) {
      try {
        final statusMap = await subscriptionApiService!.getStatus();
        debugPrint('[AuthRepository] GET /payments/status response: $statusMap');
        if (statusMap.containsKey('data') && statusMap['data'] is Map) {
          final data = statusMap['data'] as Map<String, dynamic>;
          final isActive = data['isActive'] == true || data['status'] == 'active';
          final subDetails = SubscriptionDetails.fromJson(data);

          user = user.copyWith(
            isSubscribed: isActive ? 1 : 0,
            subscriptionDetails: isActive ? subDetails : null,
          );
        }
      } catch (e) {
        debugPrint('[AuthRepository] Failed to fetch payment status: $e');
      }
    }

    return user;
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

    await fbUser.delete();

    try {
      await authApiService.deleteAccount();
    } catch (_) {}

    await authLocalStorage.clearSession();
  }

  bool get isAuthenticated =>
      authLocalStorage.hasValidToken || _firebaseAuth.currentUser != null;
}
