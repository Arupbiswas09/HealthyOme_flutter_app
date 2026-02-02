import 'package:flutter/material.dart';

/// Healthy-O-Me color palette
/// Based on the website design for consistency across platforms
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF2C921D);
  static const Color primaryLight = Color(0xFFE8F5E9);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primarySurface = Color(0xFFCDEFC4);

  // Secondary Colors
  static const Color secondary = Color(0xFFFCE17B);
  static const Color secondaryLight = Color(0xFFFFF8E1);
  static const Color secondaryDark = Color(0xFFF9A825);

  // Background Colors
  static const Color background = Color(0xFFFAFFF8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF9FEF7);
  static const Color scaffoldBackground = Color(0xFFFAFFF8);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFC5C5C5);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = Color(0xFFE6E6E3);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color divider = Color(0xFFE5E5E5);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Badge Colors
  static const Color vegBadge = Color(0xFF22C55E);
  static const Color nonVegBadge = Color(0xFFEF4444);
  static const Color eggBadge = Color(0xFFF59E0B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFF9FEF7), Color(0xFFCDEFC4)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFFFFEFF), Color(0xFFFCE17B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFF8FFF5), Color(0xFFE8F5E9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowMedium = Color(0x1A000000);
}
