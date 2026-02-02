import 'package:dartz/dartz.dart';

import '../../core/network/api_exception.dart';
import '../../domain/entities/meal.dart';
import '../../domain/repositories/meals_repository.dart';
import '../datasources/remote/meals_remote_datasource.dart';

/// Repository implementation - orchestrates datasources, maps to domain entities.
class MealsRepositoryImpl implements MealsRepository {
  final MealsRemoteDatasource _remote;

  MealsRepositoryImpl(this._remote);

  @override
  Future<Either<ApiException, List<Meal>>> getMeals() async {
    try {
      final models = await _remote.getMeals();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<Meal>>> getFeaturedMeals() async {
    try {
      final models = await _remote.getFeaturedMeals();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, Meal>> getMealById(int id) async {
    try {
      final model = await _remote.getMealById(id);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<Meal>>> getMealsByCategory(String category) async {
    final result = await getMeals();
    return result.fold(
      Left.new,
      (meals) => Right(
        meals.where((m) {
          final cat = m.category?.name.toLowerCase();
          final c = category.toLowerCase();
          if (c == 'all') return true;
          if (c == 'veg') return cat == 'veg';
          if (c == 'non-veg') return cat == 'non-veg' || cat == 'non-veg';
          if (c == 'egg') return cat == 'egg';
          return cat == c;
        }).toList(),
      ),
    );
  }

  @override
  Future<Either<ApiException, List<Meal>>> getMealsByPlanType(int planTypeId) async {
    final result = await getMeals();
    return result.fold(
      Left.new,
      (meals) => Right(
        meals.where((m) => m.mealPlanType?.id == planTypeId).toList(),
      ),
    );
  }

  @override
  Future<Either<ApiException, List<Meal>>> searchMeals(String query) async {
    final result = await getMeals();
    return result.fold(
      Left.new,
      (meals) {
        final q = query.toLowerCase();
        return Right(
          meals
              .where((m) =>
                  m.name.toLowerCase().contains(q) ||
                  (m.description?.toLowerCase().contains(q) ?? false))
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either<ApiException, List<Meal>>> getCachedMeals() async {
    // No local cache implemented yet - return empty; could use Hive later
    return const Right([]);
  }
}
