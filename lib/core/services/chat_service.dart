import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/services/firestore_service.dart';
import 'package:legalhelp_kz/core/services/openai_service.dart';
import 'package:legalhelp_kz/core/utils/list_extensions.dart';

/// Manages chat sessions and messages, integrating Firestore + OpenAI.
class ChatService {
  final FirestoreService _fs;
  final OpenAIService _ai;
  final _uuid = const Uuid();

  ChatService(this._fs, this._ai);

  /// Exposes the AI service for direct calls without a Firestore chat session.
  OpenAIService get ai => _ai;


  /// Creates a new chat session and returns its ID.
  Future<String> createChat(String userId, {String? title}) async {
    final chatId = _uuid.v4();
    await _fs.setDoc(_fs.chatDoc(chatId), {
      'id': chatId,
      'userId': userId,
      'title': title ?? 'Новый чат',
      'lastMessage': '',
      'createdAt': FirestoreService.serverTimestamp,
      'updatedAt': FirestoreService.serverTimestamp,
    });
    return chatId;
  }

  /// Returns a stream of all chat sessions for the user.
  Stream<List<Map<String, dynamic>>> getUserChats(String userId) {
    return _fs.chatsCol
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  /// Deletes a chat session and all its messages.
  Future<void> deleteChat(String chatId) async {
    // Delete messages subcollection
    final messages = await _fs.messagesCol(chatId).get();
    for (final doc in messages.docs) {
      await doc.reference.delete();
    }
    await _fs.deleteDoc(_fs.chatDoc(chatId));
  }

  // ─── Messages ──────────────────────────────────────────────────────────────

  /// Returns a real-time stream of messages in a chat.
  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _fs.messagesCol(chatId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => _messageFromDoc(d.data()))
            .toList());
  }

  /// Sends a user message and gets an AI reply.
  /// Returns the AI reply text.
  Future<String> sendMessage(
    String chatId,
    String userId,
    String userText, {
    List<ChatMessage> history = const [],
  }) async {
    // 1. Save user message to Firestore
    final userMsgId = _uuid.v4();
    await _saveMessage(chatId, userMsgId, userText, isUser: true);

    // 2. Build conversation history for context (last 10 messages)
    final openAiHistory = history.takeLast(10).map((m) => <String, String>{
          'role': m.isUser ? 'user' : 'assistant',
          'content': m.text,
        }).toList();

    // 3. Call OpenAI API
    final aiText = await _ai.sendMessage(userText, history: openAiHistory);

    // 4. Save AI response to Firestore
    final aiMsgId = _uuid.v4();
    await _saveMessage(chatId, aiMsgId, aiText, isUser: false);

    // 5. Update chat metadata
    await _fs.updateDoc(_fs.chatDoc(chatId), {
      'lastMessage': aiText.substring(0, aiText.length > 80 ? 80 : aiText.length),
      'updatedAt': FirestoreService.serverTimestamp,
      // Auto-set chat title from first user message
      'title': userText.substring(0, userText.length > 40 ? 40 : userText.length),
    });

    return aiText;
  }

  // ─── Private Helpers ───────────────────────────────────────────────────────

  Future<void> _saveMessage(
    String chatId,
    String messageId,
    String text, {
    required bool isUser,
  }) async {
    await _fs.setDoc(
      _fs.messagesCol(chatId).doc(messageId),
      {
        'id': messageId,
        'text': text,
        'is_user': isUser,
        'timestamp': FirestoreService.serverTimestamp,
        'is_loading': false,
      },
    );
  }

  ChatMessage _messageFromDoc(Map<String, dynamic> data) {
    return ChatMessage(
      id: data['id'] as String,
      text: data['text'] as String,
      isUser: data['is_user'] as bool,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isLoading: data['is_loading'] as bool? ?? false,
    );
  }
}



