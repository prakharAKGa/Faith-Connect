// lib/app/data/model/notification_model.dart
class NotificationModel {
  final int id;
  final int userId;
  final String type; // e.g., "NEW_MESSAGE", "NEW_POST", "NEW_REEL"
  final int referenceId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.referenceId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      type: json['type'] as String,
      referenceId: json['reference_id'] as int,
      isRead: (json['is_read'] as int) == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Optional: toJson if you need to send data back
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'reference_id': referenceId,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
}