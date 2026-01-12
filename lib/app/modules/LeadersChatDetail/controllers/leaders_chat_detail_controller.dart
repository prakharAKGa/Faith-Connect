import 'package:faithconnect/app/core/config/token_storage.dart';
import 'package:faithconnect/app/core/services/chat_socket_service.dart';
import 'package:faithconnect/app/data/model/message_model.dart';
import 'package:faithconnect/app/data/repo/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadersChatDetailController extends GetxController {
  final ChatRepository _repo = ChatRepository();
  final ChatSocketService socket = ChatSocketService();
  final TokenStorage storage = TokenStorage();

  /// ───────── STATE ─────────
  final messages = <MessageModel>[].obs;
  final isLoading = true.obs;

  final isTyping = false.obs;
  final isUserOnline = false.obs;

  final userName = ''.obs;
  final userPhoto = RxnString();

  late int conversationId;
  late int worshiperId;

  // Changed: Now loaded dynamically from TokenStorage (JWT)
  late int myUserId;

  final textCtrl = TextEditingController();

  // ── For emoji picker support ──
  final showEmoji = false.obs;
  final focusNode = FocusNode();

  int _tempIdCounter = 0;

  @override
  void onInit() async {
    super.onInit();

    // NEW: Load real authenticated user ID from secure storage (set during login)
    final userIdStr = await storage.getUserId();
    myUserId = int.tryParse(userIdStr ?? '2') ?? 2; // fallback to 2 if null/error

    conversationId = Get.arguments['conversationId'] as int;
    worshiperId = Get.arguments['otherUserId'] as int;
    userName.value = Get.arguments['name'] as String? ?? 'User';
    userPhoto.value = Get.arguments['profilePhoto'] as String?;

    _initChat();
  }

  /// ───────── INITIALIZE CHAT ─────────
  Future<void> _initChat() async {
    try {
      // 1. Load previous messages from server
      messages.value = await _repo.getMessages(conversationId);

      // 2. Mark any unseen messages as seen (optimistic + socket)
      _markVisibleAsSeen();

      isLoading.value = false;

      // 3. Connect socket & join room
      socket.connect(myUserId);
      socket.joinConversation(conversationId);

      // ───── SOCKET EVENT LISTENERS ─────

      // New message received from socket
      socket.onNewMessage((data) {
        final serverMsg = MessageModel.fromJson(data);

        // Check if this is our own pending message being confirmed
        final index = messages.indexWhere(
          (m) => m.id < 0 && // our temp ids are negative
              m.createdAt.millisecondsSinceEpoch == -serverMsg.id,
        );

        if (index != -1) {
          // Replace temp message with real one
          messages[index] = serverMsg;
        } else {
          // New message from other person
          messages.add(serverMsg);
        }

        messages.refresh();

        // Auto mark as seen if it's from the other user
        if (serverMsg.senderId == worshiperId) {
          socket.markSeen(serverMsg.id, conversationId);
        }
      });

      // Message delivered
      socket.onMessageDelivered((id) {
        for (final m in messages) {
          if (m.id == id && m.senderId == myUserId) {
            m.status = 'DELIVERED';
          }
        }
        messages.refresh();
      });

      // Message seen
      socket.onMessageSeen((id) {
        for (final m in messages) {
          if (m.id == id && m.senderId == myUserId) {
            m.status = 'SEEN';
          }
        }
        messages.refresh();
      });

      // Typing indicators
      socket.onTyping(() => isTyping.value = true);
      socket.onStopTyping(() => isTyping.value = false);

      // Online / offline status
      socket.onUserStatus((id, online) {
        if (id == worshiperId) {
          isUserOnline.value = online;
        }
      });
    } catch (e) {
      print("Chat init error: $e");
      isLoading.value = false;
    }
  }

  /// ───────── MARK MESSAGES AS SEEN ─────────
  void _markVisibleAsSeen() {
    for (final m in messages) {
      if (m.senderId == worshiperId && m.status != 'SEEN' && m.id > 0) {
        socket.markSeen(m.id, conversationId);
        m.status = 'SEEN';
      }
    }
    messages.refresh();
  }

  /// ───────── TYPING INDICATOR ─────────
  void onTyping(String value) {
    if (value.trim().isNotEmpty) {
      socket.typing(conversationId, myUserId);
    } else {
      socket.stopTyping(conversationId, myUserId);
    }
  }

  /// ───────── SEND MESSAGE (Optimistic UI) ─────────
  void sendMessage() {
    final text = textCtrl.text.trim();
    if (text.isEmpty) return;

    // Generate temporary negative ID
    final tempId = --_tempIdCounter; // negative counter for temp messages

    final localMsg = MessageModel(
      id: tempId,
      senderId: myUserId,
      receiverId: worshiperId,
      message: text,
      status: 'PENDING',
      createdAt: DateTime.now(),
    );

    // Add optimistic message immediately
    messages.insert(0, localMsg); // insert at top (latest first)
    messages.refresh();

    // Send to server
    socket.sendMessage(
      conversationId: conversationId,
      senderId: myUserId,
      receiverId: worshiperId,
      message: text,
      clientTempId: -tempId, // send positive value as identifier
    );

    textCtrl.clear();
  }

  /// ───────── CLEANUP ─────────
  @override
  void onClose() {
    socket.stopTyping(conversationId, myUserId);
    socket.disconnect();
    focusNode.dispose();
    textCtrl.dispose();
    super.onClose();
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
}