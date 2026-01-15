class PostModel {
  final int id;
  final int leaderId;
  final String caption;
  final String? mediaUrl;
  final String? mediaType;
  final int likesCount;
  final int commentsCount;
  final int savesCount;
  final int sharesCount;
  final DateTime createdAt;
  final String leaderName;
  final String? profilePhotoUrl;
  final bool isLiked;  // ← NEW: true if current user has liked it

  PostModel({
    required this.id,
    required this.leaderId,
    required this.caption,
    this.mediaUrl,
    this.mediaType,
    required this.likesCount,
    required this.commentsCount,
    required this.savesCount,
    required this.sharesCount,
    required this.createdAt,
    required this.leaderName,
    this.profilePhotoUrl,
    required this.isLiked,  // ← required now
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      leaderId: json['leader_id'] as int,
      caption: json['caption'] as String,
      mediaUrl: json['media_url'] as String?,
      mediaType: json['media_type'] as String?,
      likesCount: json['likes_count'] as int,
      commentsCount: json['comments_count'] as int,
      savesCount: json['saves_count'] as int,
      sharesCount: json['shares_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      leaderName: json['leader_name'] as String,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      isLiked: (json['is_liked'] as int?) == 1,  // ← Convert 1 → true, 0/null → false
    );
  }
}