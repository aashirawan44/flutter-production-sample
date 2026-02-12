import 'package:fpdart/fpdart.dart';
import '../../../../core/exceptions/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getLoggedUser();
  Future<Either<Failure, bool>> isAuthenticated();
  Future<Either<Failure, String?>> getAuthToken();
}
