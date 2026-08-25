import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteStorageService {
  static const String _storageKey = 'favoriteQuotes';

  // ============================================================
  // CLEAN / NORMALIZE QUOTE TEXT
  // ============================================================
  static String cleanQuoteText(dynamic text) {
    if (text == null) return '';
    return text
        .toString()
        .replaceAll(RegExp(r'["“”‘’`\\]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // ============================================================
  // NORMALIZE QUOTE MAP
  // ============================================================
  static Map<String, dynamic> normalizeQuote(Map<String, dynamic> raw) {
    final rawText = raw['quote'] ?? raw['content'] ?? '';
    final cleanedQuote = cleanQuoteText(rawText);

    final rawAuthor = raw['author']?.toString().trim();
    final author = (rawAuthor != null && rawAuthor.isNotEmpty)
        ? rawAuthor
        : 'Soul Voice';

    final normalized = <String, dynamic>{
      'quote': cleanedQuote,
      'author': author,
    };

    if (raw.containsKey('id') && raw['id'] != null) {
      normalized['id'] = raw['id'];
    }
    if (raw.containsKey('tag') && raw['tag'] != null) {
      normalized['tag'] = raw['tag'].toString();
    }

    return normalized;
  }

  // ============================================================
  // COMPARE QUOTES FOR EQUALITY
  // ============================================================
  static bool isSameQuote(dynamic a, dynamic b) {
    String textA = '';
    String textB = '';

    if (a is String) {
      textA = cleanQuoteText(a);
    } else if (a is Map) {
      textA = cleanQuoteText(a['quote'] ?? a['content']);
    }

    if (b is String) {
      textB = cleanQuoteText(b);
    } else if (b is Map) {
      textB = cleanQuoteText(b['quote'] ?? b['content']);
    }

    if (textA.isEmpty || textB.isEmpty) return false;
    return textA.toLowerCase() == textB.toLowerCase();
  }

  // ============================================================
  // LOAD FAVORITES FROM STORAGE
  // ============================================================
  Future<List<Map<String, dynamic>>> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null || jsonString.trim().isEmpty) {
        return [];
      }

      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is List) {
        final List<Map<String, dynamic>> results = [];
        final Set<String> seen = {};

        for (final item in decoded) {
          if (item is Map) {
            final normalized = normalizeQuote(
              item.map((key, value) => MapEntry(key.toString(), value)),
            );
            final key = cleanQuoteText(normalized['quote']).toLowerCase();
            if (key.isNotEmpty && seen.add(key)) {
              results.add(normalized);
            }
          }
        }
        return results;
      }
    } catch (_) {
      // In case of parsing error, return empty list gracefully
    }
    return [];
  }

  // ============================================================
  // SAVE FAVORITES TO STORAGE
  // ============================================================
  Future<bool> saveFavorites(List<Map<String, dynamic>> quotes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> cleanList = [];
      final Set<String> seen = {};

      for (final item in quotes) {
        final normalized = normalizeQuote(item);
        final key = cleanQuoteText(normalized['quote']).toLowerCase();
        if (key.isNotEmpty && seen.add(key)) {
          cleanList.add(normalized);
        }
      }

      final jsonString = jsonEncode(cleanList);
      return await prefs.setString(_storageKey, jsonString);
    } catch (_) {
      return false;
    }
  }

  // ============================================================
  // CLEAR ALL FAVORITES
  // ============================================================
  Future<bool> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_storageKey);
    } catch (_) {
      return false;
    }
  }
}
