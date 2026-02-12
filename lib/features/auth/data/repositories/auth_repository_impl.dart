import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _secureStorage;
  final StorageService _sharedPrefs;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._secureStorage,
    this._sharedPrefs,
  );

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final userModel = await _remoteDataSource.login(email, password);

      // Save token in secure storage
      if (userModel.token != null) {
        await _secureStorage.write(_tokenKey, userModel.token!);
      }

      // Save user data in shared prefs
      await _sharedPrefs.write(_userKey, jsonEncode(userModel.toJson()));

      return Right(userModel.toEntity());
    } on AppException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _secureStorage.delete(_tokenKey);
      await _sharedPrefs.delete(_userKey);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getLoggedUser() async {
    try {
      final userData = await _sharedPrefs.read(_userKey);
      if (userData != null) {
        final userModel = UserModel.fromJson(jsonDecode(userData));
        return Right(userModel.toEntity());
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final token = await _secureStorage.read(_tokenKey);
      return Right(token != null);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, String?>> getAuthToken() async {
    try {
      final token = await _secureStorage.read(_tokenKey);
      return Right(token);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
