import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';

/// Promo carousel matching web app design
class PromoCarousel extends StatelessWidget {
  const PromoCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160, // Increased height to prevent overflow
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          _PromoCard(
            title: '20% off 1st order, up to \$10',
            description: 'Get upto 20% off on your first order with code GET20OFF',
            backgroundColor: Color(0xFFDFF4F4),
            buttonColor: Color(0xFF0099A3),
            buttonTextColor: Colors.white,
            imagePath: 'assets/images/discount-img1.webp',
          ),
          SizedBox(width: 16),
          _PromoCard(
            title: '20% off 1st order, up to \$10',
            description: 'Get upto 20% off on your first order with code GET20OFF',
            backgroundColor: Color(0xFFFFF5CD),
            buttonColor: Color(0xFFF5CD31),
            buttonTextColor: Colors.black,
            imagePath: 'assets/images/discount-img2.webp',
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final String imagePath;

  const _PromoCard({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16), // Adjusted padding
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: buttonTextColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Learn more',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: buttonTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Image
          Image.asset(
            imagePath,
            width: 90, // Slightly reduced width
            height: 90,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                width: 90,
                height: 90,
                child: Icon(
                  Icons.local_offer,
                  color: buttonColor.withOpacity(0.5),
                  size: 40,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
