// lib/app/data/model/post_comment_model.dart
class PostCommentModel {
  final int id;
  final String text;
  final String commenterName;
  final String? commenterPhoto;
  final DateTime createdAt;

  PostCommentModel({
    required this.id,
    required this.text,
    required this.commenterName,
    this.commenterPhoto,
    required this.createdAt,
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) {
    return PostCommentModel(
      id: json['id'],
      text: json['text'],
      commenterName: json['commenter_name'],
      commenterPhoto: json['profile_photo_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
