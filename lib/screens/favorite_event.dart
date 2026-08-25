abstract class FavoriteEvent {
  const FavoriteEvent();
}

/// Load favorite quotes from local storage
class LoadFavoritesEvent extends FavoriteEvent {
  const LoadFavoritesEvent();
}

/// Toggle a quote between favorite / unfavorite
class ToggleFavoriteEvent extends FavoriteEvent {
  final dynamic quote;

  const ToggleFavoriteEvent(this.quote);
}

/// Explicitly remove a quote from favorites
class RemoveFavoriteEvent extends FavoriteEvent {
  final dynamic quote;

  const RemoveFavoriteEvent(this.quote);
}

/// Explicitly add a quote to favorites
class AddFavoriteEvent extends FavoriteEvent {
  final dynamic quote;

  const AddFavoriteEvent(this.quote);
}

/// Clear all favorites from local storage
class ClearFavoritesEvent extends FavoriteEvent {
  const ClearFavoritesEvent();
}