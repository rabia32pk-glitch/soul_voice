import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soul_voice/services/models/quote_model.dart';

class QuoteApiService {
  static const String baseUrl = 'https://zenquotes.io/api';

  Future<List<QuoteModel>> getQuotes() async {
    final response = await http.get(Uri.parse('$baseUrl/quotes'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load quotes (${response.statusCode})');
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data.map((json) => QuoteModel.fromJson(json)).toList();
  }

  Future<List<QuoteModel>> searchQuotes(String query) async {
    final quotes = await getQuotes();

    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) {
      return quotes;
    }

    return quotes.where((quote) {
      return quote.content.toLowerCase().contains(keyword) ||
          quote.author.toLowerCase().contains(keyword);
    }).toList();
  }

  Future<List<QuoteModel>> getQuotesByCategory(String category) async {
    final quotes = await getQuotes();

    final categoryKeywords = {
      'faith': ['faith', 'believe', 'belief', 'hope', 'trust', 'spiritual'],

      'life': ['life', 'living', 'live', 'journey', 'change', 'world', 'day'],

      'wisdom': ['wisdom', 'wise', 'knowledge', 'learn', 'truth', 'understand'],

      'success': [
        'success',
        'successful',
        'goal',
        'achievement',
        'win',
        'work',
      ],

      'love': ['love', 'loved', 'heart', 'care', 'relationship', 'kind'],

      'peace': ['peace', 'calm', 'quiet', 'harmony', 'still'],

      'motivation': [
        'motivation',
        'motivated',
        'strong',
        'dream',
        'goal',
        'work',
        'success',
        'never',
        'keep',
      ],

      'dua': ['pray', 'prayer', 'hope', 'faith', 'believe', 'trust'],
    };

    final keywords = categoryKeywords[category.trim().toLowerCase()] ?? [];

    if (keywords.isEmpty) {
      return [];
    }

    final filteredQuotes = quotes.where((quote) {
      final text = quote.content.toLowerCase();

      return keywords.any((keyword) => text.contains(keyword));
    }).toList();

    return filteredQuotes;
  }
}
