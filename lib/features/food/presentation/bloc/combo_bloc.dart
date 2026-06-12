import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/combo_remote_data_source.dart';
import 'combo_event.dart';
import 'combo_state.dart';

export 'combo_event.dart';
export 'combo_state.dart';

class ComboBloc extends Bloc<ComboEvent, ComboState> {
  final ComboRemoteDataSource _remoteDataSource;

  ComboBloc({required ComboRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource,
        super(ComboInitial()) {
    on<WatchCombosEvent>(_onWatchCombos);
    on<UpdateCombosStateEvent>(_onUpdateCombosState);
  }

  Future<void> _onWatchCombos(WatchCombosEvent event, Emitter<ComboState> emit) async {
    emit(ComboLoading());
    try {
      final combos = await _remoteDataSource.getCombos();
      emit(ComboLoaded(combos));
    } catch (error) {
      emit(ComboError(error.toString()));
    }
  }

  void _onUpdateCombosState(UpdateCombosStateEvent event, Emitter<ComboState> emit) {
    emit(ComboLoaded(event.combos));
  }
}
