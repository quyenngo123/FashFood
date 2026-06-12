import 'package:equatable/equatable.dart';
import '../../domain/entities/address_entity.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class GetAddressesEvent extends AddressEvent {
  final String userId;
  const GetAddressesEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SaveAddressEvent extends AddressEvent {
  final AddressEntity address;
  const SaveAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class DeleteAddressEvent extends AddressEvent {
  final String addressId;
  final String userId;
  const DeleteAddressEvent({required this.addressId, required this.userId});

  @override
  List<Object?> get props => [addressId, userId];
}

class SetDefaultAddressEvent extends AddressEvent {
  final String userId;
  final String addressId;
  const SetDefaultAddressEvent({required this.userId, required this.addressId});

  @override
  List<Object?> get props => [userId, addressId];
}
