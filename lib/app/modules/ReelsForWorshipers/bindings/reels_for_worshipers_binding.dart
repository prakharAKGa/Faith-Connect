import 'package:get/get.dart';

import '../controllers/reels_for_worshipers_controller.dart';

class ReelsForWorshipersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsForWorshipersController>(
      () => ReelsForWorshipersController(),
    );
   
  }
}
