import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required String id,
    required String userId,
    required String label,
    required String street,
    required String city,
    bool isDefault = false,
  }) : super(
          id: id,
          userId: userId,
          label: label,
          street: street,
          city: city,
          isDefault: isDefault,
        );

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      label: json['label'] as String? ?? '',
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  factory AddressModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return AddressModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'label': label,
      'street': street,
      'city': city,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      userId: entity.userId,
      label: entity.label,
      street: entity.street,
      city: entity.city,
      isDefault: entity.isDefault,
    );
  }
}
