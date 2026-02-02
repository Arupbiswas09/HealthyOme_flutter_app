import 'package:dartz/dartz.dart';

import '../../../core/network/api_exception.dart';
import '../../entities/meal.dart';
import '../../repositories/meals_repository.dart';

/// Use case: get featured meals.
class GetFeaturedMeals {
  final MealsRepository _repository;

  GetFeaturedMeals(this._repository);

  Future<Either<ApiException, List<Meal>>> call() => _repository.getFeaturedMeals();
}
