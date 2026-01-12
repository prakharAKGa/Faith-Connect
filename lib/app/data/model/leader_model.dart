class LeaderModel {
  final int id;
  final String name;
  final String faith;
  final String? bio;
  final String? profilePhotoUrl;

  bool isFollowing;

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
      id: json['id'],
      name: json['name'],
      faith: json['faith'],
      bio: json['bio'],
      profilePhotoUrl: json['profile_photo_url'],
      isFollowing: json['is_following'] ?? false,
    );
  }
}