import 'dart:io';

import 'package:faithconnect/app/core/utils/cloudinary_upload.dart';
import 'package:faithconnect/app/core/utils/snackbar.dart';
import 'package:faithconnect/app/data/model/signup_request.dart';
import 'package:faithconnect/app/data/repo/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Faith {
  hindu,
  muslim,
  christian,
  sikh,
  buddhist,
  jain,
  other,
}

extension FaithX on Faith {
  /// Value sent to backend (DB-safe)
  String get apiValue {
    switch (this) {
      case Faith.hindu:
        return "Hinduism";
      case Faith.muslim:
        return "Islam";
      case Faith.christian:
        return "Christianity";
      case Faith.sikh:
        return "Sikhism";
      case Faith.buddhist:
        return "Buddhism";
      case Faith.jain:
        return "Jainism";
      case Faith.other:
        return "Other";
    }
  }

  /// Value shown in UI
  String get label {
    switch (this) {
      case Faith.hindu:
        return "Hinduism";
      case Faith.muslim:
        return "Islam";
      case Faith.christian:
        return "Christianity";
      case Faith.sikh:
        return "Sikhism";
      case Faith.buddhist:
        return "Buddhism";
      case Faith.jain:
        return "Jainism";
      case Faith.other:
        return "Other";
    }
  }
}

class SignUpController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final bioCtrl = TextEditingController();

  final Rx<File?> profileImage = Rx<File?>(null);
 final List<String> selectedFaithList = Faith.values.map((f) => f.label).toList();

final Rx<Faith?> selectedFaith = Rx<Faith?>(null);
final List<Faith> faithOptions = Faith.values;

  final RxBool isLoading = false.obs;

  void setProfileImage(File file) {
    profileImage.value = file;
  }

  Future<void> signUpLeader() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty ||
        bioCtrl.text.isEmpty ||
        selectedFaith.value == null) {
      CustomSnackbar.error("Please fill all required fields");
      return;
    }

    isLoading.value = true;

    try {
      String? imageUrl;

      if (profileImage.value != null) {
        imageUrl = await CloudinaryUpload.uploadImage(
          profileImage.value!,
          type: CloudinaryUploadType.profile,
        );
      }

      final request = SignUpRequest(
        role: "LEADER",
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
        bio: bioCtrl.text.trim(),
        faith: selectedFaith.value!.apiValue,
        profilePhotoUrl: imageUrl,
      );

      await _repo.register(request);

      CustomSnackbar.success("Leader account created successfully");
      Get.offAllNamed('/login');
    } catch (e) {
      // CustomSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    bioCtrl.dispose();
    super.onClose();
  }
}
