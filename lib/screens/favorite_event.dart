abstract class FavoriteEvent {
  const FavoriteEvent();
}

class ToggleFavoriteEvent extends FavoriteEvent {
  final Map<String, dynamic> quote;

  const ToggleFavoriteEvent(this.quote);
}