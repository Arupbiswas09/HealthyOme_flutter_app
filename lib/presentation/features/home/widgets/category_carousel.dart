import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

/// Category carousel matching web app design
class CategoryCarousel extends StatelessWidget {
  const CategoryCarousel({super.key});

  static const _categories = [
    {'name': 'Smoothie', 'icon': 'assets/images/figma/new_home/cat_smoothie.svg'},
    {'name': 'Soup', 'icon': 'assets/images/figma/new_home/cat_soup.svg'},
    {'name': 'Salads', 'icon': 'assets/images/figma/new_home/cat_salads.svg'},
    {'name': 'Meals', 'icon': 'assets/images/figma/new_home/cat_meals.svg'},
    {'name': 'Meals', 'icon': 'assets/images/figma/new_home/cat_meals_2.svg'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return _CategoryItem(
            name: category['name']!,
            iconPath: category['icon']!,
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String name;
  final String iconPath;

  const _CategoryItem({
    required this.name,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to category
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.contain,
              placeholderBuilder: (context) => const Icon(
                Icons.restaurant,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 74,
            child: Text(
              name,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
