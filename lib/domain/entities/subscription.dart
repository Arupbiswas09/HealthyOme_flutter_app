import 'package:equatable/equatable.dart';
import 'meal.dart';

/// Subscription entity - Business logic representation
class Subscription extends Equatable {
  final int id;
  final MealPlanType mealPlanType;
  final SubscriptionPeriod period;
  final MealCategory category;
  final double price;
  final double? originalPrice;
  final int freeMeals;
  final double cashbackPercentage;
  final bool isActive;

  const Subscription({
    required this.id,
    required this.mealPlanType,
    required this.period,
    required this.category,
    required this.price,
    this.originalPrice,
    this.freeMeals = 0,
    this.cashbackPercentage = 0,
    this.isActive = true,
  });

  /// Check if has discount
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  /// Get discount percentage
  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  /// Get price per meal
  double get pricePerMeal => price / period.days;

  @override
  List<Object?> get props => [
        id,
        mealPlanType,
        period,
        category,
        price,
        originalPrice,
        freeMeals,
        cashbackPercentage,
        isActive,
      ];
}

/// Subscription Period entity
class SubscriptionPeriod extends Equatable {
  final int id;
  final String name;
  final int days;
  final bool isTrial;
  final String? description;

  const SubscriptionPeriod({
    required this.id,
    required this.name,
    required this.days,
    this.isTrial = false,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, days, isTrial, description];
}

/// Active Subscription entity
class ActiveSubscription extends Equatable {
  final int id;
  final User customer;
  final MealPlanType mealPlanType;
  final SubscriptionPeriod period;
  final MealCategory category;
  final DateTime startDate;
  final DateTime endDate;
  final SubscriptionStatus status;
  final double price;
  final int totalDeliveries;
  final int deliveriesLeft;

  const ActiveSubscription({
    required this.id,
    required this.customer,
    required this.mealPlanType,
    required this.period,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.price,
    required this.totalDeliveries,
    required this.deliveriesLeft,
  });

  /// Get completion percentage
  double get completionPercentage {
    if (totalDeliveries == 0) return 0;
    return ((totalDeliveries - deliveriesLeft) / totalDeliveries) * 100;
  }

  /// Get days remaining
  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  /// Check if subscription is active
  bool get isActive => status == SubscriptionStatus.active;

  @override
  List<Object?> get props => [
        id,
        customer,
        mealPlanType,
        period,
        category,
        startDate,
        endDate,
        status,
        price,
        totalDeliveries,
        deliveriesLeft,
      ];
}

/// User simple entity for subscription
class User extends Equatable {
  final int id;
  final String name;

  const User({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

/// Subscription status enum
enum SubscriptionStatus {
  active,
  paused,
  cancelled,
  expired,
  pending,
}
