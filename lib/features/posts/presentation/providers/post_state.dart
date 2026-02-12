import 'package:equatable/equatable.dart';
import '../../domain/entities/post.dart';

abstract class PostListState extends Equatable {
  const PostListState();

  @override
  List<Object?> get props => [];

  T maybeWhen<T>({
    required T Function() orElse,
    T Function(List<Post> posts, bool hasReachedMax)? success,
    T Function()? loading,
    T Function(String message)? error,
  }) {
    if (this is PostListSuccess && success != null) {
      final s = this as PostListSuccess;
      return success(s.posts, s.hasReachedMax);
    }
    if (this is PostListLoading && loading != null) {
      return loading();
    }
    if (this is PostListError && error != null) {
      return error((this as PostListError).message);
    }
    return orElse();
  }
}

class PostListInitial extends PostListState {
  const PostListInitial();
}

class PostListLoading extends PostListState {
  const PostListLoading();
}

class PostListSuccess extends PostListState {
  final List<Post> posts;
  final bool hasReachedMax;

  const PostListSuccess(this.posts, this.hasReachedMax);

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class PostListError extends PostListState {
  final String message;

  const PostListError(this.message);

  @override
  List<Object?> get props => [message];
}
