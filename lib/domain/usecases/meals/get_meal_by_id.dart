import 'package:dartz/dartz.dart';

import '../../../core/network/api_exception.dart';
import '../../entities/meal.dart';
import '../../repositories/meals_repository.dart';

/// Use case: get meal by ID.
class GetMealById {
  final MealsRepository _repository;

  GetMealById(this._repository);

  Future<Either<ApiException, Meal>> call(int id) => _repository.getMealById(id);
}
