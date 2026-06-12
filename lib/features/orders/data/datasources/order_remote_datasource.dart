import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSource({required this.firestore});

  Future<void> createOrder(OrderModel order) async {
    try {
      await firestore.collection('orders').add(order.toJson());
    } catch (e) {
      throw Exception('Lỗi khi tạo đơn hàng: $e');
    }
  }

  Future<List<OrderModel>> getOrders(String userId) async {
    try {
      final snapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách đơn hàng: $e');
    }
  }
}
