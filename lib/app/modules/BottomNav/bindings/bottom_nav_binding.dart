import 'package:faithconnect/app/modules/LeadersforWorshiper/controllers/leadersfor_worshiper_controller.dart';
import 'package:faithconnect/app/modules/NotificationViewForLeaders/controllers/notification_view_for_leaders_controller.dart';
import 'package:faithconnect/app/modules/ReelsForWorshipers/controllers/reels_for_worshipers_controller.dart';
import 'package:faithconnect/app/modules/WorshiperChatView/controllers/worshiper_chat_view_controller.dart';
import 'package:faithconnect/app/modules/WorshiperHome/controllers/worshiper_home_controller.dart';
import 'package:get/get.dart';

import '../controllers/bottom_nav_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(
      () => BottomNavController(),
    );
     Get.lazyPut<WorshiperHomeController>(
      () => WorshiperHomeController(),
    );
     Get.lazyPut<LeadersforWorshiperController>(
      () => LeadersforWorshiperController(),
    );
  
    Get.lazyPut<ReelsForWorshipersController>(
      () => ReelsForWorshipersController(),
    );
   Get.lazyPut<WorshiperChatViewController>(
      () => WorshiperChatViewController(),
    );
     Get.lazyPut<NotificationViewForLeadersController>(
      () => NotificationViewForLeadersController(),
    );
  }
}
