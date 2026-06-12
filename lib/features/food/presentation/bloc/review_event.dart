import 'package:equatable/equatable.dart';
import '../../domain/entities/review_entity.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class WatchReviewsEvent extends ReviewEvent {
  final String foodId;
  const WatchReviewsEvent(this.foodId);

  @override
  List<Object?> get props => [foodId];
}

class AddReviewEvent extends ReviewEvent {
  final ReviewEntity review;
  const AddReviewEvent(this.review);

  @override
  List<Object?> get props => [review];
}

class UpdateReviewsStateEvent extends ReviewEvent {
  final List<ReviewEntity> reviews;
  const UpdateReviewsStateEvent(this.reviews);

  @override
  List<Object?> get props => [reviews];
}
