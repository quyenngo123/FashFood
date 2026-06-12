
import 'package:equatable/equatable.dart';
import '../../domain/entities/food_entity.dart';


abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object?> get props => [];
}

class WatchFoodsEvent extends FoodEvent {}

class UpdateFoodsEvent extends FoodEvent {
  final List<FoodEntity> foods;

  const UpdateFoodsEvent(this.foods);

  @override
  List<Object?> get props => [foods];
}


class SearchFoodEvent extends FoodEvent {
  final String query;
  const SearchFoodEvent(this.query);

  @override
  List<Object?> get props => [query];
}
