import 'package:get/get.dart';

import '../controllers/worshiper_home_controller.dart';

class WorshiperHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorshiperHomeController>(
      () => WorshiperHomeController(),
    );
  }
}
