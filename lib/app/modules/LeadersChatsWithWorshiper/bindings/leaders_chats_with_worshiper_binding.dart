import 'package:get/get.dart';

import '../controllers/leaders_chats_with_worshiper_controller.dart';

class LeadersChatsWithWorshiperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadersChatsWithWorshiperController>(
      () => LeadersChatsWithWorshiperController(),
    );
  }
}
