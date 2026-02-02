import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

/// Promo carousel for home screen
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  final List<_PromoItem> _promos = [
    _PromoItem(
      title: 'Get 20% Off',
      subtitle: 'On your first order',
      gradient: const LinearGradient(
        colors: [Color(0xFFFCE17B), Color(0xFFF9A825)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    _PromoItem(
      title: 'Free Delivery',
      subtitle: 'On orders above ₹499',
      gradient: const LinearGradient(
        colors: [Color(0xFFCDEFC4), Color(0xFF2C921D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    _PromoItem(
      title: 'Subscribe & Save',
      subtitle: 'Up to 30% off on subscriptions',
      gradient: const LinearGradient(
        colors: [Color(0xFFDBEAFE), Color(0xFF3B82F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _promos.length,
            itemBuilder: (context, index) {
              final promo = _promos[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: promo.gradient,
                    borderRadius: AppSpacing.borderRadiusLg,
                  ),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              promo.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              promo.subtitle,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppSpacing.borderRadiusFull,
                        ),
                        child: const Text(
                          'Claim',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _promos.length,
            (index) => AnimatedContainer(
              duration: AppSpacing.animationFast,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : AppColors.border,
                borderRadius: AppSpacing.borderRadiusFull,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoItem {
  final String title;
  final String subtitle;
  final LinearGradient gradient;

  _PromoItem({
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}
