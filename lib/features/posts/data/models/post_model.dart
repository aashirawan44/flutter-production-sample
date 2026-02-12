import '../../domain/entities/post.dart';

class PostModel {
  final int id;
  final String title;
  final String body;

  const PostModel({required this.id, required this.title, required this.body});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'body': body};
  }

  Post toEntity() => Post(id: id, title: title, body: body);

  factory PostModel.fromEntity(Post post) =>
      PostModel(id: post.id, title: post.title, body: post.body);
}
