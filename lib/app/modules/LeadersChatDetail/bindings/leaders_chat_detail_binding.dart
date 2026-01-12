import 'package:get/get.dart';

import '../controllers/leaders_chat_detail_controller.dart';

class LeadersChatDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadersChatDetailController>(
      () => LeadersChatDetailController(),
    );
  }
}
