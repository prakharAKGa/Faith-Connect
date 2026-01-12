import 'package:faithconnect/app/data/model/conversation_model.dart';
import 'package:faithconnect/app/data/repo/chat_repository.dart';
import 'package:get/get.dart';
class WorshiperChatViewController extends GetxController {
  final ChatRepository _repo = ChatRepository();

  final conversations = <ConversationModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  Future<void> loadChats() async {
    try {
      isLoading.value = true;
      conversations.value = await _repo.getUserConversations();
    } finally {
      isLoading.value = false;
    }
  }
}
