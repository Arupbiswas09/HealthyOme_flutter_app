import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../domain/entities/bowl.dart';
import '../../../../domain/usecases/bowl/get_bowl_bases.dart';
import '../../../../domain/usecases/bowl/get_bowl_ingredients.dart';

class BowlBuilderState {
  final AsyncValue<List<BowlBase>> bases;
  final AsyncValue<List<BowlIngredient>> ingredients;
  final BowlBase? selectedBase;
  final List<BowlIngredient> selectedIngredients;

  const BowlBuilderState({
    this.bases = const AsyncValue.loading(),
    this.ingredients = const AsyncValue.loading(),
    this.selectedBase,
    this.selectedIngredients = const [],
  });

  BowlBuilderState copyWith({
    AsyncValue<List<BowlBase>>? bases,
    AsyncValue<List<BowlIngredient>>? ingredients,
    BowlBase? selectedBase,
    List<BowlIngredient>? selectedIngredients,
  }) {
    return BowlBuilderState(
      bases: bases ?? this.bases,
      ingredients: ingredients ?? this.ingredients,
      selectedBase: selectedBase ?? this.selectedBase,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
    );
  }

  double get totalPrice {
    if (selectedBase == null) return 0;
    double total = selectedBase!.price;
    for (final i in selectedIngredients) {
      total += i.price;
    }
    return total;
  }
}

class BowlBuilderViewModel extends StateNotifier<BowlBuilderState> {
  final GetBowlBases _getBases;
  final GetBowlIngredients _getIngredients;

  BowlBuilderViewModel(this._getBases, this._getIngredients) : super(const BowlBuilderState());

  Future<void> loadBases() async {
    state = state.copyWith(bases: const AsyncValue.loading());
    final result = await _getBases();
    result.fold(
      (e) => state = state.copyWith(bases: AsyncValue.error(e, StackTrace.current)),
      (list) => state = state.copyWith(
        bases: AsyncValue.data(list),
        selectedBase: list.isNotEmpty ? list.first : null,
      ),
    );
  }

  Future<void> loadIngredients() async {
    state = state.copyWith(ingredients: const AsyncValue.loading());
    final result = await _getIngredients();
    result.fold(
      (e) => state = state.copyWith(ingredients: AsyncValue.error(e, StackTrace.current)),
      (list) => state = state.copyWith(ingredients: AsyncValue.data(list)),
    );
  }

  void setSelectedBase(BowlBase base) {
    state = state.copyWith(selectedBase: base);
  }

  void toggleIngredient(BowlIngredient ingredient) {
    final list = List<BowlIngredient>.from(state.selectedIngredients);
    final idx = list.indexWhere((e) => e.id == ingredient.id);
    if (idx >= 0) {
      list.removeAt(idx);
    } else {
      list.add(ingredient);
    }
    state = state.copyWith(selectedIngredients: list);
  }
}

final bowlBuilderViewModelProvider =
    StateNotifierProvider<BowlBuilderViewModel, BowlBuilderState>((ref) {
  return BowlBuilderViewModel(
    ref.read(getBowlBasesProvider),
    ref.read(getBowlIngredientsProvider),
  );
});
