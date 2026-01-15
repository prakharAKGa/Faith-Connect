import 'dart:io';

import 'package:faithconnect/app/core/config/token_storage.dart';
import 'package:faithconnect/app/core/services/api_service.dart';
import 'package:faithconnect/app/core/utils/cloudinary_upload.dart';
import 'package:faithconnect/app/modules/ReelsUploadforLeader/components/video_exporter.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_editor/video_editor.dart';


class ReelsUploadforLeaderController extends GetxController {
  final ApiService _api = ApiService();
  final ImagePicker _picker = ImagePicker();
  final TokenStorage _tokenStorage = TokenStorage(); // ← Added

  final captionCtrl = TextEditingController();
  final isUploading = false.obs;
  final uploadProgress = 0.0.obs;

  VideoEditorController? controller;

  static const maxDuration = Duration(seconds: 30);

  /// Pick video from gallery or camera
  Future<void> pickVideo(ImageSource source) async {
    final file = await _picker.pickVideo(source: source);
    if (file == null) return;

    controller?.dispose(); // Clean up previous controller
    controller = VideoEditorController.file(
      File(file.path),
      maxDuration: maxDuration,
    );

    await controller!.initialize(aspectRatio: 9 / 16);

    if (controller!.videoDuration > maxDuration) {
      Get.snackbar(
        "Error",
        "Reels must be 30 seconds or less",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      controller?.dispose();
      controller = null;
      update();
      return;
    }

    update(); // Refresh UI to show video preview
  }

  /// Main upload function with leader_id workaround
  Future<void> uploadReel() async {
    if (controller == null) {
      Get.snackbar("Error", "Please select a video first");
      return;
    }

    // Optional: You can make caption required if you want
    if (captionCtrl.text.trim().isEmpty) {
      Get.snackbar("Hint", "Adding a caption is recommended");
      // return; // ← uncomment if you want to force caption
    }

    try {
      isUploading.value = true;
      uploadProgress.value = 0;

      // 1. Export the trimmed & cropped video
      final File? exported = await VideoExporter.exportReel(controller!);

      if (exported == null || !await exported.exists()) {
        throw "Video export failed";
      }

      final fileSize = await exported.length();
      if (fileSize < 100 * 1024) {
        throw "Exported video seems corrupted (${fileSize} bytes)";
      }

      print("✅ Exported: ${exported.path} (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)");

      // 2. Upload to Cloudinary
      final videoUrl = await CloudinaryUpload.uploadVideo(
        exported,
        type: CloudinaryUploadType.reel,
      );

      if (videoUrl == null || videoUrl.isEmpty) {
        throw "Failed to upload video to cloud";
      }

      // 3. Get current user ID from secure storage (from JWT)
      final userIdStr = await _tokenStorage.getUserId();

      if (userIdStr == null || userIdStr.isEmpty) {
        throw "Authentication error: User ID not found. Please login again.";
      }

      final leaderId = int.tryParse(userIdStr);
      if (leaderId == null) {
        throw "Invalid user ID format";
      }

      // 4. Save reel to backend - **temporary workaround** sending leader_id
      await _api.post("/api/reels", data: {
       "user_id": leaderId,                     // ← This fixes the null error
        "video_url": videoUrl,
        "caption": captionCtrl.text.trim(),
      });

      // ───────── SUCCESS ─────────
      Get.snackbar(
        "Success!",
        "Your reel has been uploaded",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      // Reset form and navigate back
      _resetForm();
      Get.offNamed(Routes.BOTTOM_NAV_FOR_LEADERS);

    } catch (e, stack) {
      print("Upload error: $e");
      print(stack);

      Get.snackbar(
        "Upload Failed",
        e.toString().length > 120 ? "Something went wrong. Try again." : e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0;
    }
  }

  /// Reset form to initial state
  void _resetForm() {
    controller?.dispose();
    controller = null;
    captionCtrl.clear();
    update(); // Refresh UI → show empty state
  }

  @override
  void onClose() {
    controller?.dispose();
    captionCtrl.dispose();
    super.onClose();
  }
}