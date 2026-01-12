import 'package:get/get.dart';

import '../controllers/leaders_home_controller.dart';

class LeadersHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadersHomeController>(
      () => LeadersHomeController(),
    );
  }
}
