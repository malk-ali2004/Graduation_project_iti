import 'package:bloc/bloc.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {
    on<ToggleFavorite>((event, emit) {
      final favorites = List.of(state.favorites);
      if (favorites.contains(event.product)) {
        favorites.remove(event.product);
      } else {
        favorites.add(event.product);
      }
      emit(state.copyWith(favorites: favorites));
    });
  }
}
