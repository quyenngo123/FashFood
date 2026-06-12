import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/food_data.dart';
import '../../domain/entities/food_entity.dart';
import '../bloc/food_bloc.dart';
import '../widgets/food_card.dart';
import '../widgets/food_filter_bar.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  String _selectedCategory = 'Tất cả';
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    // Đảm bảo dữ liệu được tải ngay khi vào trang
    context.read<FoodBloc>().add(WatchFoodsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          FoodFilterBar(
            categories: FoodData.categories,
            selectedCategory: _selectedCategory,
            onSelected: (cat) => setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<FoodBloc, FoodState>(
              builder: (context, state) {
                if (state is FoodLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FoodLoaded) {
                  final filteredFoods = _selectedCategory == 'Tất cả'
                      ? state.foods
                      : state.foods.where((f) => 
                          f.category.trim().toLowerCase() == _selectedCategory.trim().toLowerCase()
                        ).toList();

                  if (filteredFoods.isEmpty) {
                    return _buildEmptyState();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: filteredFoods.length,
                    itemBuilder: (context, index) {
                      return FoodCard(
                        food: filteredFoods[index],
                        onAddToCart: () {
                          setState(() => _cartCount++);
                        },
                      );
                    },
                  );
                }

                if (state is FoodError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 40),
                          const SizedBox(height: 10),
                          const Text('Lỗi kết nối Firebase', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(state.message, 
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, color: Colors.grey)
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () => context.read<FoodBloc>().add(WatchFoodsEvent()),
                            child: const Text('Thử lại'),
                          )
                        ],
                      ),
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.no_food_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text('Chưa có món nào trong mục $_selectedCategory', 
            style: const TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF0D47A1)),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(child: Text('Thực đơn', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0D47A1)))),
          _buildCartBadge(),
        ],
      ),
    );
  }

  Widget _buildCartBadge() {
    return Stack(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.shopping_cart_outlined, size: 22, color: Color(0xFF0D47A1)),
        ),
        if (_cartCount > 0)
          Positioned(
            right: 0, top: 0,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(color: Color(0xFFFF5722), shape: BoxShape.circle),
              child: Text('$_cartCount', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }
}
