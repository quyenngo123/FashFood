import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class WatchCategoriesEvent extends CategoryEvent {}

class UpdateCategoriesEvent extends CategoryEvent {
  final List<dynamic> categories;
  const UpdateCategoriesEvent(this.categories);

  @override
  List<Object?> get props => [categories];
}
