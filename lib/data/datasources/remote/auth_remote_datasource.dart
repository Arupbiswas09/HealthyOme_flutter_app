import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../models/user/user_profile_model.dart';

abstract class AuthRemoteDatasource {
  Future<bool> loginWithPhone(String phoneNumber);
  Future<UserProfileModel> verifyOtp({required String phoneNumber, required String otp});
  Future<UserProfileModel> getProfile();
  Future<bool> logout();
  Future<bool> resendOtp(String phoneNumber);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient _api;

  AuthRemoteDatasourceImpl(this._api);

  @override
  Future<bool> loginWithPhone(String phoneNumber) async {
    try {
      await _api.post<dynamic>(ApiConstants.login, data: {'phone': phoneNumber});
      return true;
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final res = await _api.post<Map<String, dynamic>>(
        ApiConstants.verifyOtp,
        data: {'phone': phoneNumber, 'otp': otp},
      );
      final data = res.data;
      if (data == null) throw const ParseException('Empty response');
      final user = data['user'] ?? data;
      return UserProfileModel.fromJson(Map<String, dynamic>.from(user as Map));
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      final res = await _api.get<Map<String, dynamic>>(ApiConstants.profile);
      final data = res.data;
      if (data == null) throw const ParseException('Empty response');
      return UserProfileModel.fromJson(Map<String, dynamic>.from(data as Map));
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _api.post<dynamic>(ApiConstants.logout);
      return true;
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> resendOtp(String phoneNumber) async {
    try {
      await _api.post<dynamic>(ApiConstants.resendOtp, data: {'phone': phoneNumber});
      return true;
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }
}
