import 'package:equatable/equatable.dart';

/// Bowl entity - for custom bowl builder
class Bowl extends Equatable {
  final BowlBase base;
  final List<BowlIngredient> ingredients;
  final double totalPrice;

  const Bowl({
    required this.base,
    required this.ingredients,
    required this.totalPrice,
  });

  /// Create empty bowl
  factory Bowl.empty(BowlBase base) {
    return Bowl(
      base: base,
      ingredients: const [],
      totalPrice: base.price,
    );
  }

  /// Add ingredient
  Bowl addIngredient(BowlIngredient ingredient) {
    final newIngredients = [...ingredients, ingredient];
    return Bowl(
      base: base,
      ingredients: newIngredients,
      totalPrice: _calculatePrice(base, newIngredients),
    );
  }

  /// Remove ingredient
  Bowl removeIngredient(BowlIngredient ingredient) {
    final newIngredients = ingredients.where((i) => i.id != ingredient.id).toList();
    return Bowl(
      base: base,
      ingredients: newIngredients,
      totalPrice: _calculatePrice(base, newIngredients),
    );
  }

  /// Change base
  Bowl changeBase(BowlBase newBase) {
    return Bowl(
      base: newBase,
      ingredients: ingredients,
      totalPrice: _calculatePrice(newBase, ingredients),
    );
  }

  double _calculatePrice(BowlBase base, List<BowlIngredient> ingredients) {
    double total = base.price;
    for (final ingredient in ingredients) {
      total += ingredient.price;
    }
    return total;
  }

  /// Get ingredients by type
  List<BowlIngredient> getIngredientsByType(IngredientType type) {
    return ingredients.where((i) => i.type == type).toList();
  }

  /// Get total calories
  int get totalCalories {
    int calories = 0;
    for (final ingredient in ingredients) {
      calories += ingredient.calories ?? 0;
    }
    return calories;
  }

  @override
  List<Object?> get props => [base, ingredients, totalPrice];
}

/// Bowl Base entity
class BowlBase extends Equatable {
  final int id;
  final String name;
  final double price;
  final bool isActive;

  const BowlBase({
    required this.id,
    required this.name,
    required this.price,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, price, isActive];
}

/// Bowl Ingredient entity
class BowlIngredient extends Equatable {
  final int id;
  final String name;
  final IngredientType type;
  final double price;
  final IconType iconType;
  final bool isActive;
  final int? calories;
  final String? imageUrl;

  const BowlIngredient({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.iconType,
    this.isActive = true,
    this.calories,
    this.imageUrl,
  });

  /// Check if vegetarian
  bool get isVeg => iconType == IconType.veg;

  /// Check if non-vegetarian
  bool get isNonVeg => iconType == IconType.nonVeg;

  /// Check if egg
  bool get isEgg => iconType == IconType.egg;

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        price,
        iconType,
        isActive,
        calories,
        imageUrl,
      ];
}

/// Ingredient Type enum
enum IngredientType {
  base,
  veggie,
  protein,
  dressing,
  seedsNuts,
  gravy,
}

/// Extension to convert string to IngredientType
extension IngredientTypeExtension on IngredientType {
  String get apiValue {
    switch (this) {
      case IngredientType.base:
        return 'base';
      case IngredientType.veggie:
        return 'veggie';
      case IngredientType.protein:
        return 'protein';
      case IngredientType.dressing:
        return 'dressing';
      case IngredientType.seedsNuts:
        return 'seeds_nuts';
      case IngredientType.gravy:
        return 'gravy';
    }
  }

  static IngredientType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'base':
        return IngredientType.base;
      case 'veggie':
        return IngredientType.veggie;
      case 'protein':
        return IngredientType.protein;
      case 'dressing':
        return IngredientType.dressing;
      case 'seeds_nuts':
        return IngredientType.seedsNuts;
      case 'gravy':
        return IngredientType.gravy;
      default:
        return IngredientType.veggie;
    }
  }
}

/// Icon Type enum
enum IconType {
  veg,
  nonVeg,
  egg,
}

/// Extension to convert string to IconType
extension IconTypeExtension on IconType {
  String get apiValue {
    switch (this) {
      case IconType.veg:
        return 'veg';
      case IconType.nonVeg:
        return 'non_veg';
      case IconType.egg:
        return 'egg';
    }
  }

  static IconType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'veg':
        return IconType.veg;
      case 'non_veg':
        return IconType.nonVeg;
      case 'egg':
        return IconType.egg;
      default:
        return IconType.veg;
    }
  }
}
