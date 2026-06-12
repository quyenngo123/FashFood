import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/models/order_model.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRemoteDataSource orderRemoteDataSource;

  OrderBloc({required this.orderRemoteDataSource}) : super(OrderInitial()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<GetOrderHistoryEvent>(_onGetOrderHistory);
  }

  Future<void> _onPlaceOrder(PlaceOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orderModel = OrderModel(
        id: event.order.id,
        userId: event.order.userId,
        items: event.order.items,
        totalAmount: event.order.totalAmount,
        status: event.order.status,
        address: event.order.address,
        phone: event.order.phone,
        createdAt: event.order.createdAt,
      );
      await orderRemoteDataSource.createOrder(orderModel);
      emit(OrderPlacedSuccess());
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> _onGetOrderHistory(GetOrderHistoryEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await orderRemoteDataSource.getOrders(event.userId);
      emit(OrderSuccess(orders));
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }
}
