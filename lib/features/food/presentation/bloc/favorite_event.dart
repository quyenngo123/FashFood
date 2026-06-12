import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_entity.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class WatchFavoritesEvent extends FavoriteEvent {
  final String userId;
  const WatchFavoritesEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ToggleFavoriteEvent extends FavoriteEvent {
  final FavoriteEntity favorite;
  final bool isAdd;
  const ToggleFavoriteEvent(this.favorite, this.isAdd);

  @override
  List<Object?> get props => [favorite, isAdd];
}

class UpdateFavoritesStateEvent extends FavoriteEvent {
  final List<FavoriteEntity> favorites;
  const UpdateFavoritesStateEvent(this.favorites);

  @override
  List<Object?> get props => [favorites];
}
