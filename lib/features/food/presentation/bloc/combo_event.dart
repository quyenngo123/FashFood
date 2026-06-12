import 'package:equatable/equatable.dart';
import '../../domain/entities/combo_entity.dart';

abstract class ComboEvent extends Equatable {
  const ComboEvent();

  @override
  List<Object?> get props => [];
}

class WatchCombosEvent extends ComboEvent {}

class UpdateCombosStateEvent extends ComboEvent {
  final List<ComboEntity> combos;
  const UpdateCombosStateEvent(this.combos);

  @override
  List<Object?> get props => [combos];
}
