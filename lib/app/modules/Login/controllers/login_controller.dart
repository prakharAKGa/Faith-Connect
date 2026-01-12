import 'package:faithconnect/app/core/config/token_storage.dart';
import 'package:faithconnect/app/core/services/fcm_service.dart';
import 'package:faithconnect/app/data/repo/auth_repository.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepository _repository = AuthRepository();
  final TokenStorage _storage = TokenStorage();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await _repository.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save token → this will also decode JWT and save user ID + role
      await _storage.saveAuthToken(response.token);

      // Get role and user ID (now stored securely)
      final role = await _storage.getRole();
      final userId = await _storage.getUserId(); // NEW: available for future use

      // Optional: You can debug-print or use userId anywhere now
      debugPrint("Logged in as User ID: $userId, Role: $role");

      final fcmToken = await FcmService.getToken();

      /// 4️⃣ SAVE FCM TOKEN TO BACKEND
      if (fcmToken != null) {
        await _repository.saveFcmToken(fcmToken);
      }

      /// 🔀 ROLE BASED ROUTING (unchanged)
      if (role == "LEADER") {
        Get.offAllNamed(Routes.BOTTOM_NAV_FOR_LEADERS);
      } else {
        Get.offAllNamed(Routes.BOTTOM_NAV);
      }
    } catch (e) {
      // Get.snackbar(
      //   "Login Failed",
      //   e.toString(),
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    } finally {
      isLoading.value = false;
    }
  }
}