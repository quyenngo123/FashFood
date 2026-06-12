import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/food_entity.dart';

class FoodModel extends FoodEntity {
  const FoodModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.rating,
    required super.reviewCount,
    required super.imageUrl,
    required super.category,
    super.isPopular = false,
    super.isPromo = false,
    super.originalPrice,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      // Dùng toString() và các hàm chuyển đổi an toàn để tránh crash khi kiểu dữ liệu trên Firebase không chuẩn
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Không tên',
      description: json['description']?.toString() ?? '',
      price: _toDouble(json['price']),
      rating: _toDouble(json['rating']),
      reviewCount: _toInt(json['reviewCount']),
      // Hỗ trợ cả hai tên trường phổ biến 'imageUrl' và 'image'
      imageUrl: (json['imageUrl'] ?? json['image'])?.toString() ?? '',
      category: json['category']?.toString() ?? 'Tất cả',
      isPopular: json['isPopular'] == true,
      isPromo: json['isPromo'] == true,
      originalPrice: _toDouble(json['originalPrice']),
    );
  }

  static double _toDouble(dynamic val) {
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic val) {
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? 0;
    return 0;
  }

  factory FoodModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    return FoodModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'category': category,
      'isPopular': isPopular,
      'isPromo': isPromo,
      'originalPrice': originalPrice,
    };
  }

  factory FoodModel.fromEntity(FoodEntity entity) {
    return FoodModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      imageUrl: entity.imageUrl,
      category: entity.category,
      isPopular: entity.isPopular,
      isPromo: entity.isPromo,
      originalPrice: entity.originalPrice,
    );
  }
}
