import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/voucher_remote_data_source.dart';
import 'voucher_event.dart';
import 'voucher_state.dart';

export 'voucher_event.dart';
export 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final VoucherRemoteDataSource _remoteDataSource;

  VoucherBloc({
    required VoucherRemoteDataSource remoteDataSource,
  })  : _remoteDataSource = remoteDataSource,
        super(VoucherInitial()) {
    on<GetVouchersEvent>(_onGetVouchers);
    on<GetVoucherByCodeEvent>(_onGetVoucherByCode);
  }

  Future<void> _onGetVouchers(GetVouchersEvent event, Emitter<VoucherState> emit) async {
    emit(VoucherLoading());
    try {
      final vouchers = await _remoteDataSource.getVouchers();
      emit(VoucherLoaded(vouchers));
    } catch (e) {
      emit(VoucherError(e.toString()));
    }
  }

  Future<void> _onGetVoucherByCode(GetVoucherByCodeEvent event, Emitter<VoucherState> emit) async {
    emit(VoucherLoading());
    try {
      final voucher = await _remoteDataSource.getVoucherByCode(event.code);
      emit(VoucherSingleLoaded(voucher));
    } catch (e) {
      emit(VoucherError(e.toString()));
    }
  }
}
