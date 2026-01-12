// lib/app/data/repo/notification_repository.dart
import 'package:dio/dio.dart';
import 'package:faithconnect/app/core/services/api_service.dart';
import 'package:faithconnect/app/data/model/notification_model.dart';

class NotificationRepository {
  final ApiService _api = ApiService();

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _api.get('/api/notifications');

      if (response.data is List) {
        return (response.data as List)
            .map((item) => NotificationModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch notifications: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Optional: Mark as read (if your backend supports it later)
  Future<void> markAsRead(int notificationId) async {
    try {
      await _api.patch('/api/notifications/$notificationId/read');
    } catch (e) {
      throw Exception('Failed to mark as read: $e');
    }
  }
}