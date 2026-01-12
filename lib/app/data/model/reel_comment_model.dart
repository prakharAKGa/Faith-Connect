class ReelCommentModel {
  final int id;
  final String text;
  final String commenterName;
  final String? commenterPhoto;
  final DateTime createdAt;

  ReelCommentModel({
    required this.id,
    required this.text,
    required this.commenterName,
    this.commenterPhoto,
    required this.createdAt,
  });

  factory ReelCommentModel.fromJson(Map<String, dynamic> json) {
    return ReelCommentModel(
      id: json['id'],
      text: json['text'],
      commenterName: json['commenter_name'],
      commenterPhoto: json['profile_photo_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
