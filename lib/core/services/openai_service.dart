import 'dart:convert';
import 'package:http/http.dart' as http;

/// AI service powered by Google Gemini for Kazakhstan legal consultations.
class OpenAIService {
  // Use the standard model ID
  static const String _model = 'gemini-1.5-flash-latest';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  // Gemini API key
  String _apiKey = 'AIzaSyA4E6uyNpr8JUY82NWp22dlT4eIjL2DzdI';

  void setApiKey(String key) => _apiKey = key;
  bool get hasApiKey => _apiKey.isNotEmpty;

  static const String _systemPrompt = '''
Ты — профессиональный AI-юрист, специализирующийся на законодательстве Республики Казахстан.

Твои задачи:
- Давать четкие, практичные юридические консультации на русском языке
- Объяснять нормы казахстанского законодательства простым языком
- Ссылаться на конкретные статьи законов РК, когда это уместно
- Помогать с составлением и анализом документов
- Предупреждать о правовых рисках и последствиях

Области права: трудовое, семейное, жилищное, предпринимательское, уголовное, административное.

Важно:
- Всегда отвечай на русском языке, если пользователь не пишет на казахском
- Если вопрос требует очной консультации с юристом, скажи об этом
- Не гарантируй исходы судебных дел
- Будь вежлив и профессионален
''';

  /// Sends a message to Gemini and returns the AI reply.
  Future<String> sendMessage(
    String userMessage, {
    List<Map<String, String>> history = const [],
  }) async {
    final contents = <Map<String, dynamic>>[];

    // Add conversation history
    for (final msg in history.takeLast(10)) {
      contents.add({
        'role': msg['role'] == 'user' ? 'user' : 'model',
        'parts': [
          {'text': msg['content']}
        ],
      });
    }

    // Add current user message
    contents.add({
      'role': 'user',
      'parts': [
        {'text': userMessage}
      ],
    });

    final url = Uri.parse('$_baseUrl?key=$_apiKey');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'systemInstruction': {
            'parts': [
              {'text': _systemPrompt}
            ]
          },
          'contents': contents,
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 1500,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final text =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
        return text ?? 'Не удалось получить ответ. Попробуйте ещё раз.';
      } else if (response.statusCode == 429) {
        throw Exception('Превышен лимит запросов. Попробуйте позже.');
      } else if (response.statusCode == 403) {
        throw Exception('Неверный API ключ.');
      } else {
        final error = jsonDecode(utf8.decode(response.bodyBytes));
        final msg = error['error']?['message'] ?? 'Ошибка Gemini API';
        throw Exception(msg);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Ошибка соединения: $e');
    }
  }
}

extension _ListExt<T> on List<T> {
  List<T> takeLast(int n) => length > n ? sublist(length - n) : this;
}
