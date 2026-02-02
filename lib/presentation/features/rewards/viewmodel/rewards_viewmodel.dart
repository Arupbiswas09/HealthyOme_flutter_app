import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../domain/entities/reward.dart';
import '../../../../domain/usecases/rewards/get_rewards.dart';

class RewardsState {
  final AsyncValue<List<Reward>> rewards;

  const RewardsState({
    this.rewards = const AsyncValue.loading(),
  });

  RewardsState copyWith({AsyncValue<List<Reward>>? rewards}) {
    return RewardsState(rewards: rewards ?? this.rewards);
  }
}

class RewardsViewModel extends StateNotifier<RewardsState> {
  final GetRewards _getRewards;

  RewardsViewModel(this._getRewards) : super(const RewardsState());

  Future<void> loadRewards() async {
    state = state.copyWith(rewards: const AsyncValue.loading());
    final result = await _getRewards();
    result.fold(
      (e) => state = state.copyWith(rewards: AsyncValue.error(e, StackTrace.current)),
      (list) => state = state.copyWith(rewards: AsyncValue.data(list)),
    );
  }
}

final rewardsViewModelProvider =
    StateNotifierProvider<RewardsViewModel, RewardsState>((ref) {
  return RewardsViewModel(ref.read(getRewardsProvider));
});
