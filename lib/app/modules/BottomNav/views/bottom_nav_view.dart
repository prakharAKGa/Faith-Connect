import 'package:faithconnect/app/modules/BottomNav/views/floating_bottom_nav.dart';
import 'package:faithconnect/app/modules/LeadersforWorshiper/views/leadersfor_worshiper_view.dart';
import 'package:faithconnect/app/modules/NotificationViewForLeaders/views/notification_view_for_leaders_view.dart';
import 'package:faithconnect/app/modules/ReelsForWorshipers/views/reels_for_worshipers_view.dart';
import 'package:faithconnect/app/modules/WorshiperChatView/views/worshiper_chat_view_view.dart';
import 'package:faithconnect/app/modules/WorshiperHome/views/worshiper_home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bottom_nav_controller.dart';

// Wrapper for Reels tab (keeps video control)
class ReelsTabWrapper extends StatelessWidget {
  const ReelsTabWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController nav = Get.find<BottomNavController>();

    return Obx(() {
      final isActive = nav.index.value == 2;
      return Visibility(
        visible: isActive,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        replacement: const SizedBox.shrink(),
        child: ReelsForWorshipersView(),
      );
    });
  }
}

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  final BottomNavController controller = Get.find<BottomNavController>();
  final ScrollController scrollController = ScrollController();
  final RxBool isNavVisible = true.obs;
  double lastOffset = 0.0;

  @override
  void initState() {
    super.initState();

    // Scroll listener: hide on down, show on up
    scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!scrollController.hasClients) return;

    final currentOffset = scrollController.offset;

    if (currentOffset <= 0) {
      // At top → always show
      isNavVisible.value = true;
    } else if (currentOffset > lastOffset && currentOffset > 80) {
      // Scrolling down → hide
      isNavVisible.value = false;
    } else {
      // Scrolling up → show
      isNavVisible.value = true;
    }

    lastOffset = currentOffset;
  }

  @override
  void dispose() {
    scrollController.removeListener(_handleScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // All tab contents
          Obx(() => SafeArea(
            child: IndexedStack(
                  index: controller.index.value,
                  children: [
                    // Home - attach scroll listener
                    NotificationListener<ScrollNotification>(
                      onNotification: (_) => true,
                      child: WorshiperHomeView(),
                    ),
                    LeadersforWorshiperView(),
                    const ReelsTabWrapper(),
                    WorshiperChatViewView(),
                    NotificationViewForLeadersView(),
                  ],
                ),
          )),

          // Floating Bottom Nav – hide/show animation
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            bottom: isNavVisible.value ? 0 : -100,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 350),
              opacity: isNavVisible.value ? 1.0 : 0.0,
              child: FloatingBottomNav(),
            ),
          ),
        ],
      ),
    );
  }
}