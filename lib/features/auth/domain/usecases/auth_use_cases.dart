import 'package:fpdart/fpdart.dart';
import '../../../../core/exceptions/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, User>> execute(String email, String password) {
    return _repository.login(email, password);
  }
}

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Either<Failure, void>> execute() {
    return _repository.logout();
  }
}

class GetLoggedUserUseCase {
  final AuthRepository _repository;

  GetLoggedUserUseCase(this._repository);

  Future<Either<Failure, User?>> execute() {
    return _repository.getLoggedUser();
  }
}

class IsAuthenticatedUseCase {
  final AuthRepository _repository;

  IsAuthenticatedUseCase(this._repository);

  Future<Either<Failure, bool>> execute() {
    return _repository.isAuthenticated();
  }
}
