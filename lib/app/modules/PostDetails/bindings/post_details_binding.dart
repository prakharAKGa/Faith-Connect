// lib/app/modules/PostDetails/bindings/post_details_binding.dart
import 'package:faithconnect/app/data/model/post_model.dart';
import 'package:get/get.dart';

import '../controllers/post_details_controller.dart';

class PostDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final PostModel post = Get.arguments as PostModel;

    Get.lazyPut<PostDetailsController>(
      () => PostDetailsController(post),
    );
  }
}
