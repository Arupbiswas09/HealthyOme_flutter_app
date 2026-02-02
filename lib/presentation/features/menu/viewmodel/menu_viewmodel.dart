import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../domain/entities/meal.dart';
import '../../../../domain/usecases/meals/get_meals.dart';

/// Menu screen state - follows MVVM, single source of truth.
class MenuState {
  final AsyncValue<List<Meal>> meals;
  final String selectedFilter;

  const MenuState({
    this.meals = const AsyncValue.loading(),
    this.selectedFilter = 'All',
  });

  MenuState copyWith({
    AsyncValue<List<Meal>>? meals,
    String? selectedFilter,
  }) {
    return MenuState(
      meals: meals ?? this.meals,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  List<Meal> get filteredMeals {
    return meals.when(
      data: (list) {
        if (selectedFilter == 'All') return list;
        return list.where((m) {
          final cat = m.category?.name ?? '';
          if (selectedFilter == 'Veg') return cat.toLowerCase() == 'veg';
          if (selectedFilter == 'Non-Veg') return cat.toLowerCase().contains('non');
          if (selectedFilter == 'Egg') return cat.toLowerCase() == 'egg';
          return true;
        }).toList();
      },
      loading: () => [],
      error: (_, __) => [],
    );
  }
}

/// ViewModel: depends on use cases only, no UI. Calls GetMeals, maps to state.
class MenuViewModel extends StateNotifier<MenuState> {
  final GetMeals _getMeals;

  MenuViewModel(this._getMeals) : super(const MenuState());

  Future<void> loadMeals() async {
    state = state.copyWith(meals: const AsyncValue.loading());
    final result = await _getMeals();
    result.fold(
      (failure) => state = state.copyWith(
        meals: AsyncValue.error(failure, StackTrace.current),
      ),
      (meals) => state = state.copyWith(meals: AsyncValue.data(meals)),
    );
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }
}

final menuViewModelProvider =
    StateNotifierProvider<MenuViewModel, MenuState>((ref) {
  return MenuViewModel(ref.read(getMealsProvider));
});
