import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/services/chat_service.dart';
import 'package:legalhelp_kz/providers/providers.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(chatServiceProvider));
});

/// Chat repository backed by ChatService (Gemini + Firestore).
class ChatRepository {
  final ChatService _chatService;
  String? _currentChatId;

  ChatRepository(this._chatService);

  /// Sends a message directly to Gemini via ChatService.
  /// Falls back gracefully if no auth user.
  Future<ChatMessage> sendMessage(String text, {List<ChatMessage> history = const []}) async {
    try {
      // Build history for context
      final openAiHistory = history.map((m) => {
        'role': m.isUser ? 'user' : 'assistant',
        'content': m.text,
      }).toList();

      // Send directly to Gemini (without Firestore if no user)
      final aiText = await _chatService.ai.sendMessage(text, history: openAiHistory);

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: aiText,
        isUser: false,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Ошибка AI: $e');
    }
  }

  Future<List<ChatMessage>> getHistory() async => [];
  Future<void> clearHistory() async {}
}
