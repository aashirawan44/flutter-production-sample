import '../../../../core/exceptions/app_exception.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class FakeAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'admin@example.com' && password == 'password123') {
      return const UserModel(
        id: '1',
        email: 'admin@example.com',
        name: 'Senior Dev',
        token: 'fake_jwt_token_12345',
      );
    } else {
      throw AuthException('Invalid email or password');
    }
  }
}
