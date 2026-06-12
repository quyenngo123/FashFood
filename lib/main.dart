import 'package:fash_food/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fash_food/features/food/presentation/bloc/food_bloc.dart';
import 'package:fash_food/features/food/presentation/bloc/cart_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fash_food/config/routes/app_router.dart';
import 'package:fash_food/firebase_options.dart';
import 'package:fash_food/injection_container.dart' as di;
import 'package:fash_food/injection_container.dart';

import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/orders/presentation/bloc/order_bloc.dart'; // Đã đổi từ food sang orders

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(const CheckAuthRequested())),
        BlocProvider(create: (_) => sl<FoodBloc>()..add(WatchFoodsEvent())),
        BlocProvider(create: (_) => sl<CartBloc>()),
        BlocProvider(create: (_) => sl<OrderBloc>()),
      ],
      child: MaterialApp.router(
        title: 'FastFood',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
