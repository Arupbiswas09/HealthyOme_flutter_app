/// Custom API Exception classes for better error handling
sealed class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException(this.message, [this.statusCode, this.data]);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// No internet connection
class NetworkException extends ApiException {
  const NetworkException([
    super.message = 'No internet connection. Please check your network.',
  ]);
}

/// Server returned an error
class ServerException extends ApiException {
  const ServerException(super.message, [super.statusCode, super.data]);
}

/// Request timeout
class TimeoutException extends ApiException {
  const TimeoutException([
    super.message = 'Request timed out. Please try again.',
  ]);
}

/// Unauthorized - Session expired or invalid token
class UnauthorizedException extends ApiException {
  const UnauthorizedException([
    String message = 'Session expired. Please login again.',
  ]) : super(message, 401);
}

/// Forbidden - User doesn't have permission
class ForbiddenException extends ApiException {
  const ForbiddenException([
    String message = 'You do not have permission to perform this action.',
  ]) : super(message, 403);
}

/// Not found
class NotFoundException extends ApiException {
  const NotFoundException([
    String message = 'The requested resource was not found.',
  ]) : super(message, 404);
}

/// Validation error from server
class ValidationException extends ApiException {
  final Map<String, List<String>> errors;

  const ValidationException(
    this.errors, [
    String message = 'Validation failed',
  ]) : super(message, 400);

  @override
  String toString() {
    final errorMessages = errors.entries
        .map((e) => '${e.key}: ${e.value.join(", ")}')
        .join('\n');
    return 'ValidationException:\n$errorMessages';
  }

  /// Get first error message for display
  String get firstError {
    if (errors.isEmpty) return message;
    final firstKey = errors.keys.first;
    final firstErrors = errors[firstKey];
    if (firstErrors != null && firstErrors.isNotEmpty) {
      return firstErrors.first;
    }
    return message;
  }
}

/// Rate limit exceeded
class RateLimitException extends ApiException {
  final int? retryAfterSeconds;

  const RateLimitException([
    String message = 'Too many requests. Please try again later.',
    this.retryAfterSeconds,
  ]) : super(message, 429);
}

/// Unknown/unexpected error
class UnknownException extends ApiException {
  const UnknownException([
    super.message = 'An unexpected error occurred. Please try again.',
  ]);
}

/// Cache exception
class CacheException extends ApiException {
  const CacheException([
    super.message = 'Failed to load cached data.',
  ]);
}

/// Parse exception - Failed to parse response
class ParseException extends ApiException {
  const ParseException([
    super.message = 'Failed to parse server response.',
  ]);
}
