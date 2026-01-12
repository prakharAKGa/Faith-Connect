import 'package:get/get.dart';

class BottomNavForLeadersController extends GetxController {
  //TODO: Implement BottomNavForLeadersController
 final RxInt index = 0.obs;

  void changeIndex(int i) {
    index.value = i;
  }
}
