import 'package:dartz/dartz.dart';

import '../../core/network/api_exception.dart';
import '../../domain/entities/meal.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/remote/subscription_remote_datasource.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDatasource _remote;

  SubscriptionRepositoryImpl(this._remote);

  @override
  Future<Either<ApiException, List<Subscription>>> getSubscriptionPlans() async {
    try {
      final models = await _remote.getSubscriptionPlans();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, Subscription>> getSubscriptionById(int id) async {
    try {
      final model = await _remote.getSubscriptionById(id);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<MealPlanType>>> getMealPlanTypes() async {
    final result = await getSubscriptionPlans();
    return result.fold(
      Left.new,
      (plans) => Right(
        plans.map((p) => p.mealPlanType).toSet().toList(),
      ),
    );
  }

  @override
  Future<Either<ApiException, List<SubscriptionPeriod>>> getSubscriptionPeriods() async {
    try {
      final models = await _remote.getPeriods();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<ActiveSubscription>>> getActiveSubscriptions() async {
    try {
      final models = await _remote.getActiveSubscriptions();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, ActiveSubscription>> subscribeToplan({
    required int planId,
    required int addressId,
    String? paymentMethod,
  }) async {
    try {
      await _remote.getSubscriptionById(planId);
      return const Left(ServerException('Subscribe API not implemented', 501));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, ActiveSubscription>> pauseSubscription(int subscriptionId) async {
    return const Left(ServerException('Pause API not implemented', 501));
  }

  @override
  Future<Either<ApiException, ActiveSubscription>> resumeSubscription(int subscriptionId) async {
    return const Left(ServerException('Resume API not implemented', 501));
  }

  @override
  Future<Either<ApiException, bool>> cancelSubscription(int subscriptionId) async {
    return const Left(ServerException('Cancel subscription API not implemented', 501));
  }
}
