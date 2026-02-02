import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../models/reward/reward_model.dart';

abstract class RewardsRemoteDatasource {
  Future<List<RewardModel>> getRewards();
}

class RewardsRemoteDatasourceImpl implements RewardsRemoteDatasource {
  final ApiClient _api;

  RewardsRemoteDatasourceImpl(this._api);

  @override
  Future<List<RewardModel>> getRewards() async {
    try {
      final res = await _api.get<Map<String, dynamic>>(ApiConstants.rewards);
      return _parseList(res.data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  List<RewardModel> _parseList(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data.map((e) => RewardModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) {
        return results.map((e) => RewardModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
    }
    return [];
  }
}
