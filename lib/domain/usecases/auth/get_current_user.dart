import 'package:dartz/dartz.dart';

import '../../../core/network/api_exception.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository _repository;

  GetCurrentUser(this._repository);

  Future<Either<ApiException, UserProfile>> call() =>
      _repository.getCurrentUser();
}
