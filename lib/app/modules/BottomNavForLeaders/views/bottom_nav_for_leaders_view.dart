import 'package:faithconnect/app/modules/BottomNavForLeaders/views/floating_bottom_nav.dart';
import 'package:faithconnect/app/modules/LeadersChatList/views/leaders_chat_list_view.dart';
import 'package:faithconnect/app/modules/LeadersHome/views/leaders_home_view.dart';
import 'package:faithconnect/app/modules/NotificationViewForLeaders/views/notification_view_for_leaders_view.dart';
import 'package:faithconnect/app/modules/PostUpload/views/post_upload_view.dart';
import 'package:faithconnect/app/modules/ReelsUploadforLeader/views/reels_uploadfor_leader_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bottom_nav_for_leaders_controller.dart';

class BottomNavForLeadersView extends GetView<BottomNavForLeadersController> {
  const BottomNavForLeadersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // 🔥 allows floating nav shadow
      body: Obx(
        () => SafeArea(
          child: Stack(
            children: [
              /// PAGES
              IndexedStack(
                index: controller.index.value,
                children: const [
                  LeadersHomeView(),
                  LeadersChatListView(),
                  ReelsUploadforLeaderView(),
          
                  PostUploadView(),
                  NotificationViewForLeadersView(),
                ],
              ),
          
              /// FLOATING NAV BAR
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FloatingBottomNavForLeaders(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
