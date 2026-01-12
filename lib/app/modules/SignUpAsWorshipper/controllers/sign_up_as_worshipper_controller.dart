import 'dart:io';

import 'package:faithconnect/app/core/utils/cloudinary_upload.dart';
import 'package:faithconnect/app/core/utils/snackbar.dart';
import 'package:faithconnect/app/data/model/signup_request.dart';
import 'package:faithconnect/app/data/repo/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpAsWorshipperController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final ImagePicker _picker = ImagePicker();

  // Text controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  // State
  final RxString selectedFaith = ''.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;

  final List<String> faiths = [
    'Christianity',
    'Islam',
    'Judaism',
    'Hinduism',
    'Other',
  ];

  // --------------------------------------------------
  // 📸 IMAGE PICKER
  // --------------------------------------------------
  Future<void> pickProfileImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // Good balance of quality & size
    );

    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  // --------------------------------------------------
  // 🧾 SIGN UP
  // --------------------------------------------------
  Future<void> signUp() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty ||
        selectedFaith.value.isEmpty) {
      CustomSnackbar.error("Please fill all required fields");
      return;
    }

    isLoading.value = true;

    try {
      String? imageUrl;

      // ☁️ Upload profile image to Cloudinary
      if (profileImage.value != null) {
        imageUrl = await CloudinaryUpload.uploadImage(
          profileImage.value!,
          type: CloudinaryUploadType.profile,
        );
      }

      final request = SignUpRequest(
        role: "WORSHIPER",
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
        faith: selectedFaith.value,
        profilePhotoUrl: imageUrl,
      );

      await _repo.register(request);

      CustomSnackbar.success("Account created successfully");
      Get.offAllNamed('/login');
    } catch (e) {
      // CustomSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------------------------------
  // ♻ CLEANUP
  // --------------------------------------------------
  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
