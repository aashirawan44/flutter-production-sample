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
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
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
      final isSplash = state.matchedLocation == '/splash';
      final isLogin = state.matchedLocation == '/login';

      if (authState is AuthInitial) return isSplash ? null : '/splash';
      if (authState is AuthLoading) return isSplash ? null : '/splash';

      if (authState is AuthAuthenticated) {
        if (isSplash || isLogin) return '/';
      }

      if (authState is AuthUnauthenticated) {
        if (!isLogin) return '/login';
      }

      return null;
    },
  );
});
