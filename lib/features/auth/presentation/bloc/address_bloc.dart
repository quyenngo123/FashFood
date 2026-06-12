import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/address_remote_data_source.dart';
import '../../data/models/address_model.dart';
import 'address_event.dart';
import 'address_state.dart';

export 'address_event.dart';
export 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRemoteDataSource _remoteDataSource;

  AddressBloc({
    required AddressRemoteDataSource remoteDataSource,
  })  : _remoteDataSource = remoteDataSource,
        super(AddressInitial()) {
    on<GetAddressesEvent>(_onGetAddresses);
    on<SaveAddressEvent>(_onSaveAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
  }

  Future<void> _onGetAddresses(GetAddressesEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      final addresses = await _remoteDataSource.getAddresses(event.userId);
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onSaveAddress(SaveAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      // Đảm bảo AddressModel nhận vào có đủ userId từ Entity
      final addressModel = AddressModel.fromEntity(event.address);
      await _remoteDataSource.saveAddress(addressModel);
      
      emit(AddressActionSuccess());
      
      // Tự động load lại danh sách địa chỉ cho người dùng hiện tại
      add(GetAddressesEvent(event.address.userId));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onDeleteAddress(DeleteAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      await _remoteDataSource.deleteAddress(event.addressId);
      emit(AddressActionSuccess());
      // Refresh lại danh sách
      add(GetAddressesEvent(event.userId));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onSetDefaultAddress(SetDefaultAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      await _remoteDataSource.setDefaultAddress(event.userId, event.addressId);
      emit(AddressActionSuccess());
      // Refresh lại danh sách để UI cập nhật dấu tick "Mặc định"
      add(GetAddressesEvent(event.userId));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}
