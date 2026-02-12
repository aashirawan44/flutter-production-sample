import 'dart:convert';
import '../../../../core/storage/storage_service.dart';
import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<void> cachePosts(List<PostModel> posts);
  Future<List<PostModel>> getLastPosts();
  Future<void> clearCache();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final StorageService _storage;
  static const _postsCacheKey = 'posts_cache';

  PostLocalDataSourceImpl(this._storage);

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    final jsonList = posts.map((p) => p.toJson()).toList();
    await _storage.write(_postsCacheKey, jsonEncode(jsonList));
  }

  @override
  Future<List<PostModel>> getLastPosts() async {
    final jsonString = await _storage.read(_postsCacheKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((j) => PostModel.fromJson(j)).toList();
    }
    return [];
  }

  @override
  Future<void> clearCache() => _storage.delete(_postsCacheKey);
}
