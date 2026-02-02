import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../models/meal/meal_model.dart';

/// Remote data source for meals - talks to API only.
/// Throws [ApiException] on failure.
abstract class MealsRemoteDatasource {
  Future<List<MealModel>> getMeals({int? page, int? pageSize});
  Future<List<MealModel>> getFeaturedMeals();
  Future<MealModel> getMealById(int id);
}

class MealsRemoteDatasourceImpl implements MealsRemoteDatasource {
  final ApiClient _api;

  MealsRemoteDatasourceImpl(this._api);

  @override
  Future<List<MealModel>> getMeals({int? page, int? pageSize}) async {
    try {
      final query = <String, dynamic>{};
      if (page != null) query['page'] = page;
      if (pageSize != null) query['page_size'] = pageSize;
      final res = await _api.get<Map<String, dynamic>>(
        ApiConstants.meals,
        queryParameters: query.isEmpty ? null : query,
      );
      return _parseMealList(res.data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<MealModel>> getFeaturedMeals() async {
    try {
      final res = await _api.get<Map<String, dynamic>>(ApiConstants.mealsFeatured);
      return _parseMealList(res.data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<MealModel> getMealById(int id) async {
    try {
      final res = await _api.get<Map<String, dynamic>>(ApiConstants.mealById(id));
      final data = res.data;
      if (data == null) throw const ParseException('Empty response');
      return MealModel.fromJson(Map<String, dynamic>.from(data as Map));
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  List<MealModel> _parseMealList(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data
          .map((e) => MealModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) {
        return results
            .map((e) => MealModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }
}
