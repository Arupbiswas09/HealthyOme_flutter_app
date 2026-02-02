import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/asset_constants.dart';
import '../viewmodel/subscription_viewmodel.dart';
import '../widgets/plan_card.dart';
import '../widgets/period_selector.dart';

/// Subscription Screen - plans from API via SubscriptionViewModel
class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(subscriptionViewModelProvider.notifier).loadPlans();
      ref.read(subscriptionViewModelProvider.notifier).loadPeriods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionViewModelProvider);
    final periods = subState.periods.when(
      data: (list) => list.map((p) => {'name': '${p.days} Days', 'days': p.days, 'isTrial': p.isTrial}).toList(),
      loading: () => <Map<String, dynamic>>[],
      error: (_, __) => <Map<String, dynamic>>[],
    );
    final defaultPeriods = [
      {'name': '6 Days', 'days': 6, 'isTrial': true},
      {'name': '12 Days', 'days': 12, 'isTrial': false},
      {'name': '24 Days', 'days': 24, 'isTrial': false},
    ];
    final periodList = periods.isNotEmpty ? periods : defaultPeriods;
    final selectedIndex = subState.selectedPeriodIndex.clamp(0, periodList.length - 1);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.screenPadding.copyWith(top: AppSpacing.sm, bottom: AppSpacing.sm),
              child: Row(
                children: [
                  // Back button since this is a full-screen route
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    onPressed: () => context.pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text('Subscription Plans', style: AppTypography.headline1),
                  ),
                  TextButton(
                    onPressed: () => context.push('${AppRoutes.subscriptionPath}/active'),
                    child: const Text('My Plans'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppSpacing.screenPadding,
              child: Text(
                'Choose a meal plan and subscription period that fits your goals.',
                style: AppTypography.bodyMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            PeriodSelector(
              periods: periodList,
              selectedIndex: selectedIndex,
              onSelected: (index) => ref.read(subscriptionViewModelProvider.notifier).setSelectedPeriodIndex(index),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: subState.plans.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (e, _) => Center(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: AppSpacing.md),
                        Text(e.toString().replaceFirst('ApiException: ', ''), textAlign: TextAlign.center),
                        const SizedBox(height: AppSpacing.md),
                        TextButton.icon(
                          onPressed: () => ref.read(subscriptionViewModelProvider.notifier).loadPlans(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (plans) {
                  if (plans.isEmpty) {
                    return Center(
                      child: Text(
                        'No subscription plans available',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: AppSpacing.screenPadding.copyWith(bottom: AppSpacing.bottomNavHeight + AppSpacing.lg),
                    itemCount: plans.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      return PlanCard(
                        name: plan.mealPlanType.name,
                        description: plan.mealPlanType.description ?? 'Healthy meals',
                        images: const [AssetConstants.placeholder],
                        price: plan.price,
                        originalPrice: plan.originalPrice ?? plan.price,
                        duration: '${plan.period.days} Days',
                        onTap: () {},
                        onSubscribe: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Subscribed to ${plan.mealPlanType.name}!'),
                              action: SnackBarAction(
                                label: 'View',
                                onPressed: () => context.push('${AppRoutes.subscriptionPath}/active'),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
