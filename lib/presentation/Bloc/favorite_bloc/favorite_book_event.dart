
abstract class FavoriteEvent  {
  @override
  List<Object?> get props => [];
}

class ToggleFavoriteEvent extends FavoriteEvent {
  final String bookId;

  ToggleFavoriteEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class LoadFavoritesEvent extends FavoriteEvent {}
