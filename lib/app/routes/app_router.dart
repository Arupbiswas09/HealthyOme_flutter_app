import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../../presentation/features/home/view/home_screen.dart';
import '../../presentation/features/menu/view/menu_screen.dart';
import '../../presentation/features/subscription/view/subscription_screen.dart';
import '../../presentation/features/subscription/view/active_subscriptions_screen.dart';
import '../../presentation/features/orders/view/orders_screen.dart';
import '../../presentation/features/orders/view/order_detail_screen.dart';
import '../../presentation/features/profile/view/profile_screen.dart';
import '../../presentation/features/cart/view/cart_screen.dart';
import '../../presentation/features/bowl_builder/view/bowl_builder_screen.dart';
import '../../presentation/features/checkout/view/checkout_screen.dart';
import '../../presentation/features/rewards/view/rewards_screen.dart';
import '../../presentation/common/navigation/main_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter configuration - matches web app navigation structure
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.homePath,
  debugLogDiagnostics: true,
  routes: [
    // Shell route for bottom navigation (Home, Menu, Orders, Profile)
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        // Home
        GoRoute(
          path: AppRoutes.homePath,
          name: AppRoutes.home,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        // Menu
        GoRoute(
          path: AppRoutes.menuPath,
          name: AppRoutes.menu,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MenuScreen(),
          ),
        ),
        // Orders
        GoRoute(
          path: AppRoutes.ordersPath,
          name: AppRoutes.orders,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: OrdersScreen(),
          ),
          routes: [
            GoRoute(
              path: ':orderId',
              name: AppRoutes.orderDetail,
              builder: (context, state) {
                final orderId = state.pathParameters['orderId']!;
                return OrderDetailScreen(orderId: orderId);
              },
            ),
          ],
        ),
        // Profile
        GoRoute(
          path: AppRoutes.profilePath,
          name: AppRoutes.profile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
          routes: [
            GoRoute(
              path: 'edit',
              name: AppRoutes.editProfile,
              builder: (context, state) => const ProfileScreen(), // TODO: Replace with EditProfileScreen
            ),
            GoRoute(
              path: 'addresses',
              name: AppRoutes.addresses,
              builder: (context, state) => const ProfileScreen(), // TODO: Replace with AddressesScreen
            ),
            GoRoute(
              path: 'support',
              name: AppRoutes.support,
              builder: (context, state) => const ProfileScreen(), // TODO: Replace with SupportScreen
            ),
          ],
        ),
      ],
    ),
    
    // Non-shell routes (full screen without bottom nav - matches web app)
    
    // Subscription - full screen like web app
    GoRoute(
      path: AppRoutes.subscriptionPath,
      name: AppRoutes.subscription,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SubscriptionScreen(),
      routes: [
        GoRoute(
          path: 'detail/:planId',
          name: AppRoutes.subscriptionDetail,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            // TODO: Create SubscriptionDetailScreen
            return const SubscriptionScreen();
          },
        ),
        GoRoute(
          path: 'active',
          name: AppRoutes.activeSubscriptions,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const ActiveSubscriptionsScreen(),
        ),
      ],
    ),
    
    // Bowl Builder
    GoRoute(
      path: AppRoutes.bowlBuilderPath,
      name: AppRoutes.bowlBuilder,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BowlBuilderScreen(),
    ),
    
    // Cart
    GoRoute(
      path: AppRoutes.cartPath,
      name: AppRoutes.cart,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CartScreen(),
    ),
    
    // Checkout
    GoRoute(
      path: AppRoutes.checkoutPath,
      name: AppRoutes.checkout,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CheckoutScreen(),
    ),
    
    // Rewards
    GoRoute(
      path: AppRoutes.rewardsPath,
      name: AppRoutes.rewards,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RewardsScreen(),
    ),
    
    // Auth routes
    GoRoute(
      path: AppRoutes.loginPath,
      name: AppRoutes.login,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const HomeScreen(), // TODO: Replace with LoginScreen
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Page not found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            state.uri.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.homePath),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
