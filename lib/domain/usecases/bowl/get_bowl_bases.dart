import 'package:dartz/dartz.dart';

import '../../../core/network/api_exception.dart';
import '../../entities/bowl.dart';
import '../../repositories/bowl_repository.dart';

class GetBowlBases {
  final BowlRepository _repository;

  GetBowlBases(this._repository);

  Future<Either<ApiException, List<BowlBase>>> call() =>
      _repository.getBowlBases();
}
