import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/core_providers.dart';
import '../../data/datasources/post_local_data_source.dart';
import '../../data/datasources/post_remote_data_source.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecases/get_paginated_posts_use_case.dart';
import 'post_state.dart';

// Repository Provider
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(
    FakePostRemoteDataSourceImpl(),
    PostLocalDataSourceImpl(ref.watch(sharedPrefsServiceProvider)),
  );
});

// Use Case Provider
final getPaginatedPostsUseCaseProvider = Provider<GetPaginatedPostsUseCase>((
  ref,
) {
  return GetPaginatedPostsUseCase(ref.watch(postRepositoryProvider));
});

// Post List Controller Provider
final postListControllerProvider =
    StateNotifierProvider<PostListController, PostListState>((ref) {
      return PostListController(ref.watch(getPaginatedPostsUseCaseProvider));
    });

class PostListController extends StateNotifier<PostListState> {
  final GetPaginatedPostsUseCase _getPaginatedPostsUseCase;

  PostListController(this._getPaginatedPostsUseCase)
    : super(const PostListInitial()) {
    fetchPosts();
  }

  int _currentPage = 1;
  static const int _limit = 10;

  Future<void> fetchPosts({bool forceRefresh = false}) async {
    if (forceRefresh) {
      _currentPage = 1;
      state = const PostListLoading();
    } else if (state is PostListLoading) {
      return;
    }

    // Capture the current posts if we are loading more
    final currentPosts = state.maybeWhen(
      success: (posts, hasReachedMax) => posts,
      orElse: () => <Post>[],
    );

    final result = await _getPaginatedPostsUseCase.execute(
      page: _currentPage,
      limit: _limit,
      forceRefresh: forceRefresh,
    );

    result.fold(
      (failure) {
        if (_currentPage == 1) {
          state = PostListError(failure.message);
        }
      },
      (newPosts) {
        final hasReachedMax = newPosts.length < _limit;
        if (_currentPage == 1) {
          state = PostListSuccess(newPosts, hasReachedMax);
        } else {
          state = PostListSuccess([
            ...currentPosts,
            ...newPosts,
          ], hasReachedMax);
        }
        _currentPage++;
      },
    );
  }

  Future<void> refresh() => fetchPosts(forceRefresh: true);
}
