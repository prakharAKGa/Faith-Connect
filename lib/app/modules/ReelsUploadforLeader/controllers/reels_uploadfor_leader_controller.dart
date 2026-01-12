import 'dart:io';

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

  final captionCtrl = TextEditingController();
  final isUploading = false.obs;
  final uploadProgress = 0.0.obs;

  VideoEditorController? controller;

  static const maxDuration = Duration(seconds: 30);

  Future<void> pickVideo(ImageSource source) async {
    final file = await _picker.pickVideo(source: source);
    if (file == null) return;

    controller = VideoEditorController.file(
      File(file.path),
      maxDuration: maxDuration,
    );

    await controller!.initialize(aspectRatio: 9 / 16);

    if (controller!.videoDuration > maxDuration) {
      Get.snackbar("Error", "Reels must be 30 seconds or less");
      controller?.dispose();
      controller = null;
      return;
    }

    update();
  }

  Future<void> uploadReel() async {
    if (controller == null) {
      Get.snackbar("Error", "No video selected");
      return;
    }

    try {
      isUploading.value = true;
      uploadProgress.value = 0;

      /// 1. Export video
      final File? exported = await VideoExporter.exportReel(controller!);

      if (exported == null || !exported.existsSync()) {
        throw "Exported file missing or failed";
      }

      final fileSize = exported.lengthSync();
      if (fileSize < 100 * 1024) {
        throw "Exported video is corrupted (${fileSize} bytes)";
      }

      print("✅ Export OK: ${exported.path} (${fileSize} bytes)");

      /// 2. Upload to Cloudinary
      final videoUrl = await CloudinaryUpload.uploadVideo(
        exported,
        type: CloudinaryUploadType.reel,
      );

      if (videoUrl == null || videoUrl.isEmpty) {
        throw "Cloudinary upload failed";
      }

      /// 3. Save reel to backend
      await _api.post("/api/reels", data: {
        "video_url": videoUrl,
        "caption": captionCtrl.text.trim(),
      });

      /// Success 🎉
      Get.snackbar(
        "Success",
        "Reel uploaded successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Navigate back to bottom nav bar route
      Get.offNamed(Routes.BOTTOM_NAV_FOR_LEADERS); // ← Change '/home' to your actual bottom nav route

    } catch (e) {
      print("Upload error: $e");
      // Get.snackbar(
      //   "Upload Failed",
      //   e.toString(),
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0;
    }
  }

  @override
  void onClose() {
    controller?.dispose();
    captionCtrl.dispose();
    super.onClose();
  }
}