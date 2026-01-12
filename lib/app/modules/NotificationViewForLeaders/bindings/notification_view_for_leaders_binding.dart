import 'package:get/get.dart';

import '../controllers/notification_view_for_leaders_controller.dart';

class NotificationViewForLeadersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationViewForLeadersController>(
      () => NotificationViewForLeadersController(),
    );
  }
}
