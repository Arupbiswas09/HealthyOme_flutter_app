import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../domain/entities/meal.dart';
import '../../../../domain/usecases/meals/get_featured_meals.dart';

/// Home screen state - featured meals from API.
class HomeState {
  final AsyncValue<List<Meal>> featuredMeals;

  const HomeState({
    this.featuredMeals = const AsyncValue.loading(),
  });

  HomeState copyWith({AsyncValue<List<Meal>>? featuredMeals}) {
    return HomeState(
      featuredMeals: featuredMeals ?? this.featuredMeals,
    );
  }
}

/// ViewModel: uses GetFeaturedMeals use case only.
class HomeViewModel extends StateNotifier<HomeState> {
  final GetFeaturedMeals _getFeaturedMeals;

  HomeViewModel(this._getFeaturedMeals) : super(const HomeState());

  Future<void> loadFeaturedMeals() async {
    state = state.copyWith(featuredMeals: const AsyncValue.loading());
    final result = await _getFeaturedMeals();
    result.fold(
      (failure) => state = state.copyWith(
        featuredMeals: AsyncValue.error(failure, StackTrace.current),
      ),
      (meals) => state = state.copyWith(
        featuredMeals: AsyncValue.data(meals),
      ),
    );
  }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(ref.read(getFeaturedMealsProvider));
});
