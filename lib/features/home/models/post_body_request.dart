class PostBodyRequest {
  final String userId;
  final String? text;
  final String? imageUrl;

  PostBodyRequest({required this.userId, this.text, this.imageUrl});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author_id': userId,
      'text_post': text,
      'image_post': imageUrl,
    };
  }
}
