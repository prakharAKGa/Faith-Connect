// leaders_chat_list_controller.dart
import 'package:faithconnect/app/data/model/conversation_model.dart';
import 'package:faithconnect/app/data/repo/chat_repository.dart';
import 'package:get/get.dart';

class LeadersChatListController extends GetxController {
  final ChatRepository _repo = ChatRepository();

  final conversations = <ConversationModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  Future<void> fetchChats() async {
    isLoading.value = true;
    conversations.value = await _repo.getUserConversations();
    isLoading.value = false;
  }
}
