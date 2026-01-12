import 'package:faithconnect/app/core/utils/snackbar.dart';
import 'package:faithconnect/app/data/model/post_model.dart';
import 'package:faithconnect/app/data/repo/post_action_repository.dart';
import 'package:faithconnect/app/data/repo/post_repository.dart';
import 'package:get/get.dart';

class WorshiperHomeController extends GetxController {
  final PostRepository _repo = PostRepository();
  final PostActionRepository _actionRepo = PostActionRepository();

  /// Posts list
  final posts = <PostModel>[].obs;

  /// UI states
  final isLoading = false.obs;

  /// 0 = Explore, 1 = Following
  final selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  // ───────────────────────── FETCH POSTS
  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;

      final List<PostModel> result =
          selectedTab.value == 0
              ? await _repo.getExplorePosts()
              : await _repo.getFollowingPosts();

      posts.assignAll(result);
    } catch (e) {
      CustomSnackbar.error("Failed to load feed");
    } finally {
      isLoading.value = false;
    }
  }

  /// Pull-to-refresh
  Future<void> refreshFeed() async {
    await fetchPosts();
  }

  // ───────────────────────── TAB CHANGE
  void changeTab(int index) {
    if (selectedTab.value == index) return;
    selectedTab.value = index;
    fetchPosts();
  }

  // ───────────────────────── POST ACTIONS

  Future<void> like(PostModel post) async {
    try {
      await _actionRepo.likePost(post.id);
      await fetchPosts(); // ✅ re-fetch updated counts
    } catch (e) {
      CustomSnackbar.error("Failed to like post");
    }
  }

  Future<void> share(PostModel post) async {
    try {
      await _actionRepo.sharePost(post.id);
      await fetchPosts(); // ✅ re-fetch
    } catch (e) {
      CustomSnackbar.error("Failed to share post");
    }
  }

  Future<void> comment(PostModel post, String text) async {
    if (text.trim().isEmpty) return;

    try {
      await _actionRepo.commentPost(post.id, text);
      await fetchPosts(); // ✅ re-fetch
    } catch (e) {
      CustomSnackbar.error("Failed to add comment");
    }
  }
}
