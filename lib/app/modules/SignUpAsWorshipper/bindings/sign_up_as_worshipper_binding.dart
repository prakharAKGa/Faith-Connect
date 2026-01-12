import 'package:get/get.dart';

import '../controllers/sign_up_as_worshipper_controller.dart';

class SignUpAsWorshipperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpAsWorshipperController>(
      () => SignUpAsWorshipperController(),
    );
  }
}
