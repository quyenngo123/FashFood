import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrderEvent extends OrderEvent {
  final OrderEntity order;

  const PlaceOrderEvent(this.order);

  @override
  List<Object> get props => [order];
}

class GetOrderHistoryEvent extends OrderEvent {
  final String userId;

  const GetOrderHistoryEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
