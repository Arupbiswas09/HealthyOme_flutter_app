import 'package:dartz/dartz.dart' hide Order;
import '../../core/network/api_exception.dart';
import '../entities/order.dart';

/// Repository contract for Orders
abstract class OrderRepository {
  /// Get all orders
  Future<Either<ApiException, List<Order>>> getOrders();

  /// Get order by ID
  Future<Either<ApiException, Order>> getOrderById(String id);

  /// Get upcoming orders
  Future<Either<ApiException, List<Order>>> getUpcomingOrders();

  /// Get past orders
  Future<Either<ApiException, List<Order>>> getPastOrders();

  /// Create new order
  Future<Either<ApiException, Order>> createOrder({
    required List<OrderItem> items,
    required int addressId,
    String? paymentMethod,
    String? specialInstructions,
  });

  /// Cancel order
  Future<Either<ApiException, bool>> cancelOrder(String orderId);

  /// Reorder
  Future<Either<ApiException, Order>> reorder(String orderId);

  /// Track order
  Future<Either<ApiException, Order>> trackOrder(String orderId);
}
