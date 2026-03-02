import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/api_providers.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'SYSTEM',
      isRead: json['read'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }
}

class NotificationService {
  final Ref _ref;

  NotificationService(this._ref);

  Future<List<NotificationModel>> getNotifications() async {
    final client = _ref.read(apiClientProvider).client;
    final response = await client.get('/api/notifications');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<int> getUnreadCount() async {
    final client = _ref.read(apiClientProvider).client;
    final response = await client.get('/api/notifications/unread-count');
    if (response.statusCode == 200) {
      return response.data as int;
    }
    return 0;
  }

  Future<void> markAsRead(int id) async {
    final client = _ref.read(apiClientProvider).client;
    await client.put('/api/notifications/$id/read');
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

final userNotificationsProvider = FutureProvider.autoDispose<List<NotificationModel>>((ref) {
  return ref.watch(notificationServiceProvider).getNotifications();
});

final unreadNotificationsCountProvider = FutureProvider.autoDispose<int>((ref) {
  return ref.watch(notificationServiceProvider).getUnreadCount();
});
