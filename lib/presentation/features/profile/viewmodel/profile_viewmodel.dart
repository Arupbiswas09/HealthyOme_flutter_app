import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/usecases/auth/get_current_user.dart';

class ProfileState {
  final AsyncValue<UserProfile> profile;

  const ProfileState({
    this.profile = const AsyncValue.loading(),
  });

  ProfileState copyWith({AsyncValue<UserProfile>? profile}) {
    return ProfileState(profile: profile ?? this.profile);
  }
}

class ProfileViewModel extends StateNotifier<ProfileState> {
  final GetCurrentUser _getCurrentUser;

  ProfileViewModel(this._getCurrentUser) : super(const ProfileState());

  Future<void> loadProfile() async {
    state = state.copyWith(profile: const AsyncValue.loading());
    final result = await _getCurrentUser();
    result.fold(
      (e) => state = state.copyWith(profile: AsyncValue.error(e, StackTrace.current)),
      (user) => state = state.copyWith(profile: AsyncValue.data(user)),
    );
  }
}

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
  return ProfileViewModel(ref.read(getCurrentUserProvider));
});
