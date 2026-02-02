import '../../../domain/entities/bowl.dart';

/// Bowl Base data model for JSON serialization
class BowlBaseModel {
  final int id;
  final String name;
  final String price;
  final bool? isActive;

  const BowlBaseModel({
    required this.id,
    required this.name,
    required this.price,
    this.isActive,
  });

  factory BowlBaseModel.fromJson(Map<String, dynamic> json) {
    return BowlBaseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price']?.toString() ?? '0',
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'is_active': isActive,
  };

  BowlBase toEntity() {
    return BowlBase(
      id: id,
      name: name,
      price: double.tryParse(price) ?? 0.0,
      isActive: isActive ?? true,
    );
  }
}

/// Bowl Ingredient data model for JSON serialization
class BowlIngredientModel {
  final int id;
  final String name;
  final String ingredientType;
  final String price;
  final String iconType;
  final bool? isActive;
  final int? calories;
  final String? imageUrl;

  const BowlIngredientModel({
    required this.id,
    required this.name,
    required this.ingredientType,
    required this.price,
    required this.iconType,
    this.isActive,
    this.calories,
    this.imageUrl,
  });

  factory BowlIngredientModel.fromJson(Map<String, dynamic> json) {
    return BowlIngredientModel(
      id: json['id'] as int,
      name: json['name'] as String,
      ingredientType: json['ingredient_type'] as String,
      price: json['price']?.toString() ?? '0',
      iconType: json['icon_type'] as String,
      isActive: json['is_active'] as bool?,
      calories: json['calories'] as int?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ingredient_type': ingredientType,
    'price': price,
    'icon_type': iconType,
    'is_active': isActive,
    'calories': calories,
    'image_url': imageUrl,
  };

  BowlIngredient toEntity() {
    return BowlIngredient(
      id: id,
      name: name,
      type: IngredientTypeExtension.fromString(ingredientType),
      price: double.tryParse(price) ?? 0.0,
      iconType: IconTypeExtension.fromString(iconType),
      isActive: isActive ?? true,
      calories: calories,
      imageUrl: imageUrl,
    );
  }
}
