// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserDataModel {
  final String id;
  final String name;
  final String? userName;
  final String email;
  final String? imageUrl;
  final String? title;
  final DateTime createdAt;

  UserDataModel({
    required this.id,
    required this.name,
    this.userName,
    required this.email,
    this.imageUrl,
    this.title,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'user_name': userName,
      'email': email,
      'image_url': imageUrl,
      'title': title,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      id: map['id'] as String,
      name: map['name'] as String,
      userName: map['user_name'] != null ? map['user_name'] as String : null,
      email: map['email'] as String,
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDataModel.fromJson(String source) =>
      UserDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserDataModel copyWith({
    String? id,
    String? name,
    String? userName,
    String? email,
    String? imageUrl,
    String? title,
    DateTime? createdAt,
  }) {
    return UserDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
