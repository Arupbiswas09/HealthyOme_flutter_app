import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../models/subscription/subscription_model.dart';

abstract class SubscriptionRemoteDatasource {
  Future<List<SubscriptionModel>> getSubscriptionPlans();
  Future<SubscriptionModel> getSubscriptionById(int id);
  Future<List<SubscriptionPeriodModel>> getPeriods();
  Future<List<ActiveSubscriptionModel>> getActiveSubscriptions();
}

class SubscriptionRemoteDatasourceImpl implements SubscriptionRemoteDatasource {
  final ApiClient _api;

  SubscriptionRemoteDatasourceImpl(this._api);

  @override
  Future<List<SubscriptionModel>> getSubscriptionPlans() async {
    try {
      final res = await _api.get<Map<String, dynamic>>(ApiConstants.subscriptionPlans);
      return _parseList(res.data, (m) => SubscriptionModel.fromJson(m));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<SubscriptionModel> getSubscriptionById(int id) async {
    try {
      final res = await _api.get<Map<String, dynamic>>('${ApiConstants.subscriptionPlans}$id/');
      final data = res.data;
      if (data == null) throw const ParseException('Empty response');
      return SubscriptionModel.fromJson(Map<String, dynamic>.from(data as Map));
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<SubscriptionPeriodModel>> getPeriods() async {
    try {
      final res = await _api.get<Map<String, dynamic>>(ApiConstants.mealPlans);
      final data = res.data;
      if (data is! Map<String, dynamic>) return [];
      final results = data['results'] ?? data['periods'];
      if (results is! List) return [];
      return results
          .map((e) => SubscriptionPeriodModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e is ApiException) rethrow;
      return [];
    }
  }

  @override
  Future<List<ActiveSubscriptionModel>> getActiveSubscriptions() async {
    try {
      final res = await _api.get<Map<String, dynamic>>(ApiConstants.activeSubscriptions);
      return _parseList(res.data, (m) => ActiveSubscriptionModel.fromJson(m));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  List<T> _parseList<T>(dynamic data, T Function(Map<String, dynamic>) fromJson) {
    if (data == null) return [];
    if (data is List) {
      return data.map((e) => fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) {
        return results.map((e) => fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
    }
    return [];
  }
}
