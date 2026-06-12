import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_model.dart';

class CartRemoteDataSource {
  final FirebaseFirestore firestore;

  CartRemoteDataSource({required this.firestore});

  /// Theo dõi giỏ hàng thời gian thực theo userId
  Stream<CartModel?> watchCart(String userId) {
    return firestore
        .collection('carts')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      // Lấy document đầu tiên tìm thấy
      return CartModel.fromSnapshot(snapshot.docs.first);
    });
  }

  /// Lấy giỏ hàng (Future)
  Future<CartModel?> getCart(String userId) async {
    try {
      final snapshot = await firestore
          .collection('carts')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) return null;
      return CartModel.fromSnapshot(snapshot.docs.first);
    } catch (e) {
      throw Exception('Lỗi khi lấy giỏ hàng: $e');
    }
  }

  /// Cập nhật giỏ hàng
  Future<void> updateCart(CartModel cart) async {
    try {
      final snapshot = await firestore
          .collection('carts')
          .where('userId', isEqualTo: cart.userId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Nếu đã có giỏ hàng thì update
        await snapshot.docs.first.reference.update(cart.toJson());
      } else {
        // Nếu chưa có thì thêm mới
        await firestore.collection('carts').add(cart.toJson());
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật giỏ hàng: $e');
    }
  }

  /// Xóa giỏ hàng
  Future<void> deleteCart(String userId) async {
    try {
      final snapshot = await firestore
          .collection('carts')
          .where('userId', isEqualTo: userId)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Lỗi khi xóa giỏ hàng: $e');
    }
  }
}
