import 'package:equatable/equatable.dart';
import '../../domain/entities/combo_entity.dart';

abstract class ComboState extends Equatable {
  const ComboState();
  
  @override
  List<Object?> get props => [];
}

class ComboInitial extends ComboState {}

class ComboLoading extends ComboState {}

class ComboLoaded extends ComboState {
  final List<ComboEntity> combos;
  const ComboLoaded(this.combos);

  @override
  List<Object?> get props => [combos];
}

class ComboError extends ComboState {
  final String message;
  const ComboError(this.message);

  @override
  List<Object?> get props => [message];
}
