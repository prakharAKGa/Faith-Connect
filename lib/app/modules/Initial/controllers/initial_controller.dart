import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:get/get.dart';

class InitialController extends GetxController {
  void continueAsWorshiper() {
    // TODO: save role in storage if needed
    Get.toNamed(Routes.SIGN_UP_AS_WORSHIPPER);
  }

  void continueAsLeader() {
    // TODO: save role in storage if needed
    Get.toNamed(Routes.SIGN_UP);
  }

  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }
}
