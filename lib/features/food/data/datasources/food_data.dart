import '../../domain/entities/food_entity.dart';

class FoodData {
  static const List<String> categories = [
    'Tất cả', 'Burger', 'Pizza', 'Gà Rán', 'Tráng Miệng',
    'Bánh Mì', 'Kimbap', 'Mì Ý', 'Đồ uống', 'Lẩu', 'Ăn Vặt'
  ];

  // ĐÃ XÓA TRẮNG DỮ LIỆU CỨNG
  // Mục đích: Nếu App hiển thị món ăn -> Chắc chắn lấy từ Firebase.
  // Nếu App hiện "Chưa có món nào" -> Bloc chưa lấy được dữ liệu từ Firebase.
  static const List<FoodEntity> foods = [];

  static List<FoodEntity> getByCategory(String category) {
    return [];
  }
}
