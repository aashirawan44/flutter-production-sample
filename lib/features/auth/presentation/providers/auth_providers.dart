import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_use_cases.dart';
import 'auth_state.dart';

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    FakeAuthRemoteDataSourceImpl(),
    ref.watch(secureStorageServiceProvider),
    ref.watch(sharedPrefsServiceProvider),
  );
});

// Use Case Providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final getLoggedUserUseCaseProvider = Provider<GetLoggedUserUseCase>((ref) {
  return GetLoggedUserUseCase(ref.watch(authRepositoryProvider));
});

final isAuthenticatedUseCaseProvider = Provider<IsAuthenticatedUseCase>((ref) {
  return IsAuthenticatedUseCase(ref.watch(authRepositoryProvider));
});

// Auth Notifier Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(loginUseCaseProvider),
    ref.watch(logoutUseCaseProvider),
    ref.watch(getLoggedUserUseCaseProvider),
    ref.watch(isAuthenticatedUseCaseProvider),
    ref.watch(analyticsServiceProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetLoggedUserUseCase _getLoggedUserUseCase;
  final IsAuthenticatedUseCase _isAuthenticatedUseCase;
  final AnalyticsService _analyticsService;

  AuthNotifier(
    this._loginUseCase,
    this._logoutUseCase,
    this._getLoggedUserUseCase,
    this._isAuthenticatedUseCase,
    this._analyticsService,
  ) : super(const AuthInitial());

  Future<void> checkSession() async {
    state = const AuthLoading();
    final result = await _isAuthenticatedUseCase.execute();

    await result.fold(
      (failure) async {
        state = const AuthUnauthenticated();
      },
      (isAuth) async {
        if (isAuth) {
          final userResult = await _getLoggedUserUseCase.execute();
          userResult.fold((failure) => state = const AuthUnauthenticated(), (
            user,
          ) {
            if (user != null) {
              state = AuthAuthenticated(user);
            } else {
              state = const AuthUnauthenticated();
            }
          });
        } else {
          state = const AuthUnauthenticated();
        }
      },
    );
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    _analyticsService.logEvent('login_attempt', {'email': email});

    final result = await _loginUseCase.execute(email, password);

    result.fold(
      (failure) {
        state = AuthError(failure.message);
        _analyticsService.logEvent('login_failure', {'error': failure.message});
      },
      (user) {
        state = AuthAuthenticated(user);
        _analyticsService.logEvent('login_success', {'user_id': user.id});
      },
    );
  }

  Future<void> logout() async {
    state = const AuthLoading();
    _analyticsService.logEvent('logout');

    final result = await _logoutUseCase.execute();

    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthUnauthenticated(),
    );
  }
}
