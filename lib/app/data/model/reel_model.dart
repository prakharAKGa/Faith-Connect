class ReelModel {
  final int id;
  final int leaderId;
  final String videoUrl;
  final String? caption;
   int likesCount;
   int commentsCount;
   int sharesCount;
   int savesCount;
  final String leaderName;
  final String? leaderPhoto;

  ReelModel({
    required this.id,
    required this.leaderId,
    required this.videoUrl,
    this.caption,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.savesCount,
    required this.leaderName,
    this.leaderPhoto,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'],
      leaderId: json['leader_id'],
      videoUrl: json['video_url'],
      caption: json['caption'],
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      sharesCount: json['shares_count'] ?? 0,
      savesCount: json['saves_count'] ?? 0,
      leaderName: json['leader_name'],
      leaderPhoto: json['profile_photo_url'],
    );
  }
}
