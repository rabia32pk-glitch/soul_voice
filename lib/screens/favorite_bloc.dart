import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteState()) {
    on<ToggleFavoriteEvent>((event, emit) {
      final currentList = List<Map<String, dynamic>>.from(state.favoriteQuotes);
      
      final index = currentList.indexWhere(
        (q) => q['quote'] == event.quote['quote'],
      );

      if (index >= 0) {
        currentList.removeAt(index);
      } else {
        currentList.add(event.quote);
      }

      emit(state.copyWith(favoriteQuotes: currentList));
    });
  }
}