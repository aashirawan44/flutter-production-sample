import 'package:fpdart/fpdart.dart';
import '../../../../core/exceptions/failure.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPaginatedPostsUseCase {
  final PostRepository _repository;

  GetPaginatedPostsUseCase(this._repository);

  Future<Either<Failure, List<Post>>> execute({
    required int page,
    int limit = 10,
    bool forceRefresh = false,
  }) {
    return _repository.getPosts(
      page: page,
      limit: limit,
      forceRefresh: forceRefresh,
    );
  }
}
