import 'package:dartz/dartz.dart';
import '../../core/network/api_exception.dart';
import '../entities/subscription.dart';
import '../entities/meal.dart';

/// Repository contract for Subscriptions
abstract class SubscriptionRepository {
  /// Get all subscription plans
  Future<Either<ApiException, List<Subscription>>> getSubscriptionPlans();

  /// Get subscription plan by ID
  Future<Either<ApiException, Subscription>> getSubscriptionById(int id);

  /// Get available meal plan types
  Future<Either<ApiException, List<MealPlanType>>> getMealPlanTypes();

  /// Get subscription periods
  Future<Either<ApiException, List<SubscriptionPeriod>>> getSubscriptionPeriods();

  /// Get user's active subscriptions
  Future<Either<ApiException, List<ActiveSubscription>>> getActiveSubscriptions();

  /// Subscribe to a plan
  Future<Either<ApiException, ActiveSubscription>> subscribeToplan({
    required int planId,
    required int addressId,
    String? paymentMethod,
  });

  /// Pause subscription
  Future<Either<ApiException, ActiveSubscription>> pauseSubscription(int subscriptionId);

  /// Resume subscription
  Future<Either<ApiException, ActiveSubscription>> resumeSubscription(int subscriptionId);

  /// Cancel subscription
  Future<Either<ApiException, bool>> cancelSubscription(int subscriptionId);
}
