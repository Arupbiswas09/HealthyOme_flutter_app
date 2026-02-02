import 'package:dartz/dartz.dart';
import '../../core/network/api_exception.dart';
import '../entities/meal.dart';

/// Repository contract for Meals
abstract class MealsRepository {
  /// Get all meals
  Future<Either<ApiException, List<Meal>>> getMeals();

  /// Get featured meals
  Future<Either<ApiException, List<Meal>>> getFeaturedMeals();

  /// Get meal by ID
  Future<Either<ApiException, Meal>> getMealById(int id);

  /// Get meals by category
  Future<Either<ApiException, List<Meal>>> getMealsByCategory(String category);

  /// Get meals by meal plan type
  Future<Either<ApiException, List<Meal>>> getMealsByPlanType(int planTypeId);

  /// Search meals
  Future<Either<ApiException, List<Meal>>> searchMeals(String query);

  /// Get cached meals (offline support)
  Future<Either<ApiException, List<Meal>>> getCachedMeals();
}
