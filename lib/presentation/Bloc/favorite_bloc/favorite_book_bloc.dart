
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_event.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final Box<bool> _favoriteBox = Hive.box<bool>('favorites');

  FavoriteBloc() : super(FavoriteInitial()) {
    on<LoadFavoritesEvent>((event, emit) {
      Map<String, bool> favorites = _favoriteBox.toMap().map((key, value) => MapEntry(key.toString(), value));
      emit(FavoriteLoaded(favorites));
    });

    on<ToggleFavoriteEvent>((event, emit) {
      final currentFavorites = Map<String, bool>.from(state is FavoriteLoaded ? (state as FavoriteLoaded).favorites : {});
      final isFavorite = currentFavorites[event.bookId] ?? false;

      if (isFavorite) {
        _favoriteBox.delete(event.bookId);
      } else {
        _favoriteBox.put(event.bookId, true);
      }

      currentFavorites[event.bookId] = !isFavorite;
      emit(FavoriteLoaded(currentFavorites));
    });
  }
}
