import 'package:dio/dio.dart';
import '../../../../core/models/auth_models.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class AuthApiService {
  final ApiClient apiClient;

  AuthApiService(this.apiClient);

  Future<TokenModel> login(LoginRequest request) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: FormData.fromMap(request.toFormData()),
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    return TokenModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<User> register(UserCreateRequest request) async {
    final response = await apiClient.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<User> getCurrentUser() async {
    final response = await apiClient.get(ApiEndpoints.me);
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TokenModel> refreshToken(String refreshToken) async {
    final response = await apiClient.post(
      ApiEndpoints.refresh,
      data: {'refresh_token': refreshToken},
    );
    return TokenModel.fromJson(response.data as Map<String, dynamic>);
  }
}
