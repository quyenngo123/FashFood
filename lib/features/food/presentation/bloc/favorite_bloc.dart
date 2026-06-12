import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/favorite_remote_data_source.dart';
import '../../data/models/favorite_model.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

export 'favorite_event.dart';
export 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRemoteDataSource _remoteDataSource;

  FavoriteBloc({
    required FavoriteRemoteDataSource remoteDataSource,
  })  : _remoteDataSource = remoteDataSource,
        super(FavoriteInitial()) {
    on<WatchFavoritesEvent>(_onWatchFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<UpdateFavoritesStateEvent>(_onUpdateFavoritesState);
  }

  Future<void> _onWatchFavorites(WatchFavoritesEvent event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final favorites = await _remoteDataSource.getFavorites(event.userId);
      emit(FavoriteLoaded(favorites));
    } catch (error) {
      emit(FavoriteError(error.toString()));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    try {
      await _remoteDataSource.toggleFavorite(
        FavoriteModel.fromEntity(event.favorite),
        event.isAdd,
      );
      // Tải lại danh sách sau khi thay đổi để đồng bộ UI
      add(WatchFavoritesEvent(event.favorite.userId));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  void _onUpdateFavoritesState(UpdateFavoritesStateEvent event, Emitter<FavoriteState> emit) {
    emit(FavoriteLoaded(event.favorites));
  }
}
