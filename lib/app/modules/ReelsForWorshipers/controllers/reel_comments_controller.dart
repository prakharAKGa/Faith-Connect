import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:faithconnect/app/data/model/reel_comment_model.dart';
import 'package:faithconnect/app/data/repo/reel_comment_repository.dart';

class ReelCommentsController extends GetxController {
  final int reelId;
  ReelCommentsController(this.reelId);

  final ReelCommentRepository _repo = ReelCommentRepository();

  final comments = <ReelCommentModel>[].obs;
  final isLoading = true.obs;
  final commentCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  Future<void> fetchComments() async {
    isLoading.value = true;
    comments.value = await _repo.getComments(reelId);
    isLoading.value = false;
  }

  Future<void> sendComment() async {
    if (commentCtrl.text.trim().isEmpty) return;

    await _repo.addComment(reelId, commentCtrl.text.trim());
    commentCtrl.clear();
    fetchComments(); // 🔁 refresh comments
  }

  @override
  void onClose() {
    commentCtrl.dispose();
    super.onClose();
  }
}
