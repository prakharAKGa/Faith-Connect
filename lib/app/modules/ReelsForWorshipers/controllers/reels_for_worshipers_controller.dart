import 'package:faithconnect/app/data/model/reel_model.dart';
import 'package:faithconnect/app/data/repo/reels_repository.dart';
import 'package:faithconnect/app/modules/ReelsForWorshipers/components/reel_comments_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReelsForWorshipersController extends GetxController {
  final ReelsRepository _repo = ReelsRepository();

  final reels = <ReelModel>[].obs;
  final isLoading = true.obs;
  final currentIndex = 0.obs;

  // Local UI states (per reel/leader ID)
  final likedReels = <int, bool>{}.obs;       // reelId → isLiked
  final savedReels = <int, bool>{}.obs;       // reelId → isSaved
  final followingLeaders = <int, bool>{}.obs; // leaderId → isFollowing

  @override
  void onInit() {
    super.onInit();
    fetchReels();
  }

  Future<void> fetchReels() async {
    try {
      isLoading.value = true;
      reels.value = await _repo.getReels();

      // Reset local states
      likedReels.clear();
      savedReels.clear();
      followingLeaders.clear();
    } catch (e) {
      Get.snackbar("Error", "Failed to load reels", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  // Like / Unlike
  Future<void> likeReel(ReelModel reel) async {
    final reelId = reel.id;
    final wasLiked = likedReels[reelId] ?? false;

    try {
      likedReels[reelId] = !wasLiked;
      reel.likesCount += wasLiked ? -1 : 1;
      reels.refresh();

      await _repo.like(reelId);

      Get.snackbar(
        !wasLiked ? "Liked" : "Unliked",
        !wasLiked ? "Reel liked" : "Reel unliked",
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      likedReels[reelId] = wasLiked;
      reel.likesCount += wasLiked ? 1 : -1;
      reels.refresh();
      Get.snackbar("Error", "Failed to like/unlike", backgroundColor: Colors.red);
    }
  }

  // Share
  Future<void> shareReel(ReelModel reel) async {
    try {
      await _repo.share(reel.id);
      reel.sharesCount += 1;
      reels.refresh();
      Get.snackbar("Shared", "Reel shared!", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", "Failed to share", backgroundColor: Colors.red);
    }
  }

  // Save / Unsave
  Future<void> saveReel(ReelModel reel) async {
    final reelId = reel.id;
    final wasSaved = savedReels[reelId] ?? false;

    try {
      savedReels[reelId] = !wasSaved;
      reel.savesCount += wasSaved ? -1 : 1;
      reels.refresh();

      await _repo.save(reelId);

      Get.snackbar(
        !wasSaved ? "Saved" : "Unsaved",
        !wasSaved ? "Added to bookmarks" : "Removed from bookmarks",
      );
    } catch (e) {
      savedReels[reelId] = wasSaved;
      reel.savesCount += wasSaved ? 1 : -1;
      reels.refresh();
      Get.snackbar("Error", "Failed to save", backgroundColor: Colors.red);
    }
  }

  void openComments(ReelModel reel) {
    Get.bottomSheet(
      ReelCommentsSheet(reelId: reel.id),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Follow / Unfollow
  Future<void> followLeader(int leaderId) async {
    final wasFollowing = followingLeaders[leaderId] ?? false;

    try {
      followingLeaders[leaderId] = !wasFollowing;
      await _repo.followLeader(leaderId);

      Get.snackbar(
        !wasFollowing ? "Following" : "Unfollowed",
        !wasFollowing ? "Now following" : "Unfollowed",
        backgroundColor: !wasFollowing ? Colors.green : Colors.grey,
      );
    } catch (e) {
      followingLeaders[leaderId] = wasFollowing;
      Get.snackbar("Error", "Failed to follow/unfollow", backgroundColor: Colors.red);
    }
  }

  // Helpers for view
  bool isLiked(int reelId) => likedReels[reelId] ?? false;
  bool isSaved(int reelId) => savedReels[reelId] ?? false;
  bool isFollowing(int leaderId) => followingLeaders[leaderId] ?? false;
}