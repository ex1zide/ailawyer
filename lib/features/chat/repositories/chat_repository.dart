import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/core/api/api_client.dart';
import 'package:legalhelp_kz/core/models/models.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(apiClientProvider));
});

class ChatRepository {
  final ApiClient _apiClient;

  ChatRepository(this._apiClient);

  Future<ChatMessage> sendMessage(String text) async {
    final response = await _apiClient.post('/chat/send', data: {'message': text});
    return ChatMessage.fromJson(response.data['response']);
  }

  Future<List<ChatMessage>> getHistory() async {
    final response = await _apiClient.get('/chat/history');
    return (response.data['messages'] as List<dynamic>)
        .map((m) => ChatMessage.fromJson(m))
        .toList();
  }

  Future<void> clearHistory() async {
    await _apiClient.delete('/chat/history');
  }
}
