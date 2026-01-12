import 'package:faithconnect/app/core/config/token_storage.dart';
import 'package:faithconnect/app/core/services/chat_socket_service.dart';
import 'package:faithconnect/app/data/model/message_model.dart';
import 'package:faithconnect/app/data/repo/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorshiperChatWithLeadersController extends GetxController {
  final ChatSocketService socket = ChatSocketService();
  final TokenStorage storage = TokenStorage();

  final messages = <MessageModel>[].obs;
  final isLoading = true.obs;

  final isTyping = false.obs;
  final isLeaderOnline = false.obs;

  final leaderName = ''.obs;
  final leaderPhoto = RxnString();

  late int conversationId;
  late int leaderId;

  // Changed: Now dynamic user ID (will be loaded in onInit)
  late int myUserId;

  final textCtrl = TextEditingController();

  // ── NEW: For emoji picker support ──
  final showEmoji = false.obs;
  final focusNode = FocusNode();

  int _tempIdCounter = 0;

  @override
  void onInit() async {
    super.onInit();

    // NEW: Load real user ID from secure storage (JWT)
    final userIdStr = await storage.getUserId();
    myUserId = int.tryParse(userIdStr ?? '1') ?? 1; // fallback to 1 if null/error

    leaderId = Get.arguments['leaderId'];
    leaderName.value = Get.arguments['leaderName'];
    leaderPhoto.value = Get.arguments['leaderPhoto'];

    _initChat();
  }

  Future<void> _initChat() async {
    conversationId = (await ChatRepository().getOrCreateConversation(leaderId))!;

    messages.value = await ChatRepository().getMessages(conversationId);

    isLoading.value = false;

    socket.connect(myUserId);
    socket.joinConversation(conversationId);

    socket.onNewMessage((data) {
      final serverMsg = MessageModel.fromJson(data);

      final index = messages.indexWhere(
        (m) => m.id == 0 && data['clientTempId'] == m.createdAt.millisecondsSinceEpoch,
      );

      if (index != -1) {
        messages[index] = serverMsg;
      } else {
        messages.add(serverMsg);
      }

      messages.refresh();
    });

    socket.onMessageDelivered((id) {
      for (final m in messages) {
        if (m.id == id) m.status = 'DELIVERED';
      }
      messages.refresh();
    });

    socket.onMessageSeen((id) {
      for (final m in messages) {
        if (m.id == id) m.status = 'SEEN';
      }
      messages.refresh();
    });

    socket.onTyping(() => isTyping.value = true);
    socket.onStopTyping(() => isTyping.value = false);

    socket.onUserStatus((id, online) {
      if (id == leaderId) isLeaderOnline.value = online;
    });
  }

  void sendMessage() {
    final text = textCtrl.text.trim();
    if (text.isEmpty) return;

    final tempId = DateTime.now().millisecondsSinceEpoch;

    messages.add(
      MessageModel(
        id: 0,
        senderId: myUserId,
        receiverId: leaderId,
        message: text,
        status: 'PENDING',
        createdAt: DateTime.fromMillisecondsSinceEpoch(tempId),
      ),
    );

    messages.refresh();

    socket.sendMessage(
      conversationId: conversationId,
      senderId: myUserId,
      receiverId: leaderId,
      message: text,
      clientTempId: tempId,
    );

    textCtrl.clear();
  }

  void onTyping(String v) {
    v.isNotEmpty
        ? socket.typing(conversationId, myUserId)
        : socket.stopTyping(conversationId, myUserId);
  }

  // Optional: Helper method to insert emoji at cursor position
  void insertEmoji(String emoji) {
    final text = textCtrl.text;
    final selection = textCtrl.selection;
    
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      emoji,
    );
    
    textCtrl.text = newText;
    textCtrl.selection = TextSelection.collapsed(
      offset: selection.start + emoji.length,
    );
    
    onTyping(newText);
  }

  @override
  void onClose() {
    socket.disconnect();
    focusNode.dispose();
    textCtrl.dispose();
    super.onClose();
  }
}