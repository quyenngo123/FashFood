import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String productId;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String? note;

  const CartItemEntity({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    this.note,
  });

  // Tính tổng tiền của riêng món này (giá x số lượng)
  double get totalPrice => price * quantity;

  CartItemEntity copyWith({
    int? quantity,
    String? note,
  }) {
    return CartItemEntity(
      productId: productId,
      name: name,
      image: image,
      price: price,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [productId, name, image, price, quantity, note];
}