abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() =>
      '$runtimeType: $message${code != null ? ' ($code)' : ''}';
}

class NetworkException extends AppException {
  NetworkException([String message = 'Network connection error', String? code])
    : super(message, code);
}

class ServerException extends AppException {
  ServerException([String message = 'Server error occurred', String? code])
    : super(message, code);
}

class CacheException extends AppException {
  CacheException([String message = 'Cache error occurred']) : super(message);
}

class AuthException extends AppException {
  AuthException([String message = 'Authentication failed', String? code])
    : super(message, code);
}

class ValidationException extends AppException {
  ValidationException([String message = 'Validation failed']) : super(message);
}
