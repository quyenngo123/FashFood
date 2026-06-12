import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/banner_remote_data_source.dart';
import 'banner_event.dart';
import 'banner_state.dart';

export 'banner_event.dart';
export 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRemoteDataSource _remoteDataSource;

  BannerBloc({required BannerRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource,
        super(BannerInitial()) {
    on<WatchBannersEvent>(_onWatchBanners);
    on<UpdateBannersStateEvent>(_onUpdateBannersState);
  }

  Future<void> _onWatchBanners(WatchBannersEvent event, Emitter<BannerState> emit) async {
    emit(BannerLoading());
    try {
      final banners = await _remoteDataSource.getBanners();
      emit(BannerLoaded(banners));
    } catch (error) {
      emit(BannerError(error.toString()));
    }
  }

  void _onUpdateBannersState(UpdateBannersStateEvent event, Emitter<BannerState> emit) {
    emit(BannerLoaded(event.banners.cast()));
  }
}
