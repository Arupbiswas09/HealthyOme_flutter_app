import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

final _logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

/// Authorization interceptor - Adds auth token to requests
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    final publicEndpoints = [
      '/auth/login/',
      '/auth/register/',
      '/auth/verify-otp/',
      '/meals/',
      '/meal-plans/',
      '/subscription-plans/',
      '/bowl-bases/',
      '/bowl-ingredients/',
      '/rewards/',
    ];

    final isPublic = publicEndpoints.any(
      (endpoint) => options.path.contains(endpoint),
    );

    if (!isPublic) {
      final token = await _secureStorage.read(key: AppConstants.accessTokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // TODO: Implement token refresh logic
      // For now, just pass the error
    }
    return handler.next(err);
  }
}

/// Logging interceptor for debugging
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.d('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
      if (options.queryParameters.isNotEmpty) {
        _logger.d('Query: ${options.queryParameters}');
      }
      if (options.data != null) {
        _logger.d('Body: ${options.data}');
      }
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.d(
        '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e(
        '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      _logger.e('Message: ${err.message}');
      if (err.response?.data != null) {
        _logger.e('Data: ${err.response?.data}');
      }
    }
    return handler.next(err);
  }
}

/// Retry interceptor for failed requests
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Set<int> retryableStatuses;

  RetryInterceptor(
    this._dio, {
    this.maxRetries = 3,
    this.retryableStatuses = const {408, 500, 502, 503, 504},
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final shouldRetry = statusCode != null && retryableStatuses.contains(statusCode);

    if (shouldRetry) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < maxRetries) {
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        // Exponential backoff
        final delay = Duration(milliseconds: 1000 * ((retryCount as int) + 1));
        await Future.delayed(delay);

        if (kDebugMode) {
          _logger.w('🔄 Retrying request (${retryCount + 1}/$maxRetries)...');
        }

        try {
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          // Continue with original error handling
        }
      }
    }

    return handler.next(err);
  }
}

/// Cache interceptor for offline support
class CacheInterceptor extends Interceptor {
  // TODO: Implement response caching using Hive
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check cache before making request
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Cache successful GET responses
    if (response.requestOptions.method == 'GET') {
      // TODO: Store in Hive cache
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Return cached data if available when offline
    return handler.next(err);
  }
}
