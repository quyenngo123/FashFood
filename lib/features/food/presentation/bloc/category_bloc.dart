import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/data/datasources/category_remote_data_source.dart';
import 'category_event.dart';
import 'category_state.dart';

export 'category_event.dart';
export 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryBloc({required CategoryRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource,
        super(CategoryInitial()) {
    on<WatchCategoriesEvent>(_onWatchCategories);
    on<UpdateCategoriesEvent>(_onUpdateCategories);
  }

  Future<void> _onWatchCategories(WatchCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await _remoteDataSource.getCategories();
      emit(CategoryLoaded(categories));
    } catch (error) {
      emit(CategoryError(error.toString()));
    }
  }

  void _onUpdateCategories(UpdateCategoriesEvent event, Emitter<CategoryState> emit) {
    emit(CategoryLoaded(event.categories.cast()));
  }
}
