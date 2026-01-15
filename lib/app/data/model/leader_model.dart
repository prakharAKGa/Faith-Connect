class LeaderModel {
  final int id;
  final String name;
  final String faith;
  final String? bio;
  final String? profilePhotoUrl;

  bool isFollowing; // mutable → we change this on toggle

  LeaderModel({
    required this.id,
    required this.name,
    required this.faith,
    this.bio,
    this.profilePhotoUrl,
    this.isFollowing = false,
  });

  factory LeaderModel.fromJson(Map<String, dynamic> json) {
    return LeaderModel(
      id: json['id'] as int,
      name: json['name'] as String,
      faith: json['faith'] as String,
      bio: json['bio'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      isFollowing: (json['is_followed'] as int? ?? 0) == 1, // ← 1 = true, 0/null = false
    );
  }
}