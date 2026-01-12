// lib/app/modules/PostUpload/views/post_upload_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/post_upload_controller.dart';

class PostUploadView extends GetView<PostUploadController> {
  const PostUploadView({super.key});

  // Height occupied by FloatingBottomNav
  static const double _bottomNavSpace = 90;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
      ),

      body: Stack(
        children: [
          /// ───────── MAIN SCROLLABLE CONTENT ─────────
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                _bottomNavSpace + 80, // 🔥 KEY FIX
              ),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ───────── CAPTION ─────────
                    TextField(
                      controller: controller.captionCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        filled: true,
                        fillColor: scheme.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// ───────── MEDIA PREVIEW ─────────
                    if (controller.selectedFile.value != null)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: controller.mediaType.value ==
                                    PostMediaType.image
                                ? Image.file(
                                    controller.selectedFile.value!,
                                    height: 220,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 220,
                                    alignment: Alignment.center,
                                    color: Colors.black12,
                                    child: const Icon(
                                      Icons.videocam,
                                      size: 64,
                                    ),
                                  ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: controller.removeMedia,
                            ),
                          ),
                        ],
                      ),

                    if (controller.selectedFile.value != null)
                      const SizedBox(height: 16),

                    /// ───────── PICK BUTTONS ─────────
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.image),
                            label: const Text("Image"),
                            onPressed: controller.pickImage,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.videocam),
                            label: const Text("Video"),
                            onPressed: controller.pickVideo,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// ───────── UPLOAD PROGRESS ─────────
                    if (controller.isUploading.value)
                      Column(
                        children: [
                          LinearProgressIndicator(
                            value: controller.uploadProgress.value == 0
                                ? null
                                : controller.uploadProgress.value,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Uploading...",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                  ],
                );
              }),
            ),
          ),

          /// ───────── FIXED POST BUTTON (ABOVE BOTTOM NAV) ─────────
          Positioned(
            left: 16,
            right: 16,
            bottom: _bottomNavSpace, // 🔥 ABOVE FLOATING NAV
            child: SafeArea(
              top: false,
              child: Obx(
                () => SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: controller.isUploading.value
                        ? null
                        : controller.uploadPost,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isUploading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Post",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
