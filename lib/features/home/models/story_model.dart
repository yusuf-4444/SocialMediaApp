// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoryModel {
  final String id;
  final String createdAt;
  final String imageUrl;
  final String authorId;
  final String? name;

  StoryModel({
    required this.id,
    required this.createdAt,
    required this.imageUrl,
    required this.authorId,
    this.name = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdAt,
      'image_url': imageUrl,
      'author_id': authorId,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      imageUrl: map['image_url'] as String,
      authorId: map['author_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryModel.fromJson(String source) =>
      StoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  StoryModel copyWith({
    String? id,
    String? createdAt,
    String? imageUrl,
    String? authorId,
    String? name,
  }) {
    return StoryModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      authorId: authorId ?? this.authorId,
      name: name ?? this.name,
    );
  }
}
