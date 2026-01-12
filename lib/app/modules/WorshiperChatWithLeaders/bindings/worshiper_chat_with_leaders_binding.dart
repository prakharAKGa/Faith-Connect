import 'package:get/get.dart';

import '../controllers/worshiper_chat_with_leaders_controller.dart';

class WorshiperChatWithLeadersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorshiperChatWithLeadersController>(
      () => WorshiperChatWithLeadersController(),
    );
  }
}
