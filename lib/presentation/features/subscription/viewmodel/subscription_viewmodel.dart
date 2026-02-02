import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../domain/entities/subscription.dart';
import '../../../../domain/usecases/subscription/get_subscription_periods.dart';
import '../../../../domain/usecases/subscription/get_subscription_plans.dart';

class SubscriptionState {
  final AsyncValue<List<Subscription>> plans;
  final AsyncValue<List<SubscriptionPeriod>> periods;
  final int selectedPeriodIndex;

  const SubscriptionState({
    this.plans = const AsyncValue.loading(),
    this.periods = const AsyncValue.data([]),
    this.selectedPeriodIndex = 0,
  });

  SubscriptionState copyWith({
    AsyncValue<List<Subscription>>? plans,
    AsyncValue<List<SubscriptionPeriod>>? periods,
    int? selectedPeriodIndex,
  }) {
    return SubscriptionState(
      plans: plans ?? this.plans,
      periods: periods ?? this.periods,
      selectedPeriodIndex: selectedPeriodIndex ?? this.selectedPeriodIndex,
    );
  }
}

class SubscriptionViewModel extends StateNotifier<SubscriptionState> {
  final GetSubscriptionPlans _getPlans;
  final GetSubscriptionPeriods _getPeriods;

  SubscriptionViewModel(this._getPlans, this._getPeriods) : super(const SubscriptionState());

  Future<void> loadPlans() async {
    state = state.copyWith(plans: const AsyncValue.loading());
    final result = await _getPlans();
    result.fold(
      (e) => state = state.copyWith(plans: AsyncValue.error(e, StackTrace.current)),
      (list) => state = state.copyWith(plans: AsyncValue.data(list)),
    );
  }

  Future<void> loadPeriods() async {
    final result = await _getPeriods();
    result.fold(
      (e) => state = state.copyWith(periods: AsyncValue.error(e, StackTrace.current)),
      (list) => state = state.copyWith(periods: AsyncValue.data(list)),
    );
  }

  void setSelectedPeriodIndex(int index) {
    state = state.copyWith(selectedPeriodIndex: index);
  }
}

final subscriptionViewModelProvider =
    StateNotifierProvider<SubscriptionViewModel, SubscriptionState>((ref) {
  return SubscriptionViewModel(
    ref.read(getSubscriptionPlansProvider),
    ref.read(getSubscriptionPeriodsProvider),
  );
});
