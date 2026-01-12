import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final showLogo = false.obs;
  final showTagline = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    showLogo.value = true;

    await Future.delayed(const Duration(milliseconds: 500));
    showTagline.value = true;

    await Future.delayed(const Duration(seconds: 2));

    /// ✅ Navigate ONCE to the real first screen
    Get.offAllNamed(Routes.INITIAL);
  }
}
