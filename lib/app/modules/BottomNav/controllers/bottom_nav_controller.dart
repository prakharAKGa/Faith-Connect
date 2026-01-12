// lib/app/modules/BottomNav/controllers/bottom_nav_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt index = 0.obs;
  final RxBool isVisible = true.obs;

  ScrollController? _scrollController;

  void changeIndex(int i) {
    index.value = i;
  }

  /// Attach scroll controller from current tab
  void attachScrollController(ScrollController controller) {
    _scrollController?.removeListener(_onScroll);
    _scrollController = controller;
    _scrollController!.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController == null) return;

    final direction =
        _scrollController!.position.userScrollDirection;

    if (direction == ScrollDirection.reverse) {
      // scrolling down
      if (isVisible.value) isVisible.value = false;
    } else if (direction == ScrollDirection.forward) {
      // scrolling up
      if (!isVisible.value) isVisible.value = true;
    }
  }

  @override
  void onClose() {
    _scrollController?.removeListener(_onScroll);
    super.onClose();
  }
}
