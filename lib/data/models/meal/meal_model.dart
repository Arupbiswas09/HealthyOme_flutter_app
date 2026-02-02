import '../../../domain/entities/meal.dart';

/// Meal data model for JSON serialization
class MealModel {
  final int id;
  final String name;
  final String? description;
  final bool? isActive;
  final MealPlanTypeModel? mealPlanType;
  final MealCategoryModel? category;
  final MealTimeModel? mealTime;
  final String? price;
  final String? originalPrice;
  final dynamic calories;
  final String? protein;
  final String? carbs;
  final String? fats;
  final String? fiber;
  final String? rating;
  final String? image;
  final String? imageUrl;

  const MealModel({
    required this.id,
    required this.name,
    this.description,
    this.isActive,
    this.mealPlanType,
    this.category,
    this.mealTime,
    this.price,
    this.originalPrice,
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    this.fiber,
    this.rating,
    this.image,
    this.imageUrl,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool?,
      mealPlanType: json['meal_plan_type'] != null
          ? MealPlanTypeModel.fromJson(json['meal_plan_type'])
          : null,
      category: json['category'] != null
          ? MealCategoryModel.fromJson(json['category'])
          : null,
      mealTime: json['meal_time'] != null
          ? MealTimeModel.fromJson(json['meal_time'])
          : null,
      price: json['price']?.toString(),
      originalPrice: json['original_price']?.toString(),
      calories: json['calories'],
      protein: json['protein']?.toString(),
      carbs: json['carbs']?.toString(),
      fats: json['fats']?.toString(),
      fiber: json['fiber']?.toString(),
      rating: json['rating']?.toString(),
      image: json['image'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'is_active': isActive,
    'meal_plan_type': mealPlanType?.toJson(),
    'category': category?.toJson(),
    'meal_time': mealTime?.toJson(),
    'price': price,
    'original_price': originalPrice,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fats': fats,
    'fiber': fiber,
    'rating': rating,
    'image': image,
    'imageUrl': imageUrl,
  };

  Meal toEntity() {
    return Meal(
      id: id,
      name: name,
      description: description,
      isActive: isActive ?? true,
      mealPlanType: mealPlanType?.toEntity(),
      category: category?.toEntity(),
      mealTime: mealTime?.toEntity(),
      price: _parseDouble(price) ?? 0.0,
      originalPrice: _parseDouble(originalPrice),
      calories: _parseInt(calories),
      protein: _parseDouble(protein),
      carbs: _parseDouble(carbs),
      fats: _parseDouble(fats),
      fiber: _parseDouble(fiber),
      rating: _parseDouble(rating),
      imageUrl: imageUrl ?? image,
    );
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

/// Meal Plan Type data model
class MealPlanTypeModel {
  final int id;
  final String name;
  final String? description;
  final bool? isActive;

  const MealPlanTypeModel({
    required this.id,
    required this.name,
    this.description,
    this.isActive,
  });

  factory MealPlanTypeModel.fromJson(Map<String, dynamic> json) {
    return MealPlanTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'is_active': isActive,
  };

  MealPlanType toEntity() {
    return MealPlanType(
      id: id,
      name: name,
      description: description,
      isActive: isActive ?? true,
    );
  }
}

/// Meal Category data model
class MealCategoryModel {
  final int id;
  final String name;

  const MealCategoryModel({
    required this.id,
    required this.name,
  });

  factory MealCategoryModel.fromJson(Map<String, dynamic> json) {
    return MealCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  MealCategory toEntity() {
    return MealCategory(
      id: id,
      name: name,
    );
  }
}

/// Meal Time data model
class MealTimeModel {
  final int id;
  final String name;

  const MealTimeModel({
    required this.id,
    required this.name,
  });

  factory MealTimeModel.fromJson(Map<String, dynamic> json) {
    return MealTimeModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  MealTime toEntity() {
    return MealTime(
      id: id,
      name: name,
    );
  }
}

/// Paginated response model
class PaginatedResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  const PaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  bool get hasNext => next != null;
  bool get hasPrevious => previous != null;
}
