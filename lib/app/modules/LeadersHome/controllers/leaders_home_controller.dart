import 'package:faithconnect/app/core/utils/snackbar.dart';
import 'package:faithconnect/app/data/model/follower_model.dart';
import 'package:faithconnect/app/data/model/post_model.dart';
import 'package:faithconnect/app/data/repo/leader_home_repo.dart';
import 'package:get/get.dart';

class LeadersHomeController extends GetxController {
  final LeaderHomeRepository _repo = LeaderHomeRepository();

  /// 0 = Posts, 1 = Followers
  final selectedTab = 0.obs;

  final posts = <PostModel>[].obs;
  final followers = <FollowerModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void changeTab(int index) {
    if (selectedTab.value == index) return;
    selectedTab.value = index;

    if (index == 0) {
      fetchPosts();
    } else {
      fetchFollowers();
    }
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      posts.value = await _repo.getMyPosts();
    } catch (e) {
      CustomSnackbar.error("Failed to load posts");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFollowers() async {
    try {
      isLoading.value = true;
      followers.value = await _repo.getFollowers();
    } catch (e) {
      CustomSnackbar.error("Failed to load followers");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    selectedTab.value == 0 ? fetchPosts() : fetchFollowers();
  }
}
