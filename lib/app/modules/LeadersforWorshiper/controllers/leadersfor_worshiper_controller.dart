import 'package:faithconnect/app/data/model/leader_model.dart';
import 'package:faithconnect/app/data/repo/leader_repository.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LeadersforWorshiperController extends GetxController {
  final LeaderRepository _repo = LeaderRepository();

  final leaders = <LeaderModel>[].obs;
  final filteredLeaders = <LeaderModel>[].obs;

  final isLoading = false.obs;
  final selectedTab = 0.obs; // 0 = My Leaders, 1 = Explore
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentTab();
    ever(searchQuery, (_) => applyFilters());
    ever(selectedTab, (_) => fetchCurrentTab());
  }

  Future<void> fetchCurrentTab() async {
    try {
      isLoading.value = true;

      if (selectedTab.value == 0) {
        leaders.value = await _repo.getMyFollowing();
      } else {
        leaders.value = await _repo.getAllLeaders();
      }

      applyFilters();
    } catch (e) {
      Get.snackbar("Error", "Failed to load leaders");
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    var list = [...leaders];

    if (searchQuery.isNotEmpty) {
      list = list
          .where((l) =>
              l.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    filteredLeaders.assignAll(list);
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  /// Instant toggle with optimistic update + rollback on error
  Future<void> toggleFollow(LeaderModel leader) async {
    // Only allow follow/unfollow in Explore tab
    if (!isExplore) return;

    final wasFollowing = leader.isFollowing;

    try {
      // Optimistic update (instant UI change)
      leader.isFollowing = !wasFollowing;
      leaders.refresh(); // Force UI rebuild
      applyFilters();

      // Call backend
      if (leader.isFollowing) {
        await _repo.followLeader(leader.id);
        Get.snackbar("Success", "Following ${leader.name}");
      } else {
        await _repo.unfollowLeader(leader.id);
        Get.snackbar("Success", "Unfollowed ${leader.name}");
      }
    } catch (e) {
      // Rollback on error
      leader.isFollowing = wasFollowing;
      leaders.refresh();
      applyFilters();
      Get.snackbar("Error", "Failed to update follow status");
    }
  }

  bool get isExplore => selectedTab.value == 1;

  void openChat(LeaderModel leader) {
    Get.toNamed(
      Routes.WORSHIPER_CHAT_WITH_LEADERS,
      arguments: {
        'leaderId': leader.id,
        'leaderName': leader.name,
        'leaderPhoto': leader.profilePhotoUrl,
      },
    );
  }
}