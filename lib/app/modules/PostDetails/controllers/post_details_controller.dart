import 'package:faithconnect/app/data/model/post_comments_model.dart';
import 'package:faithconnect/app/data/model/post_model.dart';
import 'package:faithconnect/app/data/repo/post_action_repository.dart';
import 'package:faithconnect/app/data/repo/post_details_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDetailsController extends GetxController {
  final PostModel post;
  PostDetailsController(this.post);

  final PostDetailsRepository _repo = PostDetailsRepository();
  final PostActionRepository _actionRepo = PostActionRepository();

  final comments = <PostCommentModel>[].obs;
  final isLoading = true.obs;

  final commentCtrl = TextEditingController();

  // Client-side states for real-time UI updates
  final isLiked = false.obs;           // Whether current user liked the post
  final likesCount = 0.obs;            // Dynamic like count
  final sharesCount = 0.obs;           // Dynamic share count

  @override
  void onInit() {
    super.onInit();
    // Initialize with post data
    likesCount.value = post.likesCount;
    sharesCount.value = post.sharesCount;
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      isLoading.value = true;
      comments.value = await _repo.getComments(post.id);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment() async {
    final text = commentCtrl.text.trim();
    if (text.isEmpty) return;

    try {
      await _repo.addComment(post.id, text);
      commentCtrl.clear();
      await fetchComments(); // Refresh comments
    } catch (e) {
      Get.snackbar("Error", "Failed to add comment");
    }
  }

  Future<void> likePost() async {
    final wasLiked = isLiked.value;

    try {
      isLiked.value = !wasLiked;
      likesCount.value += wasLiked ? -1 : 1;

      await _actionRepo.likePost(post.id);
    } catch (e) {
      isLiked.value = wasLiked;
      likesCount.value += wasLiked ? 1 : -1;
      Get.snackbar("Error", "Failed to like/unlike post");
    }
  }

  Future<void> sharePost() async {
    try {
      sharesCount.value += 1;
      await _actionRepo.sharePost(post.id);
    } catch (e) {
      sharesCount.value -= 1;
      Get.snackbar("Error", "Failed to share post");
    }
  }

  @override
  void onClose() {
    commentCtrl.dispose();
    super.onClose();
  }
}