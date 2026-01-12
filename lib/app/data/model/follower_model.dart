class FollowerModel {
  final int id;
  final String name;
  final String? profilePhotoUrl;
  final String? faith;  // ← Added faith field (nullable)

  FollowerModel({
    required this.id,
    required this.name,
    this.profilePhotoUrl,
    this.faith,  // ← Can be null if not provided by API
  });

  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    return FollowerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      faith: json['faith'] as String?,  // ← Safe parsing (null if missing)
    );
  }
}