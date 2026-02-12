import 'package:fpdart/fpdart.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _remoteDataSource;
  final PostLocalDataSource _localDataSource;

  PostRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<Post>>> getPosts({
    required int page,
    required int limit,
    bool forceRefresh = false,
  }) async {
    try {
      // If first page and not force refresh, try cache first
      if (page == 1 && !forceRefresh) {
        final cachedPosts = await _localDataSource.getLastPosts();
        if (cachedPosts.isNotEmpty) {
          // You could still trigger a background refresh here in a real production app
          return Right(cachedPosts.map((p) => p.toEntity()).toList());
        }
      }

      // Fetch from remote
      final remotePosts = await _remoteDataSource.getPosts(page, limit);

      // Cache first page
      if (page == 1) {
        await _localDataSource.cachePosts(remotePosts);
      }

      return Right(remotePosts.map((p) => p.toEntity()).toList());
    } on AppException catch (e) {
      // If remote fails and we are on first page, try cache as fallback
      if (page == 1) {
        final cachedPosts = await _localDataSource.getLastPosts();
        if (cachedPosts.isNotEmpty) {
          return Right(cachedPosts.map((p) => p.toEntity()).toList());
        }
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
