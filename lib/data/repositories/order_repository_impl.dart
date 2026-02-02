import 'package:dartz/dartz.dart' hide Order;

import '../../core/network/api_exception.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/remote/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource _remote;

  OrderRepositoryImpl(this._remote);

  @override
  Future<Either<ApiException, List<Order>>> getOrders() async {
    try {
      final models = await _remote.getOrders();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, Order>> getOrderById(String id) async {
    try {
      final model = await _remote.getOrderById(id);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<Order>>> getUpcomingOrders() async {
    final result = await getOrders();
    return result.fold(
      Left.new,
      (orders) => Right(
        orders.where((o) => !o.isCompleted && o.status != OrderStatus.cancelled).toList(),
      ),
    );
  }

  @override
  Future<Either<ApiException, List<Order>>> getPastOrders() async {
    final result = await getOrders();
    return result.fold(
      Left.new,
      (orders) => Right(
        orders.where((o) => o.isCompleted || o.status == OrderStatus.cancelled).toList(),
      ),
    );
  }

  @override
  Future<Either<ApiException, Order>> createOrder({
    required List<OrderItem> items,
    required int addressId,
    String? paymentMethod,
    String? specialInstructions,
  }) async {
    return Left(const ServerException('Create order API not implemented', 501));
  }

  @override
  Future<Either<ApiException, bool>> cancelOrder(String orderId) async {
    try {
      return Right(await _remote.cancelOrder(orderId));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, Order>> reorder(String orderId) async {
    return Left(const ServerException('Reorder API not implemented', 501));
  }

  @override
  Future<Either<ApiException, Order>> trackOrder(String orderId) async {
    return getOrderById(orderId);
  }
}
