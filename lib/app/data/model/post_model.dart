class PostModel {
  final int id;
  final int leaderId;
  final String caption;
  final String? mediaUrl;        // ← now nullable
  final String? mediaType;       // ← now nullable
  final int likesCount;
  final int commentsCount;
  final int savesCount;
  final int sharesCount;
  final DateTime createdAt;
  final String leaderName;
  final String? profilePhotoUrl;

  PostModel({
    required this.id,
    required this.leaderId,
    required this.caption,
    this.mediaUrl,               // ← nullable
    this.mediaType,              // ← nullable
    required this.likesCount,
    required this.commentsCount,
    required this.savesCount,
    required this.sharesCount,
    required this.createdAt,
    required this.leaderName,
    this.profilePhotoUrl,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      leaderId: json['leader_id'] as int,
      caption: json['caption'] as String,
      mediaUrl: json['media_url'] as String?,           // ← safe null
      mediaType: json['media_type'] as String?,         // ← safe null
      likesCount: json['likes_count'] as int,
      commentsCount: json['comments_count'] as int,
      savesCount: json['saves_count'] as int,
      sharesCount: json['shares_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      leaderName: json['leader_name'] as String,
      profilePhotoUrl: json['profile_photo_url'] as String?,
    );
  }
}