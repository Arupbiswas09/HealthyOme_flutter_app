import 'package:dartz/dartz.dart';

import '../../../core/network/api_exception.dart';
import '../../entities/bowl.dart';
import '../../repositories/bowl_repository.dart';

class GetBowlIngredients {
  final BowlRepository _repository;

  GetBowlIngredients(this._repository);

  Future<Either<ApiException, List<BowlIngredient>>> call() =>
      _repository.getBowlIngredients();
}
