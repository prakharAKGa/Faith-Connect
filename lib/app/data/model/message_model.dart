class MessageModel {
  final int id; // 0 = PENDING
  final int senderId;
  final int receiverId;
  final String message;
  String status;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: (json['id'] ?? 0) as int,
      senderId: (json['sender_id'] ?? json['senderId'] ?? 0) as int,
      receiverId: (json['receiver_id'] ?? json['receiverId'] ?? 0) as int,
      message: json['message'] ?? '',
      status: json['status'] ?? 'SENT',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
