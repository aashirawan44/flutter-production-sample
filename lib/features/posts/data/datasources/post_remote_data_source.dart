import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts(int page, int limit);
}

class FakePostRemoteDataSourceImpl implements PostRemoteDataSource {
  @override
  Future<List<PostModel>> getPosts(int page, int limit) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate potential network error
    // if (page > 5) throw NetworkException('No more data');

    // Generate fake data
    return List.generate(limit, (index) {
      final id = (page - 1) * limit + index + 1;
      return PostModel(
        id: id,
        title: 'Post $id',
        body:
            'This is the body of post $id. It contains some sample text for demonstration.',
      );
    });
  }
}
