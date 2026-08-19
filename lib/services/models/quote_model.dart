class QuoteModel {
  final int id;
  final String content;
  final String author;

  QuoteModel({
    required this.id,
    required this.content,
    required this.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] ?? 0,
      content: json['quote'] ?? json['content'] ?? 'No quote content available.',
      author: json['author'] ?? 'Unknown Author',
    );
  }
}