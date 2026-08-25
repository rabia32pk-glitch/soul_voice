import 'package:soul_voice/services/favorite_storage_service.dart';

class FavoriteState {
  final List<Map<String, dynamic>> favoriteQuotes;
  final bool isLoading;

  const FavoriteState({
    this.favoriteQuotes = const [],
    this.isLoading = false,
  });

  /// Check if a quote is favorited (supports String, Map, QuoteModel)
  bool isFavorite(dynamic quote) {
    if (quote == null) return false;
    return favoriteQuotes.any(
      (item) => FavoriteStorageService.isSameQuote(item, quote),
    );
  }

  /// Convenience helper to check by quote text string
  bool isFavoriteText(dynamic text) {
    if (text == null) return false;
    return isFavorite(text);
  }

  int get count => favoriteQuotes.length;

  FavoriteState copyWith({
    List<Map<String, dynamic>>? favoriteQuotes,
    bool? isLoading,
  }) {
    return FavoriteState(
      favoriteQuotes: favoriteQuotes ?? this.favoriteQuotes,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}