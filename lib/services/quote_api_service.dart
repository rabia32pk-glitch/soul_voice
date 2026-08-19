import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'models/quote_model.dart';

class QuoteApiService {
  static const String _baseUrl = 'https://dummyjson.com/quotes';
  final Random _random = Random();

  // 1. Fixed Next Quote Problem: Dynamic Random Quote
  Future<QuoteModel> fetchRandomQuote() async {
    try {
      // Random skip index (1 to 100) generate kar ke dynamic quote layenge
      final randomId = _random.nextInt(100) + 1;
      final response = await http
          .get(Uri.parse('$_baseUrl/$randomId'))
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return QuoteModel.fromJson(data);
      }
    } catch (e) {
      // API Fail hone par random fallback quote milega
    }

    final fallbackList = _getCategoryFallback('general');
    return fallbackList[_random.nextInt(fallbackList.length)];
  }

  // 2. Featured Quotes (Home Screen)
  Future<List<QuoteModel>> getQuotes() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl?limit=15'))
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> quotesJson = data['quotes'] ?? [];
        if (quotesJson.isNotEmpty) {
          final list = quotesJson
              .map((json) => QuoteModel.fromJson(json))
              .toList();
          list.shuffle(); // Har baar random shuffle order
          return list;
        }
      }
    } catch (e) {
      // API fail fallback
    }
    return _getCategoryFallback('general');
  }

  // 3. Category Specific Quotes List
  Future<List<QuoteModel>> getQuotesByCategory(String category) async {
    final cleanCategory = category.toLowerCase().trim();
    try {
      final url = '$_baseUrl/search?q=$cleanCategory';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> quotesJson = data['quotes'] ?? [];
        if (quotesJson.isNotEmpty) {
          return quotesJson.map((json) => QuoteModel.fromJson(json)).toList();
        }
      }
    } catch (e) {
      // Fallback
    }

    return _getCategoryFallback(cleanCategory);
  }

  // Category Multi-Quote Fallback Data
  List<QuoteModel> _getCategoryFallback(String category) {
    final Map<String, List<QuoteModel>> categoryData = {
      'faith': [
        QuoteModel(
          id: 101,
          content: "Verily, with hardship comes ease.",
          author: "Quran (94:6)",
        ),
        QuoteModel(
          id: 102,
          content: "Do not lose hope, nor be sad.",
          author: "Quran (3:139)",
        ),
        QuoteModel(
          id: 103,
          content:
              "Faith is taking the first step even when you don't see the whole staircase.",
          author: "Martin Luther King Jr.",
        ),
        QuoteModel(
          id: 104,
          content: "Trust in Allah, but tie your camel.",
          author: "Prophet Muhammad (PBUH)",
        ),
      ],
      'life': [
        QuoteModel(
          id: 201,
          content: "Life is what happens when you're busy making other plans.",
          author: "John Lennon",
        ),
        QuoteModel(
          id: 202,
          content: "Get busy living or get busy dying.",
          author: "Stephen King",
        ),
        QuoteModel(
          id: 203,
          content: "The purpose of our lives is to be happy.",
          author: "Dalai Lama",
        ),
        QuoteModel(
          id: 204,
          content:
              "Life is 10% what happens to you and 90% how you react to it.",
          author: "Charles R. Swindoll",
        ),
      ],
      'wisdom': [
        QuoteModel(
          id: 301,
          content: "The only true wisdom is in knowing you know nothing.",
          author: "Socrates",
        ),
        QuoteModel(
          id: 302,
          content: "Silence is a source of great strength.",
          author: "Lao Tzu",
        ),
        QuoteModel(
          id: 303,
          content:
              "The best among you are those who have the best manners and character.",
          author: "Prophet Muhammad (PBUH)",
        ),
        QuoteModel(
          id: 304,
          content: "Turn your wounds into wisdom.",
          author: "Oprah Winfrey",
        ),
      ],
      'success': [
        QuoteModel(
          id: 401,
          content:
              "Success is not final, failure is not fatal: it is the courage to continue that counts.",
          author: "Winston Churchill",
        ),
        QuoteModel(
          id: 402,
          content: "The way to get started is to quit talking and begin doing.",
          author: "Walt Disney",
        ),
        QuoteModel(
          id: 403,
          content:
              "Don't let the fear of losing be greater than the excitement of winning.",
          author: "Robert Kiyosaki",
        ),
        QuoteModel(
          id: 404,
          content:
              "Success usually comes to those who are too busy to be looking for it.",
          author: "Henry David Thoreau",
        ),
      ],
      'love': [
        QuoteModel(
          id: 501,
          content: "The best thing to hold onto in life is each other.",
          author: "Audrey Hepburn",
        ),
        QuoteModel(
          id: 502,
          content: "Love all, trust a few, do wrong to none.",
          author: "William Shakespeare",
        ),
        QuoteModel(
          id: 503,
          content: "Where there is love there is life.",
          author: "Mahatma Gandhi",
        ),
        QuoteModel(
          id: 504,
          content: "Spread love everywhere you go.",
          author: "Mother Teresa",
        ),
      ],
      'peace': [
        QuoteModel(
          id: 601,
          content: "Peace comes from within. Do not seek it without.",
          author: "Buddha",
        ),
        QuoteModel(
          id: 602,
          content:
              "When the power of love overcomes the love of power, the world will know peace.",
          author: "Jimi Hendrix",
        ),
        QuoteModel(
          id: 603,
          content: "If you want peace, stop fighting.",
          author: "Unknown",
        ),
        QuoteModel(
          id: 604,
          content:
              "Peace is not absence of conflict, it is the ability to handle conflict.",
          author: "Ronald Reagan",
        ),
      ],
    };

    return categoryData[category] ?? categoryData['faith']!;
  }
}
