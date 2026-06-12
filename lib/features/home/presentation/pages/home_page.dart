import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../food/presentation/bloc/cart_bloc.dart';
import '../widgets/home_header.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/category_grid.dart';
import '../widgets/combo_list.dart';
import '../widgets/home_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Khởi tạo giỏ hàng khi vào trang chủ
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<CartBloc>().add(WatchCartEvent(user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        String displayName = 'Bạn';
        if (authState is AuthSuccess) {
          displayName = authState.user.name ?? authState.user.email.split('@').first;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 190,
                toolbarHeight: 0,
                backgroundColor: AppColors.primaryDark,
                elevation: 0,
                automaticallyImplyLeading: false,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: HomeHeader(userName: displayName, showSearchBar: false),
                ),
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(80),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: HomeSearchBar(),
                  ),
                ),
              ),
              
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const PromoCarousel(),
                    _buildSectionTitle('Danh mục'),
                    CategoryGrid(),
                    _buildSectionTitle('Combo đặc sắc 🔥'),
                    const ComboList(), // Xóa callback cũ vì đã dùng Bloc
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              int totalItems = 0;
              if (cartState is CartLoaded && cartState.cart != null) {
                totalItems = cartState.cart!.totalItems;
              }

              return HomeBottomNav(
                currentIndex: _selectedIndex,
                cartCount: totalItems,
                onTap: (index) {
                  if (index == 2) {
                    // Click vào giỏ hàng ở Bottom Nav -> Chuyển sang CartPage
                    context.push(AppRoutes.cart);
                  } else {
                    setState(() => _selectedIndex = index);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 25, 24, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263238))),
          const Text('Xem tất cả',
              style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
