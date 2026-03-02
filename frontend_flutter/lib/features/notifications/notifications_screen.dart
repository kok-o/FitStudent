import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'package:timeago/timeago.dart' as timeago;
<<<<<<< HEAD
import 'package:timeago/timeago.dart' as timeago;
import 'notification_service.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notificationsAsync = ref.watch(userNotificationsProvider);
    final unreadCountAsync = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications_label),
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return _buildEmptyState(context, l10n);
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userNotificationsProvider);
              ref.invalidate(unreadNotificationsCountProvider);
            },
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(context, ref, notifications[index]);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
=======
import 'package:frontend_flutter/l10n/app_localizations.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      type: NotificationType.achievement,
      title: 'New Achievement Unlocked!',
      message: 'You\'ve completed a 7-day workout streak. Keep it up!',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      type: NotificationType.reminder,
      title: 'Time for your workout',
      message: 'Don\'t forget your evening cardio session',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      type: NotificationType.social,
      title: 'John liked your workout',
      message: 'John liked your "Morning Run" activity',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      type: NotificationType.system,
      title: 'Weekly Progress Report',
      message: 'Your weekly fitness summary is ready to view',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      type: NotificationType.motivation,
      title: 'You\'re doing great!',
      message: 'You\'ve burned 2,500 calories this week. Amazing progress!',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.notifications),
        actions: [
          if (unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: t.markAllAsRead,
              onPressed: _markAllAsRead,
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(_notifications[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    final t = AppLocalizations.of(context)!;
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
<<<<<<< HEAD
            l10n.noNotifications,
=======
            t.noNotifications,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
<<<<<<< HEAD
            l10n.allCaughtUp,
=======
            t.allCaughtUp,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildNotificationCard(BuildContext context, WidgetRef ref, NotificationModel notification) {
    final icon = _getNotificationIcon(notification.type);
    final color = _getNotificationColor(notification.type);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: notification.isRead
          ? null
          : AppTheme.primaryColor.withOpacity(0.05),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              timeago.format(notification.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
        onTap: () async {
          if (!notification.isRead) {
            await ref.read(notificationServiceProvider).markAsRead(notification.id);
            ref.invalidate(userNotificationsProvider);
            ref.invalidate(unreadNotificationsCountProvider);
          }
        },
=======
  Widget _buildNotificationCard(NotificationItem notification) {
    final icon = _getNotificationIcon(notification.type);
    final color = _getNotificationColor(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        final t = AppLocalizations.of(context)!;
        _deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.notificationDeleted)),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.errorColor,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: notification.isRead
            ? null
            : AppTheme.primaryColor.withOpacity(0.05),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification.message),
              const SizedBox(height: 4),
              Text(
                timeago.format(notification.time),
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
          onTap: () {
            if (!notification.isRead) {
              _markAsRead(notification.id);
            }
            // Handle notification tap
          },
        ),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      ),
    );
  }

<<<<<<< HEAD
  IconData _getNotificationIcon(String type) {
    switch (type.toUpperCase()) {
      case 'ACHIEVEMENT':
        return Icons.emoji_events;
      case 'REMINDER':
        return Icons.alarm;
      case 'SOCIAL':
        return Icons.people;
      case 'SYSTEM':
        return Icons.info_outline;
      case 'MOTIVATION':
        return Icons.favorite;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type.toUpperCase()) {
      case 'ACHIEVEMENT':
        return AppTheme.warningColor;
      case 'REMINDER':
        return AppTheme.primaryColor;
      case 'SOCIAL':
        return AppTheme.accentColor;
      case 'SYSTEM':
        return AppTheme.textSecondary;
      case 'MOTIVATION':
        return AppTheme.successColor;
      default:
        return AppTheme.primaryColor;
    }
  }
}
=======
  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.achievement:
        return Icons.emoji_events;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.social:
        return Icons.people;
      case NotificationType.system:
        return Icons.info_outline;
      case NotificationType.motivation:
        return Icons.favorite;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.achievement:
        return AppTheme.warningColor;
      case NotificationType.reminder:
        return AppTheme.primaryColor;
      case NotificationType.social:
        return AppTheme.accentColor;
      case NotificationType.system:
        return AppTheme.textSecondary;
      case NotificationType.motivation:
        return AppTheme.successColor;
    }
  }
}

enum NotificationType {
  achievement,
  reminder,
  social,
  system,
  motivation,
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
