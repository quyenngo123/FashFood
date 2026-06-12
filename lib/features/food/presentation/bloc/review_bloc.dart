import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/review_remote_data_source.dart';
import '../../data/models/review_model.dart';
import 'review_event.dart';
import 'review_state.dart';

export 'review_event.dart';
export 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRemoteDataSource _remoteDataSource;

  ReviewBloc({
    required ReviewRemoteDataSource remoteDataSource,
  })  : _remoteDataSource = remoteDataSource,
        super(ReviewInitial()) {
    on<WatchReviewsEvent>(_onWatchReviews);
    on<AddReviewEvent>(_onAddReview);
    on<UpdateReviewsStateEvent>(_onUpdateReviewsState);
  }

  Future<void> _onWatchReviews(WatchReviewsEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final reviews = await _remoteDataSource.getReviewsByFoodId(event.foodId);
      emit(ReviewLoaded(reviews));
    } catch (error) {
      emit(ReviewError(error.toString()));
    }
  }

  Future<void> _onAddReview(AddReviewEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewSubmitting());
    try {
      await _remoteDataSource.addReview(ReviewModel.fromEntity(event.review));
      emit(ReviewSubmittedSuccess());
      add(WatchReviewsEvent(event.review.foodId)); // Refresh reviews
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  void _onUpdateReviewsState(UpdateReviewsStateEvent event, Emitter<ReviewState> emit) {
    emit(ReviewLoaded(event.reviews));
  }
}
