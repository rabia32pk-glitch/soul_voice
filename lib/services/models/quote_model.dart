class QuoteModel {
  final int id;
  final String content;
  final String author;

  QuoteModel({required this.id, required this.content, required this.author});

  // Helper method to clean quotes from API text
  static String _sanitizeQuote(String text) {
    return text
        .replaceAll('"', '')
        .replaceAll('“', '')
        .replaceAll('”', '')
        .replaceAll('‘', '')
        .replaceAll('’', '')
        .trim();
  }

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    final rawContent =
        json['quote'] ?? json['content'] ?? 'No quote content available.';

    return QuoteModel(
      id: json['id'] ?? 0,
      content: _sanitizeQuote(rawContent), // Model level clean up
      author: json['author'] ?? 'Unknown Author',
    );
  }
}
