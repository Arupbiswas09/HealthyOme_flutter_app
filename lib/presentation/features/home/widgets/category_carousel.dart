import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

/// Category carousel for home screen
class CategoryCarousel extends StatelessWidget {
  const CategoryCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _Category(name: 'Salads', icon: Icons.eco, color: AppColors.primary),
      _Category(name: 'Bowls', icon: Icons.soup_kitchen, color: AppColors.secondary),
      _Category(name: 'Protein', icon: Icons.fitness_center, color: AppColors.error),
      _Category(name: 'Wraps', icon: Icons.breakfast_dining, color: AppColors.info),
      _Category(name: 'Smoothies', icon: Icons.local_drink, color: Colors.purple),
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.screenPadding,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryItem(category: category);
        },
      ),
    );
  }
}

class _Category {
  final String name;
  final IconData icon;
  final Color color;

  _Category({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class _CategoryItem extends StatelessWidget {
  final _Category category;

  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to filtered menu
      },
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(
                color: category.color.withOpacity(0.2),
              ),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
