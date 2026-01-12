// lib/app/modules/PostUpload/controllers/post_upload_controller.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/cloudinary_upload.dart';
import '../../../core/utils/snackbar.dart';
enum PostMediaType { image, video }


class PostUploadController extends GetxController {
  final ApiService _api = ApiService();
  final ImagePicker _picker = ImagePicker();

  final captionCtrl = TextEditingController();

  final selectedFile = Rx<File?>(null);
  final mediaType = Rx<PostMediaType?>(null);

  final isUploading = false.obs;
  final uploadProgress = 0.0.obs;

  /// ───────── PICK IMAGE ─────────
  Future<void> pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    selectedFile.value = File(file.path);
    mediaType.value = PostMediaType.image;
  }

  /// ───────── PICK VIDEO ─────────
  Future<void> pickVideo() async {
    final file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;

    selectedFile.value = File(file.path);
    mediaType.value = PostMediaType.video;
  }

  void removeMedia() {
    selectedFile.value = null;
    mediaType.value = null;
  }

  /// ───────── UPLOAD POST ─────────
  Future<void> uploadPost() async {
    if (captionCtrl.text.trim().isEmpty &&
        selectedFile.value == null) {
      CustomSnackbar.error("Post cannot be empty");
      return;
    }

    try {
      isUploading.value = true;
      uploadProgress.value = 0;

      String? mediaUrl;
      String? mediaTypeString;

      /// 1️⃣ Upload media if exists
      if (selectedFile.value != null && mediaType.value != null) {
        if (mediaType.value == PostMediaType.image) {
          mediaUrl = await CloudinaryUpload.uploadImage(
            selectedFile.value!,
            type: CloudinaryUploadType.postImage,
          );
          mediaTypeString = "IMAGE";
        } else {
          mediaUrl = await CloudinaryUpload.uploadVideo(
            selectedFile.value!,
            type: CloudinaryUploadType.postVideo,
          );
          mediaTypeString = "VIDEO";
        }

        if (mediaUrl == null) {
          throw "Media upload failed";
        }
      }

      /// 2️⃣ Send post data
      await _api.post(
        "/api/posts",
        data: {
          "caption": captionCtrl.text.trim(),
          if (mediaUrl != null) "media_url": mediaUrl,
          if (mediaTypeString != null) "media_type": mediaTypeString,
        },
      );

      CustomSnackbar.success("Post created successfully");
      Get.back(result: true);
    } catch (e) {
      CustomSnackbar.error("Failed to create post");
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0;
    }
  }

  @override
  void onClose() {
    captionCtrl.dispose();
    super.onClose();
  }
}
