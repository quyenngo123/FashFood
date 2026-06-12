import 'package:equatable/equatable.dart';
import '../../domain/entities/voucher_entity.dart';

abstract class VoucherState extends Equatable {
  const VoucherState();
  
  @override
  List<Object?> get props => [];
}

class VoucherInitial extends VoucherState {}

class VoucherLoading extends VoucherState {}

class VoucherLoaded extends VoucherState {
  final List<VoucherEntity> vouchers;
  const VoucherLoaded(this.vouchers);

  @override
  List<Object?> get props => [vouchers];
}

class VoucherSingleLoaded extends VoucherState {
  final VoucherEntity? voucher;
  const VoucherSingleLoaded(this.voucher);

  @override
  List<Object?> get props => [voucher];
}

class VoucherError extends VoucherState {
  final String message;
  const VoucherError(this.message);

  @override
  List<Object?> get props => [message];
}
