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

  /// 🚫 No unfollow in My Leaders
  Future<void> toggleFollow(LeaderModel leader) async {
    if (selectedTab.value == 0) return;

    if (leader.isFollowing) {
      await _repo.unfollowLeader(leader.id);
      leader.isFollowing = false;
    } else {
      await _repo.followLeader(leader.id);
      leader.isFollowing = true;
    }

    leaders.refresh();
    applyFilters();
  }

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
