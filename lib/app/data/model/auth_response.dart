class AuthResponse {
  final bool success;
  final String token;

  AuthResponse({
    required this.success,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      token: json['token'] ?? '',
    );
  }
}
