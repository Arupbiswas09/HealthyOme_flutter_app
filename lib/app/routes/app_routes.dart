/// Route names for the app
class AppRoutes {
  AppRoutes._();

  // Main navigation
  static const String home = 'home';
  static const String menu = 'menu';
  static const String subscription = 'subscription';
  static const String orders = 'orders';
  static const String profile = 'profile';

  // Sub-routes
  static const String subscriptionDetail = 'subscription-detail';
  static const String activeSubscriptions = 'active-subscriptions';
  static const String bowlBuilder = 'bowl-builder';
  static const String cart = 'cart';
  static const String checkout = 'checkout';
  static const String orderDetail = 'order-detail';
  static const String rewards = 'rewards';
  
  // Profile sub-routes
  static const String editProfile = 'edit-profile';
  static const String addresses = 'addresses';
  static const String support = 'support';
  static const String settings = 'settings';

  // Auth routes
  static const String login = 'login';
  static const String otp = 'otp';
  static const String register = 'register';
  static const String onboarding = 'onboarding';

  // Paths
  static const String homePath = '/';
  static const String menuPath = '/menu';
  static const String subscriptionPath = '/subscription';
  static const String ordersPath = '/orders';
  static const String profilePath = '/profile';
  static const String bowlBuilderPath = '/bowl-builder';
  static const String cartPath = '/cart';
  static const String checkoutPath = '/checkout';
  static const String rewardsPath = '/rewards';
  static const String loginPath = '/login';
  static const String onboardingPath = '/onboarding';
}
