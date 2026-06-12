import 'package:equatable/equatable.dart';

abstract class VoucherEvent extends Equatable {
  const VoucherEvent();

  @override
  List<Object?> get props => [];
}

class GetVouchersEvent extends VoucherEvent {}

class GetVoucherByCodeEvent extends VoucherEvent {
  final String code;
  const GetVoucherByCodeEvent(this.code);

  @override
  List<Object?> get props => [code];
}
