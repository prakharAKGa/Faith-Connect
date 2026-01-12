import 'package:get/get.dart';

import '../controllers/worshiper_chat_view_controller.dart';

class WorshiperChatViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorshiperChatViewController>(
      () => WorshiperChatViewController(),
    );
  }
}
