import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/api_providers.dart';
import 'support_message_model.dart';

class SupportService {
  final Ref _ref;

  SupportService(this._ref);

  Future<void> sendMessage(String message) async {
    final apiClient = _ref.read(apiClientProvider);
    await apiClient.client.post(
      '/api/support/messages',
      data: {'message': message},
    );
  }

  Future<List<SupportMessage>> getMessages() async {
    final apiClient = _ref.read(apiClientProvider);
    final response = await apiClient.client.get('/api/support/messages');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => SupportMessage.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<void> markAsRead(int messageId) async {
    final apiClient = _ref.read(apiClientProvider);
    await apiClient.client.put('/api/support/messages/$messageId/read');
  }

  Future<void> replyToUser(String userId, String message) async {
    final apiClient = _ref.read(apiClientProvider);
    await apiClient.client.post(
      '/api/support/messages/$userId/reply',
      data: {'message': message},
    );
  }
}

final supportServiceProvider = Provider<SupportService>((ref) {
  return SupportService(ref);
});
