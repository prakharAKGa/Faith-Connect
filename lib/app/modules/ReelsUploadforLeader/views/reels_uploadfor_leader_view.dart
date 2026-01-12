import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_editor/video_editor.dart';

import '../controllers/reels_uploadfor_leader_controller.dart';

class ReelsUploadforLeaderView extends GetView<ReelsUploadforLeaderController> {
  const ReelsUploadforLeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Reel"),
        centerTitle: true,
      ),

      /// ───────── BODY ─────────
      body: Column(
        children: [
          /// ───────── MAIN CONTENT ─────────
          Expanded(
            child: GetBuilder<ReelsUploadforLeaderController>(
              builder: (controller) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// ───────── VIDEO PREVIEW / TRIMMER ─────────
                      if (controller.controller != null) ...[
                        AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: theme.dividerColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CropGridViewer.preview(
                                controller: controller.controller!,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TrimSlider(
                          controller: controller.controller!,
                          height: 60,
                        ),
                      ]

                      /// ───────── EMPTY STATE ─────────
                      else
                        Container(
                          height: 320,
                          decoration: BoxDecoration(
                            color:
                                theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: theme.dividerColor),
                          ),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.video_collection_outlined,
                                size: 80,
                                color: theme
                                    .colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No video selected",
                                style:
                                    theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Choose from Gallery or Camera",
                                style:
                                    theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),

                      /// ───────── PICK BUTTONS ─────────
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(
                                  Icons.photo_library_outlined),
                              label: const Text("Gallery"),
                              onPressed: () => controller.pickVideo(
                                  ImageSource.gallery),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(
                                  Icons.videocam_outlined),
                              label: const Text("Camera"),
                              onPressed: () => controller.pickVideo(
                                  ImageSource.camera),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
          ),

          /// ───────── BOTTOM ACTION AREA ─────────
          SafeArea(
            top: false,
            child: Padding(
              // 🔥 KEY FIX — prevents bottom nav overlap
              padding: EdgeInsets.only(
                bottom: bottomInset + 72,
              ),
              child: Container(
                padding:
                    const EdgeInsets.fromLTRB(16, 16, 16, 24),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(color: theme.dividerColor),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// ───────── PROGRESS ─────────
                    Obx(
                      () => controller.isUploading.value
                          ? Column(
                              children: [
                                LinearProgressIndicator(
                                  value: controller
                                              .uploadProgress
                                              .value ==
                                          0
                                      ? null
                                      : controller.uploadProgress
                                          .value,
                                  minHeight: 8,
                                  borderRadius:
                                      BorderRadius.circular(4),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${(controller.uploadProgress.value * 100).toStringAsFixed(0)}% uploaded",
                                  style:
                                      theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 12),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    /// ───────── UPLOAD BUTTON ─────────
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: Obx(
                        () => ElevatedButton.icon(
                          icon: controller.isUploading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.cloud_upload),
                          label: Text(
                            controller.isUploading.value
                                ? "Uploading..."
                                : "Upload Reel",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: controller.isUploading.value
                              ? null
                              : controller.uploadReel,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
