import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soul_voice/services/favorite_storage_service.dart';

import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteStorageService _storageService;

  FavoriteBloc({FavoriteStorageService? storageService})
      : _storageService = storageService ?? FavoriteStorageService(),
        super(const FavoriteState(isLoading: true)) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<ClearFavoritesEvent>(_onClearFavorites);

    // Initial load from local storage
    add(const LoadFavoritesEvent());
  }

  // ============================================================
  // LOAD FAVORITES
  // ============================================================
  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final favorites = await _storageService.loadFavorites();
    emit(
      state.copyWith(
        favoriteQuotes: favorites,
        isLoading: false,
      ),
    );
  }

  // ============================================================
  // TOGGLE FAVORITE
  // ============================================================
  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final targetQuote = event.quote;
    if (targetQuote == null) return;

    final updatedFavorites = List<Map<String, dynamic>>.from(
      state.favoriteQuotes,
    );

    final existingIndex = updatedFavorites.indexWhere(
      (item) => FavoriteStorageService.isSameQuote(item, targetQuote),
    );

    if (existingIndex != -1) {
      // Remove from favorites
      updatedFavorites.removeAt(existingIndex);
    } else {
      // Add to favorites (insert at the beginning so newest favorite is at top)
      Map<String, dynamic> quoteMap;
      if (targetQuote is Map) {
        quoteMap = targetQuote.map((k, v) => MapEntry(k.toString(), v));
      } else if (targetQuote is String) {
        quoteMap = {'quote': targetQuote, 'author': 'Soul Voice'};
      } else {
        quoteMap = {
          'quote': targetQuote.content ?? targetQuote.toString(),
          'author': targetQuote.author ?? 'Soul Voice',
        };
      }

      final normalized = FavoriteStorageService.normalizeQuote(quoteMap);
      updatedFavorites.insert(0, normalized);
    }

    emit(
      state.copyWith(
        favoriteQuotes: updatedFavorites,
      ),
    );

    await _storageService.saveFavorites(updatedFavorites);
  }

  // ============================================================
  // ADD FAVORITE
  // ============================================================
  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final targetQuote = event.quote;
    if (targetQuote == null) return;

    final updatedFavorites = List<Map<String, dynamic>>.from(
      state.favoriteQuotes,
    );

    final exists = updatedFavorites.any(
      (item) => FavoriteStorageService.isSameQuote(item, targetQuote),
    );

    if (!exists) {
      Map<String, dynamic> quoteMap;
      if (targetQuote is Map) {
        quoteMap = targetQuote.map((k, v) => MapEntry(k.toString(), v));
      } else if (targetQuote is String) {
        quoteMap = {'quote': targetQuote, 'author': 'Soul Voice'};
      } else {
        quoteMap = {
          'quote': targetQuote.content ?? targetQuote.toString(),
          'author': targetQuote.author ?? 'Soul Voice',
        };
      }

      final normalized = FavoriteStorageService.normalizeQuote(quoteMap);
      updatedFavorites.insert(0, normalized);

      emit(
        state.copyWith(
          favoriteQuotes: updatedFavorites,
        ),
      );

      await _storageService.saveFavorites(updatedFavorites);
    }
  }

  // ============================================================
  // REMOVE FAVORITE
  // ============================================================
  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final targetQuote = event.quote;
    if (targetQuote == null) return;

    final updatedFavorites = List<Map<String, dynamic>>.from(
      state.favoriteQuotes,
    );

    final initialLength = updatedFavorites.length;
    updatedFavorites.removeWhere(
      (item) => FavoriteStorageService.isSameQuote(item, targetQuote),
    );

    if (updatedFavorites.length != initialLength) {
      emit(
        state.copyWith(
          favoriteQuotes: updatedFavorites,
        ),
      );

      await _storageService.saveFavorites(updatedFavorites);
    }
  }

  // ============================================================
  // CLEAR FAVORITES
  // ============================================================
  Future<void> _onClearFavorites(
    ClearFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(
      state.copyWith(
        favoriteQuotes: const [],
      ),
    );

    await _storageService.clearFavorites();
  }
}