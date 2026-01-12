import 'package:faithconnect/app/data/model/profile_model.dart';
import 'package:faithconnect/app/data/repo/profile_repository.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repo = ProfileRepository();

  final profile = Rxn<ProfileModel>();
  final isLoading = true.obs;

  bool get isLeader => profile.value?.role == "LEADER";

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      profile.value = await _repo.getMyProfile();
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile");
    } finally {
      isLoading.value = false;
    }
  }
}
