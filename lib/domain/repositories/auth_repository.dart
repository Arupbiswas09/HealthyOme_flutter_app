import 'package:dartz/dartz.dart';
import '../../core/network/api_exception.dart';
import '../entities/user.dart';
import '../entities/order.dart';

/// Repository contract for Authentication
abstract class AuthRepository {
  /// Login with phone number (sends OTP)
  Future<Either<ApiException, bool>> loginWithPhone(String phoneNumber);

  /// Verify OTP
  Future<Either<ApiException, UserProfile>> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

  /// Register new user
  Future<Either<ApiException, UserProfile>> register({
    required String name,
    required String phoneNumber,
    String? email,
  });

  /// Resend OTP
  Future<Either<ApiException, bool>> resendOtp(String phoneNumber);

  /// Get current user profile
  Future<Either<ApiException, UserProfile>> getCurrentUser();

  /// Update user profile
  Future<Either<ApiException, UserProfile>> updateProfile(UserProfile profile);

  /// Add delivery address
  Future<Either<ApiException, DeliveryAddress>> addAddress(DeliveryAddress address);

  /// Update delivery address
  Future<Either<ApiException, DeliveryAddress>> updateAddress(DeliveryAddress address);

  /// Delete delivery address
  Future<Either<ApiException, bool>> deleteAddress(int addressId);

  /// Set default address
  Future<Either<ApiException, bool>> setDefaultAddress(int addressId);

  /// Logout
  Future<Either<ApiException, bool>> logout();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Refresh token
  Future<Either<ApiException, bool>> refreshToken();
}
