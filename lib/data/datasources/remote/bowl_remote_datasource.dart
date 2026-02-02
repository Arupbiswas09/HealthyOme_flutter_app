import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../models/bowl/bowl_model.dart';

abstract class BowlRemoteDatasource {
  Future<List<BowlBaseModel>> getBowlBases();
  Future<List<BowlIngredientModel>> getBowlIngredients();
  Future<List<BowlIngredientModel>> getBowlIngredientsByType(String type);
}

class BowlRemoteDatasourceImpl implements BowlRemoteDatasource {
  final ApiClient _api;

  BowlRemoteDatasourceImpl(this._api);

  @override
  Future<List<BowlBaseModel>> getBowlBases() async {
    try {
      final res = await _api.get<Map<String, dynamic>>(ApiConstants.bowlBases);
      return _parseList(res.data, BowlBaseModel.fromJson);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<BowlIngredientModel>> getBowlIngredients() async {
    try {
      final res = await _api.get<Map<String, dynamic>>(ApiConstants.bowlIngredients);
      return _parseList(res.data, BowlIngredientModel.fromJson);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<BowlIngredientModel>> getBowlIngredientsByType(String type) async {
    try {
      final res = await _api.get<Map<String, dynamic>>(
        ApiConstants.bowlIngredientsByType(type),
      );
      return _parseList(res.data, BowlIngredientModel.fromJson);
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
