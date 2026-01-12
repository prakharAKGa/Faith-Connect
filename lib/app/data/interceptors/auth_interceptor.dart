// app/data/interceptors/auth_interceptor.dart

import 'package:dio/dio.dart';
import 'package:faithconnect/app/core/config/token_storage.dart';
import 'package:faithconnect/app/core/utils/snackbar.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:get/get.dart';


class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // options.headers['x-api-key'] = 'your_super_secret_key_123456';

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 - Unauthorized (token expired or invalid)
    if (err.response?.statusCode == 401) {
      CustomSnackbar.error("Session expired. Please log in again.");

      // Clear all stored auth data
      await _tokenStorage.clear();

      // Redirect to login
      Get.offAllNamed(Routes.LOGIN);
    }

    // Always pass the error forward
    handler.next(err);
  }
}