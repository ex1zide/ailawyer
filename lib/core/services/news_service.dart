import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:html/parser.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart'; // fallback

/// Service for fetching and parsing real RSS news (Zakon.kz / Tengrinews)
class NewsService {
  // Zakon.kz main RSS feed
  static const String _rssUrl = 'https://www.zakon.kz/rss.xml';

  Future<List<LegalNews>> fetchRealNews() async {
    try {
      final response = await http.get(Uri.parse(_rssUrl));
      if (response.statusCode == 200) {
        // Parse RSS feed, handling decoding properly
        final decodedBytes = utf8.decode(response.bodyBytes, allowMalformed: true);
        final feed = RssFeed.parse(decodedBytes);

        return feed.items.map((item) {
          // Attempt to extract text from HTML description
          String summaryText = item.description ?? '';
          try {
            final document = parse(summaryText);
            summaryText = document.body?.text ?? summaryText;
            summaryText = summaryText.trim().replaceAll('\n', ' ');
            if (summaryText.length > 150) {
              summaryText = '${summaryText.substring(0, 147)}...';
            }
          } catch (_) {}

          // Determine category dynamically based on link/title
          String category = 'Новости';
          if (item.title?.toLowerCase().contains('закон') == true ||
              item.title?.toLowerCase().contains('суд') == true ||
              item.title?.toLowerCase().contains('полиция') == true) {
            category = 'Законодательство';
          }

          // Try to extract image enclosure
          String? imageUrl;
          if (item.enclosure != null && item.enclosure?.url != null) {
            imageUrl = item.enclosure!.url;
          }

          return LegalNews(
            id: item.guid ?? DateTime.now().millisecondsSinceEpoch.toString(),
            title: item.title ?? 'Без заголовка',
            summary: summaryText,
            category: category,
            publishedAt: _parseDate(item.pubDate),
            source: 'Zakon.kz',
            url: item.link,
            imageUrl: imageUrl,
          );
        }).toList();
      }
    } catch (e) {
      // Return mock data fallback on failure
      print('RSS Fetch Error: $e');
    }
    return MockData.news;
  }

  DateTime _parseDate(String? pubDateStr) {
    if (pubDateStr == null) return DateTime.now();
    try {
      // Basic fallback since HttpDate from dart:io causes web compilation issues
      // E.g. "Wed, 18 Mar 2026 01:23:45 GMT"
      // Attempt generic RFC 1123 parse or fallback to now
      return DateTime.parse(pubDateStr);
    } catch (_) {
      // Fallback 2: Basic regex extraction
      try {
        final regex = RegExp(r"(\d{1,2}) ([A-Za-z]{3}) (\d{4}) (\d{2}):(\d{2}):(\d{2})");
        final match = regex.firstMatch(pubDateStr);
        if (match != null) {
          final day = int.parse(match.group(1)!);
          final year = int.parse(match.group(3)!);
          return DateTime(year, 1, day); // Simplified parse
        }
      } catch (__) {}
      return DateTime.now();
    }
  }
}
