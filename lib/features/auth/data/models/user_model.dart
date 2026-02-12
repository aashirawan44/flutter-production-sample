import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? token;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'token': token};
  }

  // Conversion to Domain entity
  User toEntity() => User(id: id, email: email, name: name, token: token);

  // Conversion from Domain entity
  factory UserModel.fromEntity(User user) => UserModel(
    id: user.id,
    email: user.email,
    name: user.name,
    token: user.token,
  );
}
