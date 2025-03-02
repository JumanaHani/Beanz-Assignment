

abstract class FavoriteState  {
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final Map<String, bool> favorites;

  FavoriteLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}
