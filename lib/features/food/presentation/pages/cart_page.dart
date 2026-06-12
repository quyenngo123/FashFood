import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../config/routes/app_routes.dart';
import '../bloc/cart_bloc.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/cart_entity.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Giỏ hàng')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Vui lòng đăng nhập để xem giỏ hàng'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('ĐĂNG NHẬP'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Giỏ hàng', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            context.read<CartBloc>().add(WatchCartEvent(userId));
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoading && state is! CartLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoaded) {
            final cart = state.cart;
            if (cart == null || cart.items.isEmpty) {
              return _buildEmptyCart(context);
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(context, cart, cart.items[index]);
                    },
                  ),
                ),
                _buildSummary(context, cart),
              ],
            );
          }

          if (state is CartError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Giỏ hàng của bạn đang trống', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('MUA SẮM NGAY', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartEntity cart, CartItemEntity item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildItemImage(item.image),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('${_formatPrice(item.price)}đ', style: TextStyle(color: AppColors.price, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuantityPicker(context, cart, item),
                    IconButton(
                      onPressed: () => _removeItem(context, cart, item.productId),
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.cover);
    }
    return Image.network(
      imagePath,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.fastfood)),
    );
  }

  Widget _buildQuantityPicker(BuildContext context, CartEntity cart, CartItemEntity item) {
    return Row(
      children: [
        _qtyBtn(Icons.remove, () => _updateQty(context, cart, item, item.quantity - 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        _qtyBtn(Icons.add, () => _updateQty(context, cart, item, item.quantity + 1)),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  void _updateQty(BuildContext context, CartEntity cart, CartItemEntity item, int newQty) {
    if (newQty < 1) return;
    final items = List<CartItemEntity>.from(cart.items);
    final index = items.indexWhere((i) => i.productId == item.productId);
    items[index] = item.copyWith(quantity: newQty);
    
    context.read<CartBloc>().add(UpdateCartEvent(CartEntity(
      userId: cart.userId,
      items: items,
      updatedAt: DateTime.now(),
    )));
  }

  void _removeItem(BuildContext context, CartEntity cart, String productId) {
    final items = List<CartItemEntity>.from(cart.items)..removeWhere((i) => i.productId == productId);
    context.read<CartBloc>().add(UpdateCartEvent(CartEntity(
      userId: cart.userId,
      items: items,
      updatedAt: DateTime.now(),
    )));
  }

  Widget _buildSummary(BuildContext context, CartEntity cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng cộng:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text('${_formatPrice(cart.totalAmount)}đ', style: AppTextStyles.heading2.copyWith(color: AppColors.price)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push(AppRoutes.checkout, extra: cart);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('THANH TOÁN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
