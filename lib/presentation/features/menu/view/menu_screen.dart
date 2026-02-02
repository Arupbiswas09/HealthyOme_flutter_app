import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/routes/app_routes.dart';
import '../viewmodel/menu_viewmodel.dart';
import '../widgets/menu_filter_bar.dart';
import '../widgets/meal_card.dart';
import '../widgets/menu_hero_card.dart';

/// Menu Screen - Display all meals with filters. Follows MVVM: UI observes ViewModel.
class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  static const List<String> _filters = ['All', 'Veg', 'Non-Veg', 'Egg'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(menuViewModelProvider.notifier).loadMeals());
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header + Search + Filter
            Container(
              color: AppColors.background,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: AppSpacing.screenPadding.copyWith(
                      top: AppSpacing.md,
                      bottom: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Our Menu', style: AppTypography.headline1),
                            GestureDetector(
                              onTap: () => context.push(AppRoutes.cartPath),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: const Icon(Icons.shopping_bag_outlined, size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppSpacing.borderRadiusLg,
                            border: Border.all(color: AppColors.border),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0D000000),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: AppColors.textTertiary),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Search for meals',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.mic_none, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  MenuFilterBar(
                    filters: _filters,
                    selectedFilter: menuState.selectedFilter,
                    onFilterChanged: (filter) {
                      ref.read(menuViewModelProvider.notifier).setFilter(filter);
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),

            // Content: loading / error / grid
            Expanded(
              child: menuState.meals.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (err, _) => Center(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          err.toString().replaceFirst('ApiException: ', ''),
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextButton.icon(
                          onPressed: () => ref
                              .read(menuViewModelProvider.notifier)
                              .loadMeals(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (_) => CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: AppSpacing.screenPadding,
                        child: MenuHeroCard(
                          onTap: () => context.push(AppRoutes.bowlBuilderPath),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
                    SliverPadding(
                      padding: AppSpacing.screenPadding.copyWith(
                        bottom: AppSpacing.bottomNavHeight + AppSpacing.lg,
                      ),
                      sliver: menuState.filteredMeals.isEmpty
                          ? SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 48),
                                child: Center(
                                  child: Text(
                                    'No meals in this category',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final meal = menuState.filteredMeals[index];
                                  return MealCard(
                                    name: meal.name,
                                    category: meal.category?.name ?? 'All',
                                    calories: meal.calories ?? 0,
                                    price: meal.price,
                                    rating: meal.rating ?? 0,
                                    isVeg: meal.isVeg,
                                    imagePath: meal.imageUrl,
                                    onTap: () {
                                      // TODO: meal detail sheet
                                    },
                                    onAdd: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${meal.name} added to cart!'),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  );
                                },
                                childCount: menuState.filteredMeals.length,
                              ),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.72,
                                crossAxisSpacing: AppSpacing.md,
                                mainAxisSpacing: AppSpacing.md,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
