import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/widgets/splash_page.dart';
import '../../features/food/domain/entities/food_entity.dart';
import '../../features/food/domain/entities/cart_entity.dart';
import '../../features/food/presentation/pages/food_page.dart';
import '../../features/food/presentation/pages/food_detail_page.dart';
import '../../features/food/presentation/pages/cart_page.dart';
import '../../features/orders/domain/entities/order_entity.dart';
import '../../features/orders/presentation/pages/checkout_page.dart';
import '../../features/orders/presentation/pages/order_success_page.dart';
import '../../features/orders/presentation/pages/order_history_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.food,
        name: 'food',
        builder: (context, state) => const FoodPage(),
      ),
      GoRoute(
        path: '/food_detail',
        name: 'food_detail',
        builder: (context, state) {
          final food = state.extra as FoodEntity;
          return FoodDetailPage(food: food);
        },
      ),
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (context, state) {
          final cart = state.extra as CartEntity;
          return CheckoutPage(cart: cart);
        },
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        name: 'order-success',
        builder: (context, state) => const OrderSuccessPage(),
      ),
      GoRoute(
        path: AppRoutes.orderHistory,
        name: 'order-history',
        builder: (context, state) => const OrderHistoryPage(),
      ),
      GoRoute(
        path: '/order-detail',
        name: 'order-detail',
        builder: (context, state) {
          final order = state.extra as OrderEntity;
          return OrderDetailPage(order: order);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Trang không tìm thấy')),
    ),
  );
}
