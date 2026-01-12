class SignUpRequest {
  final String role;
  final String name;
  final String email;
  final String password;
  final String faith;
  final String? profilePhotoUrl;
  final String? bio;

  SignUpRequest({
    required this.role,
    required this.name,
    required this.email,
    required this.password,
    required this.faith,
    this.profilePhotoUrl,
    this.bio,
  });

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "name": name,
      "email": email,
      "password": password,
      "faith": faith,
      "profile_photo_url": profilePhotoUrl,
      "bio": bio,
    };
  }
}
