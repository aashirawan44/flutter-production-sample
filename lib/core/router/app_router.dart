import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/providers/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/posts/domain/entities/post.dart';
import '../../features/posts/presentation/screens/post_detail_screen.dart';
import '../../features/posts/presentation/screens/post_list_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(routerRefreshNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/',
        builder: (context, state) => const PostListScreen(),
        routes: [
          GoRoute(
            path: 'post/:id',
            builder: (context, state) {
              final post = state.extra as Post;
              return PostDetailScreen(post: post);
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final location = state.matchedLocation;

      final isSplash = location == '/splash';
      final isLogin = location == '/login';

      // Initial state → Splash
      if (authState is AuthInitial) {
        return isSplash ? null : '/splash';
      }

      // Loading → Stay on splash/login only
      if (authState is AuthLoading) {
        if (isSplash || isLogin) return null;
        return '/splash';
      }

      // Authenticated → Block splash/login
      if (authState is AuthAuthenticated) {
        if (isSplash || isLogin) return '/';
        return null;
      }

      // Unauthenticated → Force login
      if (authState is AuthUnauthenticated) {
        return isLogin ? null : '/login';
      }

      return null;
    },


  );
});


final routerRefreshNotifierProvider = Provider<RouterRefreshNotifier>((ref) {
  final notifier = RouterRefreshNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this.ref) {
    ref.listen(authProvider, (_, __) {
      notifyListeners();
    });
  }

  final Ref ref;
}

