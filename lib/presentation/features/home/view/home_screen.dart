import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/routes/app_routes.dart';
import '../viewmodel/home_viewmodel.dart';
import '../widgets/hero_section.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/category_carousel.dart';
import '../widgets/featured_meal_card.dart';
import '../widgets/consult_card.dart';
import '../widgets/feature_card.dart';

/// Home Screen - Main dashboard matching web app design exactly
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
    final homeState = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with Overlapping Promo Carousel
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Hero Section (Dark Green Background)
                const HeroSection(),
                
                // Overlapping Promo Carousel (positioned at bottom of hero)
                Positioned(
                  bottom: -40, // Overlap by 40px
                  left: 0,
                  right: 0,
                  child: const PromoCarousel(),
                ),
              ],
            ),

            const SizedBox(height: 60), // Space for overlapping promo

            // Subscription Feature Card
            Padding(
              padding: AppSpacing.screenPadding,
              child: FeatureCard(
                badgeText: 'BEST VALUE',
                title: 'Subscription Meals',
                subtitle: 'Long-term habit builder',
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                imagePath: 'assets/images/subscription-img.webp',
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
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF9C4), Color(0xFFFFF59D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                imagePath: 'assets/images/quick-meal2.webp',
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

            const SizedBox(height: AppSpacing.lg),

            // Categories Section
            Padding(
              padding: AppSpacing.screenPadding,
              child: Text('Categories', style: AppTypography.headline3),
            ),
            const SizedBox(height: AppSpacing.md),
            const CategoryCarousel(),

            const SizedBox(height: AppSpacing.lg),

            // Featured Meals Section
            Padding(
              padding: AppSpacing.screenPadding,
              child: Text('Featured Meal', style: AppTypography.headline3),
            ),
            const SizedBox(height: AppSpacing.md),

            // Featured Meals Grid
            homeState.featuredMeals.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Failed to load featured meals',
                        style: AppTypography.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextButton.icon(
                        onPressed: () => ref.read(homeViewModelProvider.notifier).loadFeaturedMeals(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (meals) {
                if (meals.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: AppSpacing.screenPadding,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                    ),
                    itemCount: meals.length > 4 ? 4 : meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return FeaturedMealCard(
                        title: meal.name,
                        category: meal.category?.name ?? 'Meal',
                        calories: '${meal.calories ?? 0} kcal',
                        price: '₹${meal.price.toStringAsFixed(0)}',
                        isVeg: meal.isVeg,
                        imagePath: meal.imageUrl,
                        onTap: () {
                          // TODO: Navigate to meal detail
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
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // Bottom Text
            Padding(
              padding: AppSpacing.screenPadding,
              child: Text(
                'Serving select areas to keep meals fresh and healthy 🥗',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Bottom padding for nav bar
            const SizedBox(height: AppSpacing.bottomNavHeight + AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
