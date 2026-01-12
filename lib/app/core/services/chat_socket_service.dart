import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  IO.Socket? _socket;
  bool _connected = false;

  IO.Socket? get socket => _socket;

  void connect(int userId) {
    if (_connected) return;

    debugPrint("🔌 Connecting socket...");

    _socket = IO.io(
      'https://faithconnect-backend-production.up.railway.app',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      _connected = true;
      debugPrint('✅ Socket connected');
      _socket!.emit('user_online', userId);
    });

    _socket!.onDisconnect((_) {
      debugPrint('❌ Socket disconnected');
      _connected = false;
    });

    _socket!.onConnectError((e) {
      debugPrint('⚠️ Socket error: $e');
    });

    _socket!.connect();
  }

  // ───────── EMITS ─────────
  void joinConversation(int conversationId) {
    debugPrint("📥 join_conversation $conversationId");
    _socket?.emit('join_conversation', {
      'conversationId': conversationId,
    });
  }

  void sendMessage({
    required int conversationId,
    required int senderId,
    required int receiverId,
    required String message,
    required int clientTempId,
  }) {
    debugPrint("📨 send_message $clientTempId");

    _socket?.emit('send_message', {
      'conversationId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'clientTempId': clientTempId,
    });
  }

  void markSeen(int messageId, int conversationId) {
    debugPrint("👁️ mark_seen $messageId");
    _socket?.emit('message_seen', {
      'messageId': messageId,
      'conversationId': conversationId,
    });
  }

  void typing(int conversationId, int userId) {
    _socket?.emit('typing', {
      'conversationId': conversationId,
      'userId': userId,
    });
  }

  void stopTyping(int conversationId, int userId) {
    _socket?.emit('stop_typing', {
      'conversationId': conversationId,
      'userId': userId,
    });
  }

  // ───────── LISTENERS ─────────
  void onNewMessage(Function(Map<String, dynamic>) cb) {
    _socket?.off('new_message');
    _socket?.on('new_message', (data) {
      final parsed = data is String ? jsonDecode(data) : data;
      debugPrint("📩 new_message $parsed");
      cb(Map<String, dynamic>.from(parsed));
    });
  }

  void onTyping(VoidCallback cb) {
    _socket?.off('typing');
    _socket?.on('typing', (_) => cb());
  }

  void onStopTyping(VoidCallback cb) {
    _socket?.off('stop_typing');
    _socket?.on('stop_typing', (_) => cb());
  }

  void onUserStatus(Function(int, bool) cb) {
    _socket?.off('user_status');
    _socket?.on('user_status', (data) {
      cb(data['userId'], data['isOnline']);
    });
  }

  void onMessageDelivered(Function(int) cb) {
    _socket?.off('message_delivered');
    _socket?.on('message_delivered', (data) {
      debugPrint("✔ delivered ${data['messageId']}");
      cb(data['messageId']);
    });
  }

  void onMessageSeen(Function(int) cb) {
    _socket?.off('message_seen');
    _socket?.on('message_seen', (data) {
      debugPrint("👁️ seen ${data['messageId']}");
      cb(data['messageId']);
    });
  }

  void disconnect() {
    debugPrint("🧹 Socket disposed");
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _connected = false;
  }
}
