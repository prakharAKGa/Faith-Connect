class ProfileModel {
  final int id;
  final String name;
  final String role;
  final String? faith;
  final String? bio;
  final String? profilePhoto;
  final ProfileStats stats;

  ProfileModel({
    required this.id,
    required this.name,
    required this.role,
    this.faith,
    this.bio,
    this.profilePhoto,
    required this.stats,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      faith: json['faith'],
      bio: json['bio'],
      profilePhoto: json['profile_photo_url'],
      stats: ProfileStats.fromJson(json['stats'] ?? {}),
    );
  }
}

class ProfileStats {
  // Leader
  final int? totalPosts;
  final int? totalReels;
  final int? totalFollowers;

  // Worshiper
  final int? totalFollowing;
  final int? totalLikes;
  final int? totalComments;

  ProfileStats({
    this.totalPosts,
    this.totalReels,
    this.totalFollowers,
    this.totalFollowing,
    this.totalLikes,
    this.totalComments,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      totalPosts: json['total_posts'],
      totalReels: json['total_reels'],
      totalFollowers: json['total_followers'],
      totalFollowing: json['total_following'],
      totalLikes: json['total_likes'],
      totalComments: json['total_comments'],
    );
  }
}
