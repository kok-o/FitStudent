import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../support/support_service.dart';
import '../support/support_message_model.dart';

class AdminSupportTab extends ConsumerWidget {
  const AdminSupportTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(supportMessagesProvider);

    return Scaffold(
      body: messagesAsync.when(
        data: (messages) {
          if (messages.isEmpty) {
            return const Center(child: Text('No support messages yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final msg = messages[index];
              return ListTile(
                title: Text(msg.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(msg.message),
                    const SizedBox(height: 4),
                    Text(
                      msg.timestamp.toLocal().toString().substring(0, 16),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                leading: Icon(
                  msg.adminMessage ? Icons.shield : Icons.person,
                  color: msg.adminMessage ? Colors.purple : Colors.blue,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!msg.adminMessage)
                      IconButton(
                        icon: const Icon(Icons.reply, color: Colors.blue),
                        tooltip: 'Reply to User',
                        onPressed: () => _showReplyDialog(context, ref, msg),
                      ),
                    IconButton(
                      icon: Icon(
                        msg.isRead ? Icons.check_circle : Icons.mark_email_unread,
                        color: msg.isRead ? Colors.green : Colors.orange,
                      ),
                      onPressed: () async {
                        if (!msg.isRead && msg.id != null) {
                          await ref.read(supportServiceProvider).markAsRead(msg.id!);
                          ref.invalidate(supportMessagesProvider);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.invalidate(supportMessagesProvider),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _showReplyDialog(BuildContext context, WidgetRef ref, SupportMessage msg) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reply to ${msg.userName}'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Enter your reply...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              try {
                await ref.read(supportServiceProvider).replyToUser(msg.userId, controller.text);
                // Auto mark as read if it wasn't
                if (!msg.isRead && msg.id != null) {
                  await ref.read(supportServiceProvider).markAsRead(msg.id!);
                }
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ref.invalidate(supportMessagesProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply sent!')),
                  );
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to send reply: $e')),
                  );
                }
              }
            },
            child: const Text('Send Reply'),
          ),
        ],
      ),
    );
  }
}

final supportMessagesProvider = FutureProvider<List<SupportMessage>>((ref) {
  return ref.watch(supportServiceProvider).getMessages();
});
