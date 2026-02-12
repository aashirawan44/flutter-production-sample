import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() =>
      '$runtimeType: $message${code != null ? ' ($code)' : ''}';
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred', String? code])
    : super(message, code);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    String message = 'No internet connection',
    String? code,
  ]) : super(message, code);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred'])
    : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication error', String? code])
    : super(message, code);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Invalid input', String? code])
    : super(message, code);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'An unexpected error occurred'])
    : super(message);
}
