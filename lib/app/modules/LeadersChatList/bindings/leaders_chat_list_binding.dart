import 'package:get/get.dart';

import '../controllers/leaders_chat_list_controller.dart';

class LeadersChatListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadersChatListController>(
      () => LeadersChatListController(),
    );
  }
}
