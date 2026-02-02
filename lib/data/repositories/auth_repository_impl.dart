import 'package:dartz/dartz.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/api_exception.dart';
import '../../core/storage/secure_storage.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remote;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl(this._remote, this._secureStorage);

  @override
  Future<Either<ApiException, bool>> loginWithPhone(String phoneNumber) async {
    try {
      await _remote.loginWithPhone(phoneNumber);
      return const Right(true);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, UserProfile>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final profile = await _remote.verifyOtp(phoneNumber: phoneNumber, otp: otp);
      return Right(profile.toEntity());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, UserProfile>> register({
    required String name,
    required String phoneNumber,
    String? email,
  }) async {
    return const Left(ServerException('Register API not implemented', 501));
  }

  @override
  Future<Either<ApiException, bool>> resendOtp(String phoneNumber) async {
    try {
      await _remote.resendOtp(phoneNumber);
      return const Right(true);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, UserProfile>> getCurrentUser() async {
    try {
      final profile = await _remote.getProfile();
      return Right(profile.toEntity());
    } on ApiException catch (e) {
      // 404 = profile endpoint not yet on backend; show guest profile
      if (e is NotFoundException) return Right(UserProfile.guest);
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, UserProfile>> updateProfile(UserProfile profile) async {
    return const Left(ServerException('Update profile API not implemented', 501));
  }

  @override
  Future<Either<ApiException, DeliveryAddress>> addAddress(DeliveryAddress address) async {
    return const Left(ServerException('Add address API not implemented', 501));
  }

  @override
  Future<Either<ApiException, DeliveryAddress>> updateAddress(DeliveryAddress address) async {
    return const Left(ServerException('Update address API not implemented', 501));
  }

  @override
  Future<Either<ApiException, bool>> deleteAddress(int addressId) async {
    return const Left(ServerException('Delete address API not implemented', 501));
  }

  @override
  Future<Either<ApiException, bool>> setDefaultAddress(int addressId) async {
    return const Left(ServerException('Set default address API not implemented', 501));
  }

  @override
  Future<Either<ApiException, bool>> logout() async {
    try {
      await _remote.logout();
      await _secureStorage.deleteAllAuth();
      return const Right(true);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(AppConstants.accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<Either<ApiException, bool>> refreshToken() async {
    return const Left(ServerException('Refresh token API not implemented', 501));
  }
}
