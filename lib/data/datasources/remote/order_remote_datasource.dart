import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../models/order/order_model.dart';

abstract class OrderRemoteDatasource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrderById(String id);
  Future<bool> cancelOrder(String id);
}

class OrderRemoteDatasourceImpl implements OrderRemoteDatasource {
  final ApiClient _api;

  OrderRemoteDatasourceImpl(this._api);

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final res = await _api.get<Map<String, dynamic>>(ApiConstants.orders);
      return _parseList(res.data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    try {
      final res = await _api.get<Map<String, dynamic>>(ApiConstants.orderByIdStr(id));
      final data = res.data;
      if (data == null) throw const ParseException('Empty response');
      return OrderModel.fromJson(Map<String, dynamic>.from(data as Map));
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> cancelOrder(String id) async {
    try {
      await _api.post<dynamic>(ApiConstants.cancelOrderStr(id));
      return true;
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  List<OrderModel> _parseList(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data.map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) {
        return results.map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
    }
    return [];
  }
}
