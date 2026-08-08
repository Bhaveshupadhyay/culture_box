import '../../../../core/models/auth_models.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class AuthApiService {
  final ApiClient apiClient;

  AuthApiService(this.apiClient);

  /// Authenticate with backend using Firebase ID Token
  Future<LoginResponse> loginWithFirebaseToken(FirebaseLoginRequest request) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Send OTP to Email
  Future<ApiResponse<void>> sendOtp(String email) async {
    final response = await apiClient.post(
      ApiEndpoints.sendOtp,
      data: {'email': email},
    );
    return ApiResponse<void>.fromJson(response.data as Map<String, dynamic>);
  }

  /// Initiate Forgot Password
  Future<ApiResponse<void>> forgotPassword(String email) async {
    final response = await apiClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
    return ApiResponse<void>.fromJson(response.data as Map<String, dynamic>);
  }

  /// Verify Reset OTP
  Future<ApiResponse<void>> verifyResetOtp(String email, String otp) async {
    final response = await apiClient.post(
      ApiEndpoints.verifyResetOtp,
      data: {'email': email, 'otp': otp},
    );
    return ApiResponse<void>.fromJson(response.data as Map<String, dynamic>);
  }

  /// Reset Password
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    final response = await apiClient.post(
      ApiEndpoints.resetPassword,
      data: request.toJson(),
    );
    return ApiResponse<void>.fromJson(response.data as Map<String, dynamic>);
  }

  /// Refresh Access Token
  Future<ApiResponse<void>> refreshToken() async {
    final response = await apiClient.get(ApiEndpoints.refresh);
    return ApiResponse<void>.fromJson(response.data as Map<String, dynamic>);
  }

  /// Get Current User Profile
  Future<User> getProfile() async {
    final response = await apiClient.get(ApiEndpoints.profile);
    final json = response.data as Map<String, dynamic>;
    if (json.containsKey('data') && json['data'] != null) {
      return User.fromJson(json['data'] as Map<String, dynamic>);
    }
    return User.fromJson(json);
  }

  /// Update Profile by ID
  Future<ApiResponse<void>> updateProfile(String id, Map<String, dynamic> data) async {
    final response = await apiClient.put(
      ApiEndpoints.updateProfile(id),
      data: data,
    );
    return ApiResponse<void>.fromJson(response.data as Map<String, dynamic>);
  }

  /// Logout User
  Future<ApiResponse<void>> logout() async {
    final response = await apiClient.post(ApiEndpoints.logout);
    return ApiResponse<void>.fromJson(response.data as Map<String, dynamic>);
  }

  /// Delete User Account
  Future<ApiResponse<void>> deleteAccount() async {
    final response = await apiClient.delete(ApiEndpoints.deleteAccount);
    return ApiResponse<void>.fromJson(response.data as Map<String, dynamic>);
  }
}
