import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/routes/app_routes.dart';
import '../viewmodel/profile_viewmodel.dart';

/// Profile Screen - profile from API via ProfileViewModel
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileViewModelProvider.notifier).loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profileState.profile.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off_outlined, size: 48, color: AppColors.textTertiary),
                const SizedBox(height: AppSpacing.md),
                Text('Not logged in or session expired', style: AppTypography.bodyMedium),
                const SizedBox(height: AppSpacing.md),
                TextButton.icon(
                  onPressed: () => ref.read(profileViewModelProvider.notifier).loadProfile(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (profile) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: AppSpacing.bottomNavHeight + AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profile.id == 0)
                  Padding(
                    padding: AppSpacing.screenPadding.copyWith(top: AppSpacing.md),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Sign in to see your full profile',
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: AppSpacing.screenPadding.copyWith(
                    top: AppSpacing.md,
                    bottom: AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            profile.initials,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profile.name, style: AppTypography.headline2),
                            const SizedBox(height: 2),
                            Text(profile.phone, style: AppTypography.bodyMedium),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push('${AppRoutes.profilePath}/edit'),
                        icon: const Icon(Icons.edit_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: AppSpacing.screenPadding,
                  child: Row(
                    children: [
                      _StatCard(
                        icon: Icons.receipt_long,
                        value: '${profile.totalOrders}',
                        label: 'Orders',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _StatCard(
                        icon: Icons.star,
                        value: '${profile.rewardPoints}',
                        label: 'Points',
                        color: AppColors.secondary,
                        onTap: () => context.push(AppRoutes.rewardsPath),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const _StatCard(
                        icon: Icons.repeat,
                        value: '0',
                        label: 'Active Plans',
                        color: AppColors.info,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: AppSpacing.xl),

              // Menu sections
              _MenuSection(
                title: 'My Account',
                items: [
                  _MenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    subtitle: '2 addresses saved',
                    onTap: () => context.push('${AppRoutes.profilePath}/addresses'),
                  ),
                  _MenuItem(
                    icon: Icons.card_giftcard_outlined,
                    title: 'Rewards',
                    subtitle: '500 points available',
                    onTap: () => context.push(AppRoutes.rewardsPath),
                  ),
                  _MenuItem(
                    icon: Icons.receipt_outlined,
                    title: 'Order History',
                    onTap: () => context.go(AppRoutes.ordersPath),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              _MenuSection(
                title: 'Preferences',
                items: [
                  _MenuItem(
                    icon: Icons.restaurant_outlined,
                    title: 'Dietary Preferences',
                    subtitle: 'Vegetarian',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              _MenuSection(
                title: 'Support',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & FAQ',
                    onTap: () => context.push('${AppRoutes.profilePath}/support'),
                  ),
                  _MenuItem(
                    icon: Icons.chat_outlined,
                    title: 'Chat with Us',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    title: 'About Healthy-O-Me',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Logout button
              Padding(
                padding: AppSpacing.screenPadding,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement logout
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Logout'),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Version
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: AppSpacing.sm),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPadding,
          child: Text(
            title,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          margin: AppSpacing.screenPadding,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppSpacing.borderRadiusMd,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast)
                    const Divider(height: 1, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
          ),
    );
  }
}
