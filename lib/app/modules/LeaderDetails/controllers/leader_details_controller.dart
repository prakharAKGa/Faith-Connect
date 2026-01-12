import 'package:faithconnect/app/data/model/leader_details_model.dart';
import 'package:faithconnect/app/data/repo/leader_repository.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaderDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final LeaderRepository _repo = LeaderRepository();

  // Loading & Data
  final isLoading = true.obs;
  final leader = Rxn<LeaderDetailsModel>();

  late int leaderId;

  // Tab Controller for Posts / Reels
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();

    // Initialize tabs
    tabController = TabController(length: 2, vsync: this);

    // Get leader ID from arguments
    leaderId = Get.arguments as int;

    // Load data
    fetchLeaderProfile();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchLeaderProfile() async {
    try {
      isLoading.value = true;
      final result = await _repo.getLeaderDetails(leaderId);
      leader.value = result;
    } catch (e) {
      // You can show error snackbar/message here if you want
      print("Error fetching leader profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔁 FOLLOW / UNFOLLOW (REAL TIME)
  Future<void> toggleFollow() async {
    if (leader.value == null) return;

    final currentFollowing = leader.value!.isFollowing;

    try {
      if (currentFollowing) {
        await _repo.unfollowLeader(leaderId);
      } else {
        await _repo.followLeader(leaderId);
      }

      // Optimistic update + real count change
      leader.update((l) {
        if (l == null) return;

        final newFollowing = !currentFollowing;
        final followersChange = newFollowing ? 1 : -1;

        l.isFollowing = newFollowing;
        l.stats = LeaderStats(
          totalFollowers: l.stats.totalFollowers + followersChange,
          totalPosts: l.stats.totalPosts,
          totalReels: l.stats.totalReels,
        );
      });
    } catch (e) {
      // Optional: rollback or show error
      print("Follow/Unfollow failed: $e");
      Get.snackbar(
        "Error",
        "Could not update follow status. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void openChat() {
    final currentLeader = leader.value;
    if (currentLeader == null) return;

    Get.toNamed(
      Routes.WORSHIPER_CHAT_WITH_LEADERS,
      arguments: {
        'leaderId': currentLeader.id,
        'leaderName': currentLeader.name,
        'leaderPhoto': currentLeader.profilePhotoUrl,
      },
    );
  }

  // Optional: Refresh method (useful for pull-to-refresh later)
  Future<void> refreshProfile() async {
    await fetchLeaderProfile();
  }
}