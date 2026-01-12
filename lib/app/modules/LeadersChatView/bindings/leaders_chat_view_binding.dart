import 'package:get/get.dart';

import '../controllers/leaders_chat_view_controller.dart';

class LeadersChatViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadersChatViewController>(
      () => LeadersChatViewController(),
    );
  }
}
