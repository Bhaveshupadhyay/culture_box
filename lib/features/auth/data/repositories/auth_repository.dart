import '../../../../core/models/auth_models.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/storage/auth_local_storage.dart';
import '../api/auth_api_service.dart';

class AuthRepository {
  final AuthApiService authApiService;
  final AuthLocalStorage authLocalStorage;

  AuthRepository({
    required this.authApiService,
    required this.authLocalStorage,
  });

  Future<User> login({
    required String email,
    required String password,
  }) async {
    final token = await authApiService.login(
      LoginRequest(email: email, password: password),
    );
    await authLocalStorage.saveTokens(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
    );

    final user = await authApiService.getCurrentUser();
    await authLocalStorage.saveUserInfo(
      userId: user.id,
      userEmail: user.email,
    );
    return user;
  }

  Future<User> register({
    required String email,
    required String password,
  }) async {
    await authApiService.register(
      UserCreateRequest(email: email, password: password),
    );
    // After registration, log the user in automatically
    return await login(email: email, password: password);
  }

  Future<User?> getCurrentUser() async {
    if (!authLocalStorage.hasValidToken) {
      return null;
    }
    try {
      return await authApiService.getCurrentUser();
    } catch (_) {
      await authLocalStorage.clearSession();
      return null;
    }
  }

  Future<void> logout() async {
    await authLocalStorage.clearSession();
  }

  bool get isAuthenticated => authLocalStorage.hasValidToken;
}
