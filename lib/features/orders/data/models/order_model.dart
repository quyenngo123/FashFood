import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/order_entity.dart';
import '../../../food/data/models/cart_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    super.id,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.address,
    required super.phone,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    return OrderModel(
      id: id,
      userId: json['userId'] ?? '',
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] ?? 'pending',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      // SỬA TẠI ĐÂY: Sử dụng fromEntity thay vì ép kiểu (as CartItemModel)
      'items': items.map((item) => CartItemModel.fromEntity(item).toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'address': address,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
