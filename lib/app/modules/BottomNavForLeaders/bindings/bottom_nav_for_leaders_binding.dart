import 'package:faithconnect/app/modules/LeadersChatList/controllers/leaders_chat_list_controller.dart';
import 'package:faithconnect/app/modules/LeadersHome/controllers/leaders_home_controller.dart';
import 'package:faithconnect/app/modules/NotificationViewForLeaders/controllers/notification_view_for_leaders_controller.dart';
import 'package:faithconnect/app/modules/PostUpload/controllers/post_upload_controller.dart';
import 'package:faithconnect/app/modules/ReelsUploadforLeader/controllers/reels_uploadfor_leader_controller.dart';
import 'package:get/get.dart';

import '../controllers/bottom_nav_for_leaders_controller.dart';

class BottomNavForLeadersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavForLeadersController>(
      () => BottomNavForLeadersController(),
    );
     Get.lazyPut<LeadersHomeController>(
      () => LeadersHomeController(),
    );
   Get.lazyPut<LeadersChatListController>(
      () => LeadersChatListController(),
    );
     Get.lazyPut<ReelsUploadforLeaderController>(
      () => ReelsUploadforLeaderController(),
    );
     Get.lazyPut<PostUploadController>(
      () => PostUploadController(),
    );
     Get.lazyPut<NotificationViewForLeadersController>(
      () => NotificationViewForLeadersController(),
    );
  }
}
