import 'package:get/get.dart';

import '../controllers/reels_uploadfor_leader_controller.dart';

class ReelsUploadforLeaderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsUploadforLeaderController>(
      () => ReelsUploadforLeaderController(),
    );
  }
}
