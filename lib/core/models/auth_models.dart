import 'package:equatable/equatable.dart';
import 'user_model.dart';

class FirebaseLoginRequest extends Equatable {
  final String idToken;
  final String? deviceId;
  final String? deviceType;

  const FirebaseLoginRequest({
    required this.idToken,
    this.deviceId,
    this.deviceType,
  });

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      if (deviceId != null) 'deviceId': deviceId,
      if (deviceType != null) 'deviceType': deviceType,
    };
  }

  @override
  List<Object?> get props => [idToken, deviceId, deviceType];
}

class LoginResponse extends Equatable {
  final String? accessToken;
  final String? reasonCode;
  final User? user;

  const LoginResponse({
    this.accessToken,
    this.reasonCode,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> map = (json['data'] != null && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return LoginResponse(
      accessToken: map['accessToken'] as String? ??
          map['access_token'] as String? ??
          map['token'] as String?,
      reasonCode: map['reasonCode'] as String? ??
          map['reason_code'] as String? ??
          json['message'] as String?,
      user: map['user'] != null && map['user'] is Map<String, dynamic>
          ? User.fromJson(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'reasonCode': reasonCode,
      'user': user?.toJson(),
    };
  }

  @override
  List<Object?> get props => [accessToken, reasonCode, user];
}

class SendOtpRequest extends Equatable {
  final String email;

  const SendOtpRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};

  @override
  List<Object?> get props => [email];
}

class ResetPasswordRequest extends Equatable {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'otp': otp,
    'newPassword': newPassword,
  };

  @override
  List<Object?> get props => [email, otp, newPassword];
}

class ApiResponse<T> extends Equatable {
  final bool isSuccess;
  final String? message;
  final T? data;

  const ApiResponse({
    required this.isSuccess,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic json)? fromJsonT,
  ]) {
    return ApiResponse<T>(
      isSuccess: json['isSuccess'] as bool? ?? true,
      message: json['message'] as String?,
      data: (json['data'] != null && fromJsonT != null)
          ? fromJsonT(json['data'])
          : null,
    );
  }

  @override
  List<Object?> get props => [isSuccess, message, data];
}
