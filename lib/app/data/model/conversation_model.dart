class ConversationModel {
  final int conversationId;
  final int otherUserId;
  final String name;
  final String? profilePhoto;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final bool isOnline;

  ConversationModel({
    required this.conversationId,
    required this.otherUserId,
    required this.name,
    this.profilePhoto,
    this.lastMessage,
    this.lastMessageAt,
    required this.isOnline,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json['conversation_id'],
      otherUserId: json['other_user_id'],
      name: json['name'],
      profilePhoto: json['profile_photo_url'],
      lastMessage: json['last_message'],
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
      isOnline: json['is_online'] == 1,
    );
  }
}
