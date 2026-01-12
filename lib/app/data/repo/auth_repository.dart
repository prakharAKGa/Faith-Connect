import 'package:dio/dio.dart';
import 'package:faithconnect/app/core/config/api_config.dart';
import 'package:faithconnect/app/core/services/api_service.dart';
import 'package:faithconnect/app/data/model/auth_response.dart';
import 'package:faithconnect/app/data/model/signup_request.dart';


class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final Response response = await _apiService.post(
      AppUrl.login,
      data: {
        "email": email,
        "password": password,
      },
    );

    return AuthResponse.fromJson(response.data);
  }
    Future<void> register(SignUpRequest request) async {
    await _apiService.post(
      "/api/auth/register",
      data: request.toJson(),
    );
  }
   Future<void> saveFcmToken(String token) async {
    await _apiService.post(
      "/api/users/fcm-token",
      data: {
        "fcmToken": token,
      },
    );
  }
}
