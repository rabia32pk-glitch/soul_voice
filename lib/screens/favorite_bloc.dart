import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteState()) {
    on<ToggleFavoriteEvent>(_toggleFavorite);
    _loadFavorites();
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
      _saveFavorites();
    }

    // ==============================================
    // NEW STATE
    // ==============================================

    emit(
      state.copyWith(
        favoriteQuotes: updatedFavorites,
      ),
    );
    _saveFavorites();
  }
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('favoriteQuotes');
    if (jsonString != null) {
      final List<dynamic> list = jsonDecode(jsonString);
      final favorites = list.map((e) => Map<String, dynamic>.from(e)).toList();
      emit(state.copyWith(favoriteQuotes: favorites));
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.favoriteQuotes);
    await prefs.setString('favoriteQuotes', jsonString);
  }
}