import 'package:dartz/dartz.dart';

import '../../../core/network/api_exception.dart';
import '../../entities/reward.dart';
import '../../repositories/rewards_repository.dart';

class GetRewards {
  final RewardsRepository _repository;

  GetRewards(this._repository);

  Future<Either<ApiException, List<Reward>>> call() =>
      _repository.getRewards();
}
