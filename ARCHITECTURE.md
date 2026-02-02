# Healthy-O-Me Flutter App - Architecture Guide

> **MVVM + Clean Architecture Implementation**
> 
> This document serves as the definitive guide for building and maintaining the Healthy-O-Me mobile application.
> All contributors (including AI) must follow this structure strictly.

---

## 🔒 Sticky: Data Flow & Conventions (Industry Best Practice)

**Dependency rule (Clean Architecture):**  
UI → ViewModel → Use case → Repository (interface) → Repository impl → Datasource.  
No UI or ViewModel must import datasources or models; only entities, use cases, and repository contracts.

- **Datasources:** Return raw data (or throw `ApiException`). No `Either`; keep single responsibility (fetch only).
- **Repository implementations:** Call datasource(s), map models → entities, catch `ApiException` and return `Left(e)`, success `Right(entity)`.
- **Use cases:** One class per action (e.g. `GetMeals`). Depend only on repository **interfaces**. Return `Future<Either<ApiException, T>>`.
- **ViewModels:** Depend only on use cases (via Riverpod). Expose state (e.g. `AsyncValue<List<Meal>>`); no BuildContext, no widgets.
- **DI:** Register in `app/di/providers.dart`: ApiClient → Datasources → Repository impls → Use cases → ViewModels. Use interfaces for repositories in use cases and viewmodels.
- **New features:** Add in this order: (1) data model + remote datasource, (2) repository impl, (3) use case(s), (4) providers, (5) viewmodel, (6) screen wiring.

---

## 📁 Project Structure Overview

```
lib/
├── main.dart                           # App entry point
├── app/                                # Application layer
│   ├── app.dart                        # MaterialApp configuration
│   ├── theme/                          # App theming
│   │   ├── app_theme.dart              # Theme data
│   │   ├── app_colors.dart             # Color constants
│   │   ├── app_typography.dart         # Text styles
│   │   └── app_spacing.dart            # Spacing constants
│   ├── routes/                         # Navigation
│   │   ├── app_routes.dart             # Route definitions
│   │   └── app_router.dart             # GoRouter configuration
│   └── di/                             # Dependency injection
│       └── service_locator.dart        # Riverpod providers setup
│
├── core/                               # Core utilities (shared)
│   ├── constants/                      # App-wide constants
│   │   ├── api_constants.dart          # API endpoints
│   │   ├── asset_constants.dart        # Asset paths
│   │   └── app_constants.dart          # General constants
│   ├── network/                        # Network layer
│   │   ├── api_client.dart             # Dio client configuration
│   │   ├── api_interceptors.dart       # Request/Response interceptors
│   │   ├── api_exception.dart          # Custom exceptions
│   │   └── network_info.dart           # Connectivity check
│   ├── storage/                        # Local storage
│   │   ├── secure_storage.dart         # Encrypted storage (tokens)
│   │   ├── hive_storage.dart           # Hive boxes configuration
│   │   └── preferences_storage.dart    # SharedPreferences wrapper
│   ├── utils/                          # Utility functions
│   │   ├── extensions/                 # Dart extensions
│   │   ├── helpers/                    # Helper functions
│   │   └── validators/                 # Input validators
│   └── widgets/                        # Shared widgets
│       ├── buttons/
│       ├── cards/
│       ├── inputs/
│       ├── dialogs/
│       └── loading/
│
├── data/                               # Data layer
│   ├── models/                         # Data models (JSON serializable)
│   │   ├── meal/
│   │   │   ├── meal_model.dart
│   │   │   └── meal_model.g.dart       # Generated
│   │   ├── subscription/
│   │   ├── bowl/
│   │   ├── order/
│   │   ├── reward/
│   │   └── user/
│   ├── datasources/                    # Data sources
│   │   ├── remote/                     # API data sources
│   │   │   ├── meals_remote_datasource.dart
│   │   │   ├── subscription_remote_datasource.dart
│   │   │   ├── bowl_remote_datasource.dart
│   │   │   ├── order_remote_datasource.dart
│   │   │   └── auth_remote_datasource.dart
│   │   └── local/                      # Local data sources
│   │       ├── meals_local_datasource.dart
│   │       ├── user_local_datasource.dart
│   │       └── cart_local_datasource.dart
│   └── repositories/                   # Repository implementations
│       ├── meals_repository_impl.dart
│       ├── subscription_repository_impl.dart
│       ├── bowl_repository_impl.dart
│       ├── order_repository_impl.dart
│       └── auth_repository_impl.dart
│
├── domain/                             # Domain layer (business logic)
│   ├── entities/                       # Business entities
│   │   ├── meal.dart
│   │   ├── subscription.dart
│   │   ├── bowl.dart
│   │   ├── order.dart
│   │   ├── reward.dart
│   │   └── user.dart
│   ├── repositories/                   # Repository contracts
│   │   ├── meals_repository.dart
│   │   ├── subscription_repository.dart
│   │   ├── bowl_repository.dart
│   │   ├── order_repository.dart
│   │   └── auth_repository.dart
│   └── usecases/                       # Use cases
│       ├── meals/
│       │   ├── get_meals.dart
│       │   ├── get_featured_meals.dart
│       │   └── get_meal_by_id.dart
│       ├── subscription/
│       │   ├── get_subscription_plans.dart
│       │   ├── subscribe_to_plan.dart
│       │   └── get_active_subscriptions.dart
│       ├── bowl/
│       │   ├── get_bowl_bases.dart
│       │   ├── get_bowl_ingredients.dart
│       │   └── create_custom_bowl.dart
│       ├── orders/
│       │   ├── get_orders.dart
│       │   ├── create_order.dart
│       │   └── cancel_order.dart
│       └── auth/
│           ├── login.dart
│           ├── register.dart
│           ├── logout.dart
│           └── get_current_user.dart
│
└── presentation/                       # Presentation layer (UI)
    ├── features/                       # Feature modules
    │   ├── home/                       # Home/Dashboard
    │   │   ├── view/
    │   │   │   └── home_screen.dart
    │   │   ├── viewmodel/
    │   │   │   └── home_viewmodel.dart
    │   │   └── widgets/
    │   │       ├── hero_section.dart
    │   │       ├── promo_carousel.dart
    │   │       ├── category_carousel.dart
    │   │       ├── featured_meal_card.dart
    │   │       └── consult_card.dart
    │   │
    │   ├── menu/                       # Menu/Meals
    │   │   ├── view/
    │   │   │   └── menu_screen.dart
    │   │   ├── viewmodel/
    │   │   │   └── menu_viewmodel.dart
    │   │   └── widgets/
    │   │       ├── menu_filter_bar.dart
    │   │       ├── meal_card.dart
    │   │       └── meal_detail_sheet.dart
    │   │
    │   ├── subscription/               # Subscription
    │   │   ├── view/
    │   │   │   ├── subscription_screen.dart
    │   │   │   ├── subscription_detail_screen.dart
    │   │   │   └── active_subscriptions_screen.dart
    │   │   ├── viewmodel/
    │   │   │   └── subscription_viewmodel.dart
    │   │   └── widgets/
    │   │       ├── plan_card.dart
    │   │       ├── period_selector.dart
    │   │       └── subscription_progress.dart
    │   │
    │   ├── bowl_builder/               # Custom Bowl
    │   │   ├── view/
    │   │   │   └── bowl_builder_screen.dart
    │   │   ├── viewmodel/
    │   │   │   └── bowl_builder_viewmodel.dart
    │   │   └── widgets/
    │   │       ├── base_selector.dart
    │   │       ├── ingredient_grid.dart
    │   │       └── bowl_summary.dart
    │   │
    │   ├── orders/                     # Orders
    │   │   ├── view/
    │   │   │   ├── orders_screen.dart
    │   │   │   └── order_detail_screen.dart
    │   │   ├── viewmodel/
    │   │   │   └── orders_viewmodel.dart
    │   │   └── widgets/
    │   │       ├── order_card.dart
    │   │       └── order_timeline.dart
    │   │
    │   ├── rewards/                    # Rewards
    │   │   ├── view/
    │   │   │   └── rewards_screen.dart
    │   │   ├── viewmodel/
    │   │   │   └── rewards_viewmodel.dart
    │   │   └── widgets/
    │   │       ├── reward_card.dart
    │   │       └── points_display.dart
    │   │
    │   ├── profile/                    # Profile
    │   │   ├── view/
    │   │   │   ├── profile_screen.dart
    │   │   │   ├── edit_profile_screen.dart
    │   │   │   ├── addresses_screen.dart
    │   │   │   └── support_screen.dart
    │   │   ├── viewmodel/
    │   │   │   └── profile_viewmodel.dart
    │   │   └── widgets/
    │   │
    │   ├── cart/                       # Cart
    │   │   ├── view/
    │   │   │   ├── cart_screen.dart
    │   │   │   └── checkout_screen.dart
    │   │   ├── viewmodel/
    │   │   │   └── cart_viewmodel.dart
    │   │   └── widgets/
    │   │       ├── cart_item_tile.dart
    │   │       └── cart_summary.dart
    │   │
    │   └── auth/                       # Authentication
    │       ├── view/
    │       │   ├── login_screen.dart
    │       │   ├── otp_screen.dart
    │       │   └── register_screen.dart
    │       ├── viewmodel/
    │       │   └── auth_viewmodel.dart
    │       └── widgets/
    │           ├── phone_input.dart
    │           └── otp_input.dart
    │
    └── common/                         # Common presentation utilities
        ├── navigation/
        │   └── bottom_nav_bar.dart
        └── state/
            └── async_state.dart
```

---

## 🎨 Design System

### Color Palette (Based on Website Design)

```dart
// lib/app/theme/app_colors.dart
class AppColors {
  // Primary Colors
  static const primary = Color(0xFF2C921D);        // Green
  static const primaryLight = Color(0xFFE8F5E9);   // Light Green
  static const primaryDark = Color(0xFF1B5E20);    // Dark Green
  
  // Secondary Colors  
  static const secondary = Color(0xFFFCE17B);      // Yellow
  static const secondaryLight = Color(0xFFFFF8E1);
  
  // Background Colors
  static const background = Color(0xFFFAFFF8);     // Off-white green
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF9FEF7);
  
  // Text Colors
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  
  // Border Colors
  static const border = Color(0xFFE6E6E3);
  static const borderLight = Color(0xFFF0F0F0);
  
  // Status Colors
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);
  
  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFFF9FEF7), Color(0xFFCDEFC4)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  static const secondaryGradient = LinearGradient(
    colors: [Color(0xFFFFFEFF), Color(0xFFFCE17B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
```

### Typography

```dart
// lib/app/theme/app_typography.dart
class AppTypography {
  static const fontFamily = 'Inter'; // Use Google Fonts
  
  static const headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: -0.017,
  );
  
  static const headline2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.1,
    letterSpacing: -0.0204,
  );
  
  static const headline3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.44,
    letterSpacing: -0.0227,
  );
  
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.57,
    letterSpacing: -0.029,
  );
  
  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );
  
  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
  );
  
  static const labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );
}
```

### Spacing Constants

```dart
// lib/app/theme/app_spacing.dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  
  // Screen padding
  static const screenPadding = EdgeInsets.symmetric(horizontal: 20.0);
  
  // Card radius
  static const radiusSm = 8.0;
  static const radiusMd = 12.0;
  static const radiusLg = 16.0;
  static const radiusXl = 24.0;
  
  // Bottom navigation height
  static const bottomNavHeight = 80.0;
}
```

---

## 🌐 API Integration

### Base Configuration

```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  static const baseUrl = 'https://dev.healthyome.com/api/shop';
  
  // Endpoints
  static const meals = '/meals/';
  static const mealsFeatured = '/meals/featured/';
  static const mealPlans = '/meal-plans/';
  static const subscriptionPlans = '/subscription-plans/';
  static const bowlBases = '/bowl-bases/';
  static const bowlIngredients = '/bowl-ingredients/';
  static const rewards = '/rewards/';
  static const orders = '/orders/';
  
  // Auth endpoints (to be added)
  static const login = '/auth/login/';
  static const register = '/auth/register/';
  static const verifyOtp = '/auth/verify-otp/';
}
```

### API Response Structure

```dart
// All API responses follow this paginated structure:
// {
//   "count": int,
//   "next": string | null,
//   "previous": string | null,
//   "results": T[]
// }
```

### Error Handling

```dart
// lib/core/network/api_exception.dart
sealed class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  const ApiException(this.message, [this.statusCode]);
}

class NetworkException extends ApiException {
  const NetworkException([String message = 'No internet connection']) : super(message);
}

class ServerException extends ApiException {
  const ServerException(super.message, [super.statusCode]);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException() : super('Session expired. Please login again.', 401);
}

class ValidationException extends ApiException {
  final Map<String, List<String>> errors;
  const ValidationException(this.errors) : super('Validation failed', 400);
}
```

---

## 📦 State Management (Riverpod + MVVM)

### ViewModel Pattern

```dart
// lib/presentation/features/menu/viewmodel/menu_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

@freezed
class MenuState with _$MenuState {
  const factory MenuState({
    @Default(AsyncValue.loading()) AsyncValue<List<Meal>> meals,
    @Default('all') String selectedFilter,
    @Default(false) bool isRefreshing,
  }) = _MenuState;
}

class MenuViewModel extends StateNotifier<MenuState> {
  final GetMeals _getMeals;
  
  MenuViewModel(this._getMeals) : super(const MenuState());
  
  Future<void> loadMeals() async {
    state = state.copyWith(meals: const AsyncValue.loading());
    
    final result = await _getMeals();
    result.fold(
      (failure) => state = state.copyWith(
        meals: AsyncValue.error(failure.message, StackTrace.current),
      ),
      (meals) => state = state.copyWith(
        meals: AsyncValue.data(meals),
      ),
    );
  }
  
  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }
}

// Provider
final menuViewModelProvider = StateNotifierProvider<MenuViewModel, MenuState>((ref) {
  return MenuViewModel(ref.read(getMealsProvider));
});
```

---

## 💾 Storage Strategy

### Local Storage Architecture

| Storage Type | Use Case | Implementation |
|-------------|----------|----------------|
| **Hive** | App data (meals cache, cart, user preferences) | `hive_flutter` |
| **Secure Storage** | Auth tokens, sensitive data | `flutter_secure_storage` |
| **SharedPreferences** | Simple flags, settings | `shared_preferences` |

### Hive Boxes

```dart
// lib/core/storage/hive_storage.dart
class HiveStorage {
  static const String mealsBox = 'meals';
  static const String cartBox = 'cart';
  static const String userBox = 'user';
  static const String settingsBox = 'settings';
  
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(MealModelAdapter());
    Hive.registerAdapter(CartItemModelAdapter());
    
    // Open boxes
    await Hive.openBox<MealModel>(mealsBox);
    await Hive.openBox<CartItemModel>(cartBox);
    await Hive.openBox(userBox);
    await Hive.openBox(settingsBox);
  }
}
```

---

## 🧭 Navigation (GoRouter)

```dart
// lib/app/routes/app_router.dart
final appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
  routes: [
    // Shell route for bottom navigation
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: AppRoutes.home,
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: '/menu',
          name: AppRoutes.menu,
          builder: (_, __) => const MenuScreen(),
        ),
        GoRoute(
          path: '/subscription',
          name: AppRoutes.subscription,
          builder: (_, __) => const SubscriptionScreen(),
          routes: [
            GoRoute(
              path: 'detail/:planId',
              name: AppRoutes.subscriptionDetail,
              builder: (_, state) => SubscriptionDetailScreen(
                planId: state.pathParameters['planId']!,
              ),
            ),
            GoRoute(
              path: 'active',
              name: AppRoutes.activeSubscriptions,
              builder: (_, __) => const ActiveSubscriptionsScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/orders',
          name: AppRoutes.orders,
          builder: (_, __) => const OrdersScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: AppRoutes.profile,
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),
    // Non-shell routes
    GoRoute(
      path: '/bowl-builder',
      name: AppRoutes.bowlBuilder,
      builder: (_, __) => const BowlBuilderScreen(),
    ),
    GoRoute(
      path: '/cart',
      name: AppRoutes.cart,
      builder: (_, __) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      name: AppRoutes.checkout,
      builder: (_, __) => const CheckoutScreen(),
    ),
    // Auth routes
    GoRoute(
      path: '/login',
      name: AppRoutes.login,
      builder: (_, __) => const LoginScreen(),
    ),
  ],
);
```

---

## 🏗️ Build Commands

```bash
# Generate JSON serialization code
dart run build_runner build --delete-conflicting-outputs

# Watch mode (during development)
dart run build_runner watch --delete-conflicting-outputs

# Run the app
flutter run

# Run on specific device
flutter run -d <device_id>

# Build for production
flutter build apk --release
flutter build ios --release
```

---

## 📋 Feature Implementation Checklist

### Phase 1: Foundation ✅
- [ ] Project structure setup
- [ ] Theme configuration
- [ ] Core utilities (network, storage)
- [ ] Navigation setup
- [ ] Dependency injection

### Phase 2: Core Features
- [ ] Home/Dashboard screen
- [ ] Menu screen with filters
- [ ] Cart functionality
- [ ] Bottom navigation

### Phase 3: Business Features
- [ ] Subscription plans
- [ ] Bowl builder
- [ ] Orders tracking
- [ ] Rewards system

### Phase 4: User Features
- [ ] Profile management
- [ ] Address management
- [ ] Support/Contact

### Phase 5: Authentication
- [ ] Phone/OTP login
- [ ] Session management
- [ ] Protected routes

---

## 🚨 Important Guidelines

### DO's
1. ✅ Follow the exact folder structure
2. ✅ Use `Equatable` for entities
3. ✅ Use `json_serializable` for models
4. ✅ Use `freezed` for state classes
5. ✅ Handle errors with Either (dartz) in use cases
6. ✅ Write unit tests for ViewModels and Use Cases
7. ✅ Use const constructors where possible
8. ✅ Follow mobile-first, responsive design

### DON'Ts
1. ❌ Don't mix data models with domain entities
2. ❌ Don't call repositories directly from UI
3. ❌ Don't hardcode strings - use constants
4. ❌ Don't skip error handling
5. ❌ Don't use BuildContext in ViewModels
6. ❌ Don't create massive files - split into widgets

---

## 📱 Screen Responsiveness

Use `LayoutBuilder` and `MediaQuery` for responsive design:

```dart
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  
  const ResponsiveBuilder({
    required this.mobile,
    this.tablet,
  });
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= 600 && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}
```

---

**Last Updated:** January 30, 2026  
**Version:** 1.0.0
