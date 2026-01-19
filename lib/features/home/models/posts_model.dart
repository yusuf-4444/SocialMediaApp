import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PostsModel {
  final String id;
  final String createdAt;
  final String? imageUrl;
  final String authorId;
  final String? text;
  final List<String>? likes;
  final String name;

  PostsModel({
    required this.id,
    required this.createdAt,
    this.imageUrl,
    required this.authorId,
    this.text,
    this.likes = const [],
    required this.name,
  });

  PostsModel copyWith({
    String? id,
    String? createdAt,
    String? imageUrl,
    String? authorId,
    String? text,
    List<String>? likes,
    String? name,
  }) {
    return PostsModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      authorId: authorId ?? this.authorId,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt,
      'imageUrl': imageUrl,
      'authorId': authorId,
      'text': text,
      'likes': likes,
    };
  }

  factory PostsModel.fromMap(Map<String, dynamic> map) {
    return PostsModel(
      name: map['name'] as String,
      id: map['id'] as String,
      createdAt: map['createdAt'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      authorId: map['authorId'] as String,
      text: map['text'] != null ? map['text'] as String : null,
      likes: map['likes'] != null
          ? List<String>.from((map['likes'] as List<String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostsModel.fromJson(String source) =>
      PostsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
