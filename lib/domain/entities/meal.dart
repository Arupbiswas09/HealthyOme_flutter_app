import 'package:equatable/equatable.dart';

/// Meal entity - Business logic representation
class Meal extends Equatable {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final MealPlanType? mealPlanType;
  final MealCategory? category;
  final MealTime? mealTime;
  final double price;
  final double? originalPrice;
  final int? calories;
  final double? protein;
  final double? carbs;
  final double? fats;
  final double? fiber;
  final double? rating;
  final String? imageUrl;

  const Meal({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
    this.mealPlanType,
    this.category,
    this.mealTime,
    required this.price,
    this.originalPrice,
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    this.fiber,
    this.rating,
    this.imageUrl,
  });

  /// Check if meal is vegetarian
  bool get isVeg => category?.name.toLowerCase() == 'veg';

  /// Check if meal is non-vegetarian
  bool get isNonVeg => category?.name.toLowerCase() == 'non-veg';

  /// Check if meal contains egg
  bool get isEgg => category?.name.toLowerCase() == 'egg';

  /// Check if meal has discount
  bool get hasDiscount =>
      originalPrice != null && originalPrice! > price;

  /// Get discount percentage
  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        isActive,
        mealPlanType,
        category,
        mealTime,
        price,
        originalPrice,
        calories,
        protein,
        carbs,
        fats,
        fiber,
        rating,
        imageUrl,
      ];
}

/// Meal Plan Type entity
class MealPlanType extends Equatable {
  final int id;
  final String name;
  final String? description;
  final bool isActive;

  const MealPlanType({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, description, isActive];
}

/// Meal Category entity
class MealCategory extends Equatable {
  final int id;
  final String name;

  const MealCategory({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

/// Meal Time entity
class MealTime extends Equatable {
  final int id;
  final String name;

  const MealTime({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
