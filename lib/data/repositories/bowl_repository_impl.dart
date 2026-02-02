import 'package:dartz/dartz.dart';

import '../../core/network/api_exception.dart';
import '../../domain/entities/bowl.dart';
import '../../domain/repositories/bowl_repository.dart';
import '../datasources/remote/bowl_remote_datasource.dart';

class BowlRepositoryImpl implements BowlRepository {
  final BowlRemoteDatasource _remote;

  BowlRepositoryImpl(this._remote);

  @override
  Future<Either<ApiException, List<BowlBase>>> getBowlBases() async {
    try {
      final models = await _remote.getBowlBases();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<BowlIngredient>>> getBowlIngredients() async {
    try {
      final models = await _remote.getBowlIngredients();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<BowlIngredient>>> getBowlIngredientsByType(IngredientType type) async {
    try {
      final models = await _remote.getBowlIngredientsByType(type.apiValue);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, bool>> orderCustomBowl(Bowl bowl) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      return const Right(true);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
