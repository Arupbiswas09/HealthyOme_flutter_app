import 'package:dartz/dartz.dart';

import '../../../core/network/api_exception.dart';
import '../../entities/subscription.dart';
import '../../repositories/subscription_repository.dart';

class GetSubscriptionPeriods {
  final SubscriptionRepository _repository;

  GetSubscriptionPeriods(this._repository);

  Future<Either<ApiException, List<SubscriptionPeriod>>> call() =>
      _repository.getSubscriptionPeriods();
}
