class SupportMessage {
  final int? id;
  final String userId;
  final String userName;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final bool adminMessage;

  SupportMessage({
    this.id,
    required this.userId,
    required this.userName,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.adminMessage = false,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      id: (json['id'] as num?)?.toInt(),
      userId: json['userId']?.toString() ?? '',
      userName: json['userName'] ?? 'Anonymous',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
      isRead: json['read'] ?? false,
      adminMessage: json['adminMessage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
