// lib/app/modules/Chat/repository/chat_repository.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:faithconnect/app/core/services/api_service.dart';
import 'package:faithconnect/app/data/model/conversation_model.dart';
import 'package:faithconnect/app/data/model/message_model.dart';

class ChatRepository {
  final ApiService _api;

  ChatRepository({ApiService? apiService}) : _api = apiService ?? ApiService();

  /// 🔹 Get or create conversation (CORRECT ENDPOINT)
Future<List<ConversationModel>> getUserConversations() async {
  final res = await _api.get('/api/chat/conversations');

  return (res.data as List)
      .map((e) => ConversationModel.fromJson(e))
      .toList();
}

  Future<int?> getOrCreateConversation(int leaderId) async {
    try {
      final response = await _api.get('/api/chat/conversation/$leaderId');

      dynamic data = response.data;
      if (data is String) data = jsonDecode(data);

      if (data is Map<String, dynamic>) {
        final id = data['id'];
        if (id is int) return id;
        if (id is String) return int.tryParse(id);
      }

      print('⚠ No conversation id returned');
      return null;
    } on DioException catch (e) {
      print('DioException getOrCreateConversation: ${e.message}');
      print(e.response?.data);
      return null;
    } catch (e) {
      print('Error getOrCreateConversation: $e');
      return null;
    }
  }

  /// 🔹 Get messages (CORRECT ENDPOINT)
  Future<List<MessageModel>> getMessages(int conversationId) async {
    try {
      final response =
          await _api.get('/api/chat/messages/$conversationId');

      dynamic jsonData = response.data;
      if (jsonData is String) jsonData = jsonDecode(jsonData);

      if (jsonData is! List) return [];

      return jsonData
          .whereType<Map<String, dynamic>>()
          .map((e) => MessageModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      print('DioException getMessages: ${e.message}');
      print(e.response?.data);
      return [];
    } catch (e) {
      print('Error getMessages: $e');
      return [];
    }
  }
}
