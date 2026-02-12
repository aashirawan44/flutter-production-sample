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
  const ServerFailure([super.message = 'Server error occurred', super.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection',
    super.code,
  ]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication error', super.code]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid input', super.code]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
