import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../../presentation/features/home/view/home_screen.dart';
import '../../presentation/features/menu/view/menu_screen.dart';
import '../../presentation/features/subscription/view/subscription_screen.dart';
import '../../presentation/features/orders/view/orders_screen.dart';
import '../../presentation/features/profile/view/profile_screen.dart';
import '../../presentation/features/cart/view/cart_screen.dart';
import '../../presentation/features/bowl_builder/view/bowl_builder_screen.dart';
import '../../presentation/features/rewards/view/rewards_screen.dart';
import '../../presentation/common/navigation/main_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter configuration
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.homePath,
  debugLogDiagnostics: true,
  routes: [
    // Shell route for bottom navigation
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
        // Subscription
        GoRoute(
          path: AppRoutes.subscriptionPath,
          name: AppRoutes.subscription,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SubscriptionScreen(),
          ),
          routes: [
            GoRoute(
              path: 'detail/:planId',
              name: AppRoutes.subscriptionDetail,
              builder: (context, state) {
                return SubscriptionScreen(); // TODO: Replace with SubscriptionDetailScreen(planId: state.pathParameters['planId']!)
              },
            ),
            GoRoute(
              path: 'active',
              name: AppRoutes.activeSubscriptions,
              builder: (context, state) => const SubscriptionScreen(), // TODO: Replace with ActiveSubscriptionsScreen
            ),
          ],
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
                return OrdersScreen(); // TODO: Replace with OrderDetailScreen(orderId: state.pathParameters['orderId']!)
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
    // Non-shell routes (full screen)
    GoRoute(
      path: AppRoutes.bowlBuilderPath,
      name: AppRoutes.bowlBuilder,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BowlBuilderScreen(),
    ),
    GoRoute(
      path: AppRoutes.cartPath,
      name: AppRoutes.cart,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: AppRoutes.checkoutPath,
      name: AppRoutes.checkout,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CartScreen(), // TODO: Replace with CheckoutScreen
    ),
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
