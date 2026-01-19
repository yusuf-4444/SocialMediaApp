import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PostsModel {
  final String id;
  final String createdAt;
  final String? imagePost;
  final String authorId;
  final String? text;
  final List<String>? likes;
  final String? name;
  final String? userImage;

  PostsModel({
    required this.id,
    required this.createdAt,
    this.imagePost,
    required this.authorId,
    this.text,
    this.likes = const [],
    this.name = "",
    this.userImage,
  });

  PostsModel copyWith({
    String? id,
    String? createdAt,
    String? imageUrl,
    String? authorId,
    String? text,
    List<String>? likes,
    String? name,
    String? userImage,
  }) {
    return PostsModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      imagePost: imagePost ?? imagePost,
      authorId: authorId ?? this.authorId,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      name: name ?? this.name,
      userImage: userImage ?? this.userImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt,
      'imageUrl': imagePost,
      'authorId': authorId,
      'text': text,
      'likes': likes,
    };
  }

  factory PostsModel.fromMap(Map<String, dynamic> map) {
    return PostsModel(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      imagePost: map['image_post'] != null ? map['image_post'] as String : null,
      authorId: map['author_id'] as String,
      text: map['text_post'] != null ? map['text_post'] as String : null,
      likes: map['likes'] != null
          ? List<String>.from((map['likes'] as List<String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostsModel.fromJson(String source) =>
      PostsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
