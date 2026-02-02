import '../../../domain/entities/subscription.dart';
import '../meal/meal_model.dart';

/// Subscription plan data model
class SubscriptionModel {
  final int id;
  final MealPlanTypeModel? mealPlanType;
  final SubscriptionPeriodModel? period;
  final MealCategoryModel? category;
  final dynamic price;
  final dynamic originalPrice;
  final int? freeMeals;
  final dynamic cashbackPercentage;
  final bool? isActive;

  const SubscriptionModel({
    required this.id,
    this.mealPlanType,
    this.period,
    this.category,
    this.price,
    this.originalPrice,
    this.freeMeals,
    this.cashbackPercentage,
    this.isActive,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as int,
      mealPlanType: json['meal_plan_type'] != null
          ? MealPlanTypeModel.fromJson(json['meal_plan_type'] as Map<String, dynamic>)
          : null,
      period: json['period'] != null
          ? SubscriptionPeriodModel.fromJson(json['period'] as Map<String, dynamic>)
          : null,
      category: json['category'] != null
          ? MealCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      price: json['price'],
      originalPrice: json['original_price'],
      freeMeals: json['free_meals'] as int?,
      cashbackPercentage: json['cashback_percentage'],
      isActive: json['is_active'] as bool?,
    );
  }

  Subscription toEntity() {
    return Subscription(
      id: id,
      mealPlanType: mealPlanType!.toEntity(),
      period: period!.toEntity(),
      category: category!.toEntity(),
      price: _num(price) ?? 0,
      originalPrice: _num(originalPrice),
      freeMeals: freeMeals ?? 0,
      cashbackPercentage: _num(cashbackPercentage)?.toDouble() ?? 0,
      isActive: isActive ?? true,
    );
  }

  double? _num(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}

/// Subscription period data model
class SubscriptionPeriodModel {
  final int id;
  final String name;
  final int days;
  final bool? isTrial;
  final String? description;

  const SubscriptionPeriodModel({
    required this.id,
    required this.name,
    required this.days,
    this.isTrial,
    this.description,
  });

  factory SubscriptionPeriodModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPeriodModel(
      id: json['id'] as int,
      name: json['name'] as String,
      days: json['days'] as int,
      isTrial: json['is_trial'] as bool?,
      description: json['description'] as String?,
    );
  }

  SubscriptionPeriod toEntity() {
    return SubscriptionPeriod(
      id: id,
      name: name,
      days: days,
      isTrial: isTrial ?? false,
      description: description,
    );
  }
}

/// Active subscription data model
class ActiveSubscriptionModel {
  final int id;
  final UserRefModel? customer;
  final MealPlanTypeModel? mealPlanType;
  final SubscriptionPeriodModel? period;
  final MealCategoryModel? category;
  final String? startDate;
  final String? endDate;
  final String? status;
  final dynamic price;
  final int? totalDeliveries;
  final int? deliveriesLeft;

  const ActiveSubscriptionModel({
    required this.id,
    this.customer,
    this.mealPlanType,
    this.period,
    this.category,
    this.startDate,
    this.endDate,
    this.status,
    this.price,
    this.totalDeliveries,
    this.deliveriesLeft,
  });

  factory ActiveSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return ActiveSubscriptionModel(
      id: json['id'] as int,
      customer: json['customer'] != null
          ? UserRefModel.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      mealPlanType: json['meal_plan_type'] != null
          ? MealPlanTypeModel.fromJson(json['meal_plan_type'] as Map<String, dynamic>)
          : null,
      period: json['period'] != null
          ? SubscriptionPeriodModel.fromJson(json['period'] as Map<String, dynamic>)
          : null,
      category: json['category'] != null
          ? MealCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      status: json['status'] as String?,
      price: json['price'],
      totalDeliveries: json['total_deliveries'] as int?,
      deliveriesLeft: json['deliveries_left'] as int?,
    );
  }

  ActiveSubscription toEntity() {
    return ActiveSubscription(
      id: id,
      customer: customer!.toEntity(),
      mealPlanType: mealPlanType!.toEntity(),
      period: period!.toEntity(),
      category: category!.toEntity(),
      startDate: DateTime.tryParse(startDate ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(endDate ?? '') ?? DateTime.now(),
      status: _parseStatus(status),
      price: (price is num) ? (price as num).toDouble() : 0,
      totalDeliveries: totalDeliveries ?? 0,
      deliveriesLeft: deliveriesLeft ?? 0,
    );
  }

  SubscriptionStatus _parseStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'active': return SubscriptionStatus.active;
      case 'paused': return SubscriptionStatus.paused;
      case 'cancelled': return SubscriptionStatus.cancelled;
      case 'expired': return SubscriptionStatus.expired;
      case 'pending': return SubscriptionStatus.pending;
      default: return SubscriptionStatus.pending;
    }
  }
}

/// User reference (id + name) for active subscription
class UserRefModel {
  final int id;
  final String name;

  const UserRefModel({required this.id, required this.name});

  factory UserRefModel.fromJson(Map<String, dynamic> json) {
    return UserRefModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }

  User toEntity() => User(id: id, name: name);
}
