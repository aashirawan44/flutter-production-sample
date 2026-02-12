import 'package:fpdart/fpdart.dart';
import '../../../../core/exceptions/failure.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts({
    required int page,
    required int limit,
    bool forceRefresh = false,
  });
}
