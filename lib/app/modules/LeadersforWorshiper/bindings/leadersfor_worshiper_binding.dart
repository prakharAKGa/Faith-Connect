import 'package:get/get.dart';

import '../controllers/leadersfor_worshiper_controller.dart';

class LeadersforWorshiperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadersforWorshiperController>(
      () => LeadersforWorshiperController(),
    );
  }
}
