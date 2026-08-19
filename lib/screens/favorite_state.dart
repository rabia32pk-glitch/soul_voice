class FavoriteState {
  final List<Map<String, dynamic>> favoriteQuotes;

  const FavoriteState({this.favoriteQuotes = const []});

  FavoriteState copyWith({List<Map<String, dynamic>>? favoriteQuotes}) {
    return FavoriteState(
      favoriteQuotes: favoriteQuotes ?? this.favoriteQuotes,
    );
  }
}