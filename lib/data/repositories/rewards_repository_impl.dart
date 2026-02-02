import 'package:dartz/dartz.dart';

import '../../core/network/api_exception.dart';
import '../../domain/entities/reward.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../datasources/remote/rewards_remote_datasource.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsRemoteDatasource _remote;

  RewardsRepositoryImpl(this._remote);

  @override
  Future<Either<ApiException, List<Reward>>> getRewards() async {
    try {
      final models = await _remote.getRewards();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
