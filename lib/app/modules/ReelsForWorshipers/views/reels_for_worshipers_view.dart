import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../components/reel_video_player.dart';
import '../controllers/reels_for_worshipers_controller.dart';

class ReelsForWorshipersView extends GetView<ReelsForWorshipersController> {
  const ReelsForWorshipersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reels",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Upload reel
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.reels.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchReels,
          color: Colors.white,
          backgroundColor: Colors.black87,
          displacement: 60,
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controller.reels.length + (controller.isLoading.value ? 1 : 0),
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              // Show loading at the end while fetching more (optional future improvement)
              if (index == controller.reels.length) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }

              final reel = controller.reels[index];

              if (reel.videoUrl == null || reel.videoUrl!.trim().isEmpty) {
                return const Center(
                  child: Text("No video available", style: TextStyle(color: Colors.white70)),
                );
              }

              return Stack(
                fit: StackFit.expand,
                children: [
                  // Video with forced vertical feel
                  ReelVideoPlayer(
                    url: reel.videoUrl!,
                    leaderId: reel.leaderId,
                    leaderName: reel.leaderName,
                    leaderPhoto: reel.leaderPhoto,
                    caption: reel.caption,
                    isVerified:  true,
                  ),

                  // Bottom dark gradient
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 260,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.92),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Right side action buttons
                  Positioned(
                    right: 16,
                    bottom: 160,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ActionButton(
                          icon: controller.isLiked(reel.id)
                              ? Iconsax.heart5
                              : Iconsax.heart,
                          count: reel.likesCount,
                          color: controller.isLiked(reel.id)
                              ? Colors.redAccent
                              : Colors.white,
                          onTap: () => controller.likeReel(reel),
                        ),
                        _ActionButton(
                          icon: Iconsax.message_text,
                          count: reel.commentsCount,
                          color: Colors.white,
                          onTap: () => controller.openComments(reel),
                        ),
                        _ActionButton(
                          icon: Iconsax.repeat,
                          count: reel.sharesCount,
                          color: Colors.white,
                          onTap: () => controller.shareReel(reel),
                        ),
                        _ActionButton(
                          icon: controller.isSaved(reel.id)
                              ? Iconsax.save_add5
                              : Iconsax.save_add,
                          count: reel.savesCount,
                          color: controller.isSaved(reel.id)
                              ? Colors.yellowAccent
                              : Colors.white,
                          onTap: () => controller.saveReel(reel),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, color: color, size: 38),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}