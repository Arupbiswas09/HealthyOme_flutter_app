import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/asset_constants.dart';
import '../viewmodel/home_viewmodel.dart';
import '../widgets/hero_section.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/category_carousel.dart';
import '../widgets/featured_meal_card.dart';
import '../widgets/consult_card.dart';
import '../widgets/feature_card.dart';

/// Home Screen - Main dashboard. Featured meals from API via HomeViewModel.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(homeViewModelProvider.notifier).loadFeaturedMeals(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Combined Hero + Overlapping Promo Section
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // 1. Dark Green Hero Background (with extra bottom space for overlap)
                const Padding(
                  padding: EdgeInsets.only(bottom: 40.0), // Space for overhang
                  child: HeroSection(),
                ),
                
                // 2. Overlapping Promo Carousel
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: PromoCarousel(),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Subscription Feature Card
            Padding(
              padding: AppSpacing.screenPadding,
              child: FeatureCard(
                badgeText: 'BEST VALUE',
                title: 'Subscription Meals',
                subtitle: 'Long-term habit builder',
                gradient: AppColors.primaryGradient,
                imagePath: AssetConstants.subscriptionImg,
                onTap: () => context.push(AppRoutes.subscriptionPath),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Quick Meals Feature Card
            Padding(
              padding: AppSpacing.screenPadding,
              child: FeatureCard(
                title: 'Quick Meals',
                subtitle: 'Instant healthy delivery',
                gradient: AppColors.secondaryGradient,
                imagePath: AssetConstants.quickMealImg,
                onTap: () => context.push(AppRoutes.menuPath),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Consult Card
            Padding(
              padding: AppSpacing.screenPadding,
              child: ConsultCard(
                title: 'Consult a Dietician',
                subtitle: 'Personalized food guidance',
                onTap: () => context.push('${AppRoutes.profilePath}/support'),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Categories Section
            Padding(
              padding: AppSpacing.screenPadding,
              child: Text(
                'Categories',
                style: AppTypography.headline3,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            const CategoryCarousel(),

            const SizedBox(height: AppSpacing.xl),

            // Featured Meals Section (from API via ViewModel)
            Padding(
              padding: AppSpacing.screenPadding,
              child: Text(
                'Featured Meal',
                style: AppTypography.headline3,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            _FeaturedMealsRow(),

            const SizedBox(height: AppSpacing.xl),

            // Footer message
            Padding(
              padding: AppSpacing.screenPadding,
              child: Text(
                'Serving select areas to keep meals fresh and healthy 🌱',
                style: AppTypography.headline1.copyWith(
                  color: AppColors.textDisabled,
                  fontSize: 20,
                ),
              ),
            ),

            // Bottom padding for navbar
            const SizedBox(height: AppSpacing.bottomNavHeight + AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

/// Featured meals row - watches HomeViewModel, shows loading/error/data.
class _FeaturedMealsRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return Padding(
      padding: AppSpacing.screenPadding,
      child: homeState.featuredMeals.when(
        loading: () => const SizedBox(
          height: 140,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
        error: (_, __) => const SizedBox(
          height: 80,
          child: Center(
            child: Text(
              'Could not load featured meals',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
        data: (meals) {
          if (meals.isEmpty) {
            return const SizedBox(height: 80);
          }
          final firstTwo = meals.take(2).toList();
          return Row(
            children: [
              if (firstTwo.isNotEmpty)
                Expanded(
                  child: FeaturedMealCard(
                    title: firstTwo[0].name,
                    category: firstTwo[0].category?.name ?? 'All',
                    calories: '${firstTwo[0].calories ?? 0} kcal',
                    price: '₹${firstTwo[0].price.toStringAsFixed(0)}',
                    isVeg: firstTwo[0].isVeg,
                    onTap: () => context.push(AppRoutes.menuPath),
                    onAdd: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${firstTwo[0].name} added to cart!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              if (firstTwo.length > 1) const SizedBox(width: AppSpacing.md),
              if (firstTwo.length > 1)
                Expanded(
                  child: FeaturedMealCard(
                    title: firstTwo[1].name,
                    category: firstTwo[1].category?.name ?? 'All',
                    calories: '${firstTwo[1].calories ?? 0} kcal',
                    price: '₹${firstTwo[1].price.toStringAsFixed(0)}',
                    isVeg: firstTwo[1].isVeg,
                    onTap: () => context.push(AppRoutes.menuPath),
                    onAdd: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${firstTwo[1].name} added to cart!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
