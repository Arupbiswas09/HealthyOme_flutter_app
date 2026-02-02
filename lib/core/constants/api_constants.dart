/// API Constants for Healthy-O-Me Backend
class ApiConstants {
  ApiConstants._();

  /// Django backend API (same as web app). Override: --dart-define=API_BASE_URL=...
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dev.healthyome.com/api/shop',
  );
  
  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Endpoints - Meals
  static const String meals = '/meals/';
  static const String mealsFeatured = '/meals/featured/';
  static String mealById(int id) => '/meals/$id/';

  // Endpoints - Meal Plans
  static const String mealPlans = '/meal-plans/';
  
  // Endpoints - Subscriptions
  static const String subscriptionPlans = '/subscription-plans/';
  static const String subscriptions = '/subscriptions/';
  static const String activeSubscriptions = '/subscriptions/active/';
  
  // Endpoints - Bowl Builder
  static const String bowlBases = '/bowl-bases/';
  static const String bowlIngredients = '/bowl-ingredients/';
  static String bowlIngredientsByType(String type) => '/bowl-ingredients/?ingredient_type=$type';
  
  // Endpoints - Rewards
  static const String rewards = '/rewards/';
  static const String userPoints = '/user/points/';
  
  // Endpoints - Orders
  static const String orders = '/orders/';
  static String orderById(int id) => '/orders/$id/';
  static String orderByIdStr(String id) => '/orders/$id/';
  static String cancelOrder(int id) => '/orders/$id/cancel/';
  static String cancelOrderStr(String id) => '/orders/$id/cancel/';
  
  // Endpoints - Cart
  static const String cart = '/cart/';
  static const String cartItems = '/cart/items/';
  static const String checkout = '/checkout/';
  
  // Endpoints - Authentication
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String verifyOtp = '/auth/verify-otp/';
  static const String resendOtp = '/auth/resend-otp/';
  static const String refreshToken = '/auth/token/refresh/';
  static const String logout = '/auth/logout/';
  
  // Endpoints - User Profile
  static const String profile = '/user/profile/';
  static const String updateProfile = '/user/profile/update/';
  static const String addresses = '/user/addresses/';
  static String addressById(int id) => '/user/addresses/$id/';
  
  // Endpoints - Support
  static const String support = '/support/';
  static const String faq = '/support/faq/';
}
