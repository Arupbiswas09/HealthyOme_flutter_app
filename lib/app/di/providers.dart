import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/secure_storage.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/bowl_remote_datasource.dart';
import '../../data/datasources/remote/meals_remote_datasource.dart';
import '../../data/datasources/remote/order_remote_datasource.dart';
import '../../data/datasources/remote/rewards_remote_datasource.dart';
import '../../data/datasources/remote/subscription_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/bowl_repository_impl.dart';
import '../../data/repositories/meals_repository_impl.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/repositories/rewards_repository_impl.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/bowl_repository.dart';
import '../../domain/repositories/meals_repository.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/usecases/auth/get_current_user.dart';
import '../../domain/usecases/auth/verify_otp.dart';
import '../../domain/usecases/bowl/get_bowl_bases.dart';
import '../../domain/usecases/bowl/get_bowl_ingredients.dart';
import '../../domain/usecases/meals/get_featured_meals.dart';
import '../../domain/usecases/meals/get_meal_by_id.dart';
import '../../domain/usecases/meals/get_meals.dart';
import '../../domain/usecases/orders/get_orders.dart';
import '../../domain/usecases/rewards/get_rewards.dart';
import '../../domain/usecases/subscription/get_subscription_periods.dart';
import '../../domain/usecases/subscription/get_subscription_plans.dart';

// ─── Core ─────────────────────────────────────────────────────────────────
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

// ─── Data sources ─────────────────────────────────────────────────────────
final mealsRemoteDatasourceProvider = Provider<MealsRemoteDatasource>(
  (ref) => MealsRemoteDatasourceImpl(ref.read(apiClientProvider)),
);
final subscriptionRemoteDatasourceProvider = Provider<SubscriptionRemoteDatasource>(
  (ref) => SubscriptionRemoteDatasourceImpl(ref.read(apiClientProvider)),
);
final bowlRemoteDatasourceProvider = Provider<BowlRemoteDatasource>(
  (ref) => BowlRemoteDatasourceImpl(ref.read(apiClientProvider)),
);
final orderRemoteDatasourceProvider = Provider<OrderRemoteDatasource>(
  (ref) => OrderRemoteDatasourceImpl(ref.read(apiClientProvider)),
);
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>(
  (ref) => AuthRemoteDatasourceImpl(ref.read(apiClientProvider)),
);
final rewardsRemoteDatasourceProvider = Provider<RewardsRemoteDatasource>(
  (ref) => RewardsRemoteDatasourceImpl(ref.read(apiClientProvider)),
);

// ─── Repositories ─────────────────────────────────────────────────────────
final mealsRepositoryProvider = Provider<MealsRepository>(
  (ref) => MealsRepositoryImpl(ref.read(mealsRemoteDatasourceProvider)),
);
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepositoryImpl(ref.read(subscriptionRemoteDatasourceProvider)),
);
final bowlRepositoryProvider = Provider<BowlRepository>(
  (ref) => BowlRepositoryImpl(ref.read(bowlRemoteDatasourceProvider)),
);
final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepositoryImpl(ref.read(orderRemoteDatasourceProvider)),
);
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.read(authRemoteDatasourceProvider),
    ref.read(secureStorageProvider),
  ),
);
final rewardsRepositoryProvider = Provider<RewardsRepository>(
  (ref) => RewardsRepositoryImpl(ref.read(rewardsRemoteDatasourceProvider)),
);

// ─── Use cases ────────────────────────────────────────────────────────────
final getMealsProvider = Provider<GetMeals>((ref) => GetMeals(ref.read(mealsRepositoryProvider)));
final getFeaturedMealsProvider = Provider<GetFeaturedMeals>((ref) => GetFeaturedMeals(ref.read(mealsRepositoryProvider)));
final getMealByIdProvider = Provider<GetMealById>((ref) => GetMealById(ref.read(mealsRepositoryProvider)));
final getSubscriptionPlansProvider = Provider<GetSubscriptionPlans>((ref) => GetSubscriptionPlans(ref.read(subscriptionRepositoryProvider)));
final getSubscriptionPeriodsProvider = Provider<GetSubscriptionPeriods>((ref) => GetSubscriptionPeriods(ref.read(subscriptionRepositoryProvider)));
final getBowlBasesProvider = Provider<GetBowlBases>((ref) => GetBowlBases(ref.read(bowlRepositoryProvider)));
final getBowlIngredientsProvider = Provider<GetBowlIngredients>((ref) => GetBowlIngredients(ref.read(bowlRepositoryProvider)));
final getOrdersProvider = Provider<GetOrders>((ref) => GetOrders(ref.read(orderRepositoryProvider)));
final getCurrentUserProvider = Provider<GetCurrentUser>((ref) => GetCurrentUser(ref.read(authRepositoryProvider)));
final verifyOtpProvider = Provider<VerifyOtp>((ref) => VerifyOtp(ref.read(authRepositoryProvider)));
final getRewardsProvider = Provider<GetRewards>((ref) => GetRewards(ref.read(rewardsRepositoryProvider)));
