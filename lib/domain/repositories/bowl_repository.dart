import 'package:dartz/dartz.dart';
import '../../core/network/api_exception.dart';
import '../entities/bowl.dart';

/// Repository contract for Bowl Builder
abstract class BowlRepository {
  /// Get all bowl bases
  Future<Either<ApiException, List<BowlBase>>> getBowlBases();

  /// Get all bowl ingredients
  Future<Either<ApiException, List<BowlIngredient>>> getBowlIngredients();

  /// Get bowl ingredients by type
  Future<Either<ApiException, List<BowlIngredient>>> getBowlIngredientsByType(
    IngredientType type,
  );

  /// Create custom bowl order
  Future<Either<ApiException, bool>> orderCustomBowl(Bowl bowl);
}
