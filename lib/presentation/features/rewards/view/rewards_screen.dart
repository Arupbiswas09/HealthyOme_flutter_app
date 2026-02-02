import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../viewmodel/rewards_viewmodel.dart';

/// Rewards Screen - rewards from API via RewardsViewModel
class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(rewardsViewModelProvider.notifier).loadRewards());
  }

  @override
  Widget build(BuildContext context) {
    final rewardsState = ref.watch(rewardsViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Rewards'),
      ),
      body: rewardsState.rewards.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: AppSpacing.md),
                Text(e.toString().replaceFirst('ApiException: ', ''), textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.md),
                TextButton.icon(
                  onPressed: () => ref.read(rewardsViewModelProvider.notifier).loadRewards(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (rewards) => SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: AppSpacing.borderRadiusLg,
                ),
                child: Column(
                  children: [
                    const Icon(Icons.stars, size: 48, color: AppColors.secondary),
                    const SizedBox(height: AppSpacing.sm),
                    Text('500', style: AppTypography.displayLarge.copyWith(color: AppColors.textPrimary)),
                    Text('Available Points', style: AppTypography.bodyMedium),
                    const SizedBox(height: AppSpacing.md),
                    Text('Earn 1 point for every ₹10 spent', style: AppTypography.labelSmall),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Redeem Rewards', style: AppTypography.headline3),
              const SizedBox(height: AppSpacing.md),
              if (rewards.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Text(
                      'No rewards available',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...rewards.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppSpacing.borderRadiusMd,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight,
                            borderRadius: AppSpacing.borderRadiusSm,
                          ),
                          child: const Icon(Icons.card_giftcard, color: AppColors.secondary),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text(r.description, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text('${r.pointsRequired} pts', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                            const SizedBox(height: 4),
                            TextButton(
                              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${r.name} redeemed!')),
                              ),
                              child: const Text('Redeem'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }
}
