abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() =>
      '$runtimeType: $message${code != null ? ' ($code)' : ''}';
}

class NetworkException extends AppException {
  NetworkException([super.message = 'Network connection error', super.code]);
}

class ServerException extends AppException {
  ServerException([super.message = 'Server error occurred', super.code]);
}

class CacheException extends AppException {
  CacheException([super.message = 'Cache error occurred']);
}

class AuthException extends AppException {
  AuthException([super.message = 'Authentication failed', super.code]);
}

class ValidationException extends AppException {
  ValidationException([super.message = 'Validation failed']);
}
