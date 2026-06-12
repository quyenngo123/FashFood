import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../bloc/food_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/food_card.dart';

enum SortType { recent, bestSeller, rating }

class CategoryDetailPage extends StatefulWidget {
  final String categoryName;
  final String categoryImage;

  const CategoryDetailPage({
    super.key,
    required this.categoryName,
    required this.categoryImage,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SortType _sortType = SortType.bestSeller;

  final List<_TabItem> _tabs = const [
    _TabItem(label: 'Gần đây', icon: Icons.access_time_rounded, sort: SortType.recent),
    _TabItem(label: 'Bán chạy', icon: Icons.local_fire_department_rounded, sort: SortType.bestSeller),
    _TabItem(label: 'Đánh giá', icon: Icons.star_rounded, sort: SortType.rating),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _sortType = _tabs[_tabController.index].sort);
      }
    });
    
    context.read<FoodBloc>().add(WatchFoodsEvent());
    
    // Sử dụng AuthBloc để lấy userId ổn định hơn
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<CartBloc>().add(WatchCartEvent(authState.user.uid));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<FoodEntity> _getSortedFoods(List<FoodEntity> allFoods) {
    final foods = widget.categoryName == 'Tất cả' 
        ? allFoods 
        : allFoods.where((f) => f.category.trim().toLowerCase() == widget.categoryName.trim().toLowerCase()).toList();

    switch (_sortType) {
      case SortType.bestSeller:
        return [...foods]..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case SortType.rating:
        return [...foods]..sort((a, b) => b.rating.compareTo(a.rating));
      case SortType.recent:
        return foods.reversed.toList();
    }
  }

  void _handleAddToCart(FoodEntity food) {
    final authState = context.read<AuthBloc>().state;
    String? userId;

    if (authState is AuthSuccess) {
      userId = authState.user.uid;
    }

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để mua hàng'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final cartItem = CartItemEntity(
      productId: food.id,
      name: food.name,
      image: food.imageUrl,
      price: food.price,
      quantity: 1,
    );

    context.read<CartBloc>().add(AddToCartEvent(
      userId: userId,
      item: cartItem,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm ${food.name} vào giỏ hàng'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<FoodBloc, FoodState>(
              builder: (context, state) {
                if (state is FoodLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is FoodLoaded) {
                  final sortedFoods = _getSortedFoods(state.foods);
                  if (sortedFoods.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildFoodGrid(sortedFoods);
                }
                if (state is FoodError) {
                  return Center(child: Text('Lỗi: ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.no_food_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          Text('Chưa có món nào trong danh mục này', style: TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildFoodGrid(List<FoodEntity> foods) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.65,
      ),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        return FoodCard(
          food: foods[index],
          onAddToCart: () => _handleAddToCart(foods[index]),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(widget.categoryName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5))),
          _buildCartBadge(),
        ],
      ),
    );
  }

  Widget _buildCartBadge() {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.cart),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          int count = 0;
          if (state is CartLoaded && state.cart != null) {
            count = state.cart!.totalItems;
          }
          
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.shopping_cart_outlined, size: 22, color: Colors.white),
              ),
              if (count > 0)
                Positioned(
                  right: -4, top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFFFF5722), shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Center(
                      child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 3))]),
      child: TabBar(
        controller: _tabController,
        padding: const EdgeInsets.all(4),
        indicator: BoxDecoration(color: const Color(0xFF0D47A1), borderRadius: BorderRadius.circular(12)),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF9E9E9E),
        dividerColor: Colors.transparent,
        tabs: _tabs.map((tab) => Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(tab.icon, size: 16), const SizedBox(width: 6), Text(tab.label)]))).toList(),
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final SortType sort;
  const _TabItem({required this.label, required this.icon, required this.sort});
}
