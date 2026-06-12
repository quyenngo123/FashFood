import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_model.dart';

class FoodRemoteDataSource {
  final FirebaseFirestore firestore;

  FoodRemoteDataSource({required this.firestore});

  /// Theo dõi danh sách món ăn thời gian thực
  Stream<List<FoodModel>> watchFoods() {
    return firestore.collection('foods').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => FoodModel.fromSnapshot(doc)).toList();
    });
  }

  /// Lấy danh mục từ Firestore
  Future<List<String>> getCategories() async {
    try {
      final snapshot = await firestore.collection('categories').get();
      if (snapshot.docs.isEmpty) return [];
      // Giả sử mỗi doc có trường 'name'
      return snapshot.docs.map((doc) => doc.get('name').toString()).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<FoodModel>> getFoods() async {
    final snapshot = await firestore.collection('foods').get();
    return snapshot.docs.map((doc) => FoodModel.fromSnapshot(doc)).toList();
  }
}
