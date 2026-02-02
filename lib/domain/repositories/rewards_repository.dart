import 'package:dartz/dartz.dart';

import '../../core/network/api_exception.dart';
import '../entities/reward.dart';

/// Repository contract for Rewards
abstract class RewardsRepository {
  Future<Either<ApiException, List<Reward>>> getRewards();
}
