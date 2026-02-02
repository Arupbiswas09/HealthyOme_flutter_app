import 'package:dartz/dartz.dart' hide Order;

import '../../../core/network/api_exception.dart';
import '../../entities/order.dart';
import '../../repositories/order_repository.dart';

class GetOrders {
  final OrderRepository _repository;

  GetOrders(this._repository);

  Future<Either<ApiException, List<Order>>> call() => _repository.getOrders();
}
