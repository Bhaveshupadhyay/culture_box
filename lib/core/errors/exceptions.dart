abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection available.']);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out. Please try again.']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized access. Please log in again.', super.statusCode = 401]);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Access forbidden.', super.statusCode = 403]);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Requested resource not found.', super.statusCode = 404]);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred. Please try again later.', super.statusCode = 500]);
}

class ValidationException extends AppException {
  const ValidationException(super.message, [super.statusCode = 422]);
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'An unexpected error occurred.']);
}
