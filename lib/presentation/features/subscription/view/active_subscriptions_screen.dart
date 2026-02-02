import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';

/// Active Subscriptions Screen - Shows user's active meal plan subscriptions
class ActiveSubscriptionsScreen extends StatelessWidget {
  const ActiveSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock active subscriptions - TODO: Replace with actual API call
    final subscriptions = [
      {
        'id': '1',
        'planName': 'Weight Loss Plan',
        'period': '12 Days',
        'startDate': '2026-01-25',
        'endDate': '2026-02-06',
        'daysRemaining': 4,
        'mealsPerDay': 2,
        'status': 'Active',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('My Subscriptions'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: subscriptions.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: AppSpacing.screenPadding,
              itemCount: subscriptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final subscription = subscriptions[index];
                return _SubscriptionCard(subscription: subscription);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.event_busy,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No Active Subscriptions',
            style: AppTypography.headline3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Subscribe to a meal plan to get started',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final Map<String, dynamic> subscription;

  const _SubscriptionCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final daysRemaining = subscription['daysRemaining'] as int;
    final progress = 1 - (daysRemaining / 12); // Assuming 12 day plan

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subscription['planName'] as String,
                  style: AppTypography.headline3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Text(
                  subscription['status'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Period & Meals
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                subscription['period'] as String,
                style: AppTypography.bodySmall,
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(Icons.restaurant, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${subscription['mealsPerDay']} meals/day',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$daysRemaining days remaining',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'Ends: ${subscription['endDate']}',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: AppSpacing.borderRadiusSm,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Pause subscription
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  child: const Text('Pause'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Manage subscription
                  },
                  child: const Text('Manage'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
