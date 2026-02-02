import 'package:dartz/dartz.dart';

import '../../../core/network/api_exception.dart';
import '../../entities/subscription.dart';
import '../../repositories/subscription_repository.dart';

class GetSubscriptionPlans {
  final SubscriptionRepository _repository;

  GetSubscriptionPlans(this._repository);

  Future<Either<ApiException, List<Subscription>>> call() =>
      _repository.getSubscriptionPlans();
}
