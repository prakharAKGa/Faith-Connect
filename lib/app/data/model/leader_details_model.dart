class LeaderDetailsModel {
  final int id;
  final String name;
  final String faith;
  final String? bio;
  final String? profilePhotoUrl;
  bool isFollowing;

   LeaderStats stats;
  final List<LeaderPost> posts;
  final List<LeaderReel> reels;

  LeaderDetailsModel({
    required this.id,
    required this.name,
    required this.faith,
    required this.bio,
    required this.profilePhotoUrl,
    required this.isFollowing,
    required this.stats,
    required this.posts,
    required this.reels,
  });

  factory LeaderDetailsModel.fromJson(Map<String, dynamic> json) {
    return LeaderDetailsModel(
      id: json['id'],
      name: json['name'],
      faith: json['faith'],
      bio: json['bio'],
      profilePhotoUrl: json['profile_photo_url'],
      isFollowing: json['is_following'] ?? false,
      stats: LeaderStats.fromJson(json['stats']),
      posts: (json['posts'] as List)
          .map((e) => LeaderPost.fromJson(e))
          .toList(),
      reels: (json['reels'] as List)
          .map((e) => LeaderReel.fromJson(e))
          .toList(),
    );
  }

  // Add the copyWith method
  LeaderDetailsModel copyWith({
    int? id,
    String? name,
    String? faith,
    String? bio,
    String? profilePhotoUrl,
    bool? isFollowing,
    LeaderStats? stats,
    List<LeaderPost>? posts,
    List<LeaderReel>? reels,
  }) {
    return LeaderDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      faith: faith ?? this.faith,
      bio: bio ?? this.bio,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      isFollowing: isFollowing ?? this.isFollowing,
      stats: stats ?? this.stats,
      posts: posts ?? this.posts,
      reels: reels ?? this.reels,
    );
  }
}

class LeaderStats {
  final int totalFollowers;
  final int totalPosts;
  final int totalReels;

  LeaderStats({
    required this.totalFollowers,
    required this.totalPosts,
    required this.totalReels,
  });

  factory LeaderStats.fromJson(Map<String, dynamic> json) {
    return LeaderStats(
      totalFollowers: json['total_followers'],
      totalPosts: json['total_posts'],
      totalReels: json['total_reels'],
    );
  }
}
class LeaderPost {
  final int id;
  final String? caption;
  final String? mediaUrl;
  final String? mediaType;
  final int? likesCount;
  final int? commentsCount;
  final int? sharesCount;
  final DateTime createdAt;

  LeaderPost({
    required this.id,
    this.caption,
    this.mediaUrl,
    this.mediaType,
    this.likesCount,
    this.commentsCount,
    this.sharesCount,
    required this.createdAt,
  });

  factory LeaderPost.fromJson(Map<String, dynamic> json) {
    return LeaderPost(
      id: json['id'],
      caption: json['caption'],
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
      likesCount: json['likes_count'],
      commentsCount: json['comments_count'],
      sharesCount: json['shares_count'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class LeaderReel {
  final int id;
  final String videoUrl;
  final String? caption;
  final int? likesCount;
  final int? commentsCount;
  final int? sharesCount;
  final int? savesCount; // optional, if you want to use later
  final DateTime createdAt;

  LeaderReel({
    required this.id,
    required this.videoUrl,
    this.caption,
    this.likesCount,
    this.commentsCount,
    this.sharesCount,
    this.savesCount,
    required this.createdAt,
  });

  factory LeaderReel.fromJson(Map<String, dynamic> json) {
    return LeaderReel(
      id: json['id'],
      videoUrl: json['video_url'],
      caption: json['caption'],
      likesCount: json['likes_count'],
      commentsCount: json['comments_count'],
      sharesCount: json['shares_count'],
      savesCount: json['saves_count'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}