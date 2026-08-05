import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import '../storage/auth_local_storage.dart';
import 'api_endpoints.dart';

class ApiClient {
  late final Dio _dio;
  final AuthLocalStorage authLocalStorage;

  ApiClient({
    required this.authLocalStorage,
    String? baseUrl,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = authLocalStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = authLocalStorage.getRefreshToken();
            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                // Attempt refresh token
                final refreshDio = Dio(
                  BaseOptions(
                    baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
                    headers: {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                    },
                  ),
                );

                final response = await refreshDio.post(
                  ApiEndpoints.refresh,
                  data: {'refresh_token': refreshToken},
                );

                if (response.statusCode == 200 && response.data != null) {
                  final newAccessToken = response.data['access_token'] as String;
                  final newRefreshToken = response.data['refresh_token'] as String;

                  await authLocalStorage.saveTokens(
                    accessToken: newAccessToken,
                    refreshToken: newRefreshToken,
                  );

                  // Retry original request with new token
                  final retryOptions = error.requestOptions;
                  retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                  final cloneReq = await _dio.fetch(retryOptions);
                  return handler.resolve(cloneReq);
                }
              } catch (_) {
                await authLocalStorage.clearSession();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  AppException _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const TimeoutException();
    }

    if (error.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    String message = 'An unexpected network error occurred.';

    if (data is Map && data.containsKey('detail')) {
      final detail = data['detail'];
      if (detail is String) {
        message = detail;
      } else if (detail is List && detail.isNotEmpty) {
        final firstError = detail.first;
        if (firstError is Map && firstError.containsKey('msg')) {
          message = firstError['msg'].toString();
        }
      }
    }

    switch (statusCode) {
      case 401:
        return UnauthorizedException(message, statusCode);
      case 403:
        return ForbiddenException(message, statusCode);
      case 404:
        return NotFoundException(message, statusCode);
      case 422:
        return ValidationException(message, statusCode);
      case 500:
      case 502:
      case 503:
        return ServerException(message, statusCode);
      default:
        return UnknownException(message);
    }
  }
}
