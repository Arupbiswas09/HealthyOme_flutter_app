/// General app constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Healthy-O-Me';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Healthy eating made easy';

  // Hive Box Names
  static const String mealsBox = 'meals';
  static const String cartBox = 'cart';
  static const String userBox = 'user';
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';

  // Secure Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';

  // SharedPreferences Keys
  static const String isOnboardedKey = 'is_onboarded';
  static const String isLoggedInKey = 'is_logged_in';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String notificationsKey = 'notifications_enabled';

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 1);
  static const Duration mealsCacheDuration = Duration(minutes: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int phoneNumberLength = 10;
  static const int otpLength = 6;
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxAddressLength = 200;

  // OTP
  static const int otpResendSeconds = 60;
  static const int otpExpiryMinutes = 10;

  // Bowl Builder Limits
  static const int maxBowlIngredients = 10;
  static const int maxBowlDressings = 2;
  static const int maxBowlProteins = 3;

  // Cart Limits
  static const int maxCartItems = 50;
  static const int maxItemQuantity = 10;

  // Support
  static const String supportPhone = '+91-9876543210';
  static const String supportEmail = 'support@healthyome.com';
  static const String supportWhatsapp = '+919876543210';

  // Social Links
  static const String instagramUrl = 'https://instagram.com/healthyome';
  static const String facebookUrl = 'https://facebook.com/healthyome';
  static const String twitterUrl = 'https://twitter.com/healthyome';

  // Legal Links
  static const String privacyPolicyUrl = 'https://healthyome.com/privacy';
  static const String termsUrl = 'https://healthyome.com/terms';
  static const String refundPolicyUrl = 'https://healthyome.com/refund';

  // Currency
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';

  // Date Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';
  static const String timeFormat = 'hh:mm a';
  static const String apiDateFormat = 'yyyy-MM-dd';

  // Ingredient Types
  static const List<String> ingredientTypes = [
    'base',
    'veggie',
    'protein',
    'dressing',
    'seeds_nuts',
    'gravy',
  ];

  // Meal Categories
  static const List<String> mealCategories = [
    'All',
    'Veg',
    'Non-Veg',
    'Egg',
  ];

  // Order Statuses
  static const String orderStatusPending = 'pending';
  static const String orderStatusConfirmed = 'confirmed';
  static const String orderStatusPreparing = 'preparing';
  static const String orderStatusOutForDelivery = 'out_for_delivery';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';
}
