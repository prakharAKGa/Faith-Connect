import 'package:get/get.dart';

import '../controllers/leader_details_controller.dart';

class LeaderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaderDetailsController>(
      () => LeaderDetailsController(),
    );
  }
}
