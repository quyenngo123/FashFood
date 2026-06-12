import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String userId; // Thêm trường này
  final String label;
  final String street;
  final String city;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.label,
    required this.street,
    required this.city,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, userId, label, street, city, isDefault];
}
