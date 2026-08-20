import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteState()) {
    on<ToggleFavoriteEvent>(_toggleFavorite);
  }

  void _toggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) {
    // Current favorites ki new list banao
    final updatedFavorites = List<Map<String, dynamic>>.from(
      state.favoriteQuotes,
    );

    // Quote ko uske text se identify karo
    final existingIndex = updatedFavorites.indexWhere(
      (item) =>
          item['quote']?.toString() ==
          event.quote['quote']?.toString(),
    );

    if (existingIndex != -1) {
      // ==============================================
      // ALREADY FAVORITE
      // Remove from favorites
      // ==============================================

      updatedFavorites.removeAt(existingIndex);
    } else {
      // ==============================================
      // NOT FAVORITE
      // Add to favorites
      // ==============================================

      updatedFavorites.add(
        Map<String, dynamic>.from(event.quote),
      );
    }

    // ==============================================
    // NEW STATE
    // ==============================================

    emit(
      state.copyWith(
        favoriteQuotes: updatedFavorites,
      ),
    );
  }
}