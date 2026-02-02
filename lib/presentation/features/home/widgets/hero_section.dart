import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';

/// Hero section for home screen - Redesigned to match Figma
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1B4D25), // Dark green from Figma reference
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.radiusXl),
          bottomRight: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern or Image (Optional)
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Row (Location + Cart)
              Padding(
                padding: AppSpacing.screenPadding.copyWith(
                  top: AppSpacing.lg, // Safe Area padding
                  bottom: AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Pune',
                              style: AppTypography.labelLarge.copyWith(color: Colors.white),
                            ),
                            const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 16),
                          ],
                        ),
                        Text(
                          'Address',
                          style: AppTypography.labelSmall.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                    
                    // Cart Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Main Hero Text
              Padding(
                padding: AppSpacing.screenPadding.copyWith(
                  bottom: 60, // Space for the carousel to overlap
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        'Healthy Eating,\nMade Effortless.',
                        style: AppTypography.headline1.copyWith(
                          color: Colors.white,
                          fontSize: 28, // Matches visual weight
                          height: 1.2,
                        ),
                      ),
                    ),
                    // Image placeholder - effectively hidden or decorative for now
                    // as it seems the main visual is the text + overlapping cards
                    const Expanded(flex: 4, child: SizedBox(height: 120)), 
                  ],
                ),
              ),
            ],
          ),
          
          // Decorative Food Image (Bottom Right)
          Positioned(
            right: -20,
            bottom: 20,
            child: Image.asset(
              'assets/images/salad-img.webp', // Using existing asset
              width: 140,
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (_,__,___) => const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

