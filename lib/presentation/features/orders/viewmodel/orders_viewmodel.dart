import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../domain/entities/order.dart';
import '../../../../domain/usecases/orders/get_orders.dart';

class OrdersState {
  final AsyncValue<List<Order>> orders;

  const OrdersState({
    this.orders = const AsyncValue.loading(),
  });

  OrdersState copyWith({AsyncValue<List<Order>>? orders}) {
    return OrdersState(orders: orders ?? this.orders);
  }

  List<Order> get upcoming =>
      orders.when(
        data: (list) => list.where((o) => !o.isCompleted && o.status != OrderStatus.cancelled).toList(),
        loading: () => [],
        error: (_, __) => [],
      );

  List<Order> get past =>
      orders.when(
        data: (list) => list.where((o) => o.isCompleted || o.status == OrderStatus.cancelled).toList(),
        loading: () => [],
        error: (_, __) => [],
      );
}

class OrdersViewModel extends StateNotifier<OrdersState> {
  final GetOrders _getOrders;

  OrdersViewModel(this._getOrders) : super(const OrdersState());

  Future<void> loadOrders() async {
    state = state.copyWith(orders: const AsyncValue.loading());
    final result = await _getOrders();
    result.fold(
      (e) => state = state.copyWith(orders: AsyncValue.error(e, StackTrace.current)),
      (list) => state = state.copyWith(orders: AsyncValue.data(list)),
    );
  }
}

final ordersViewModelProvider =
    StateNotifierProvider<OrdersViewModel, OrdersState>((ref) {
  return OrdersViewModel(ref.read(getOrdersProvider));
});
