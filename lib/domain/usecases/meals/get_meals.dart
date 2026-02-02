import 'package:dartz/dartz.dart';

import '../../../core/network/api_exception.dart';
import '../../entities/meal.dart';
import '../../repositories/meals_repository.dart';

/// Use case: get all meals. Single responsibility, depends on repository contract.
class GetMeals {
  final MealsRepository _repository;

  GetMeals(this._repository);

  Future<Either<ApiException, List<Meal>>> call() => _repository.getMeals();
}
