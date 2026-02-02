import 'package:dartz/dartz.dart';

import '../../../core/network/api_exception.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository _repository;

  VerifyOtp(this._repository);

  Future<Either<ApiException, UserProfile>> call({
    required String phoneNumber,
    required String otp,
  }) =>
      _repository.verifyOtp(phoneNumber: phoneNumber, otp: otp);
}
