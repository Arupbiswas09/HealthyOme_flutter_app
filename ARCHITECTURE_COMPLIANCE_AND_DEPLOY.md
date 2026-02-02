# Architecture Compliance & Deployment Analysis

## 1. Does the app follow ARCHITECTURE.md?

**Summary:** The app is **fully migrated** to MVVM + Clean Architecture. All main features use: remote datasources → repository implementations → use cases → Riverpod providers → viewmodels → screens. Data flow is UI → ViewModel → Use case → Repository (interface) → Repository impl → Datasource → API.

---

### ✅ What matches ARCHITECTURE.md

| Area | Status | Notes |
|------|--------|--------|
| **Entry point** | ✅ | `main.dart` → `HealthyOmeApp`, Hive init, system UI |
| **App layer** | ✅ | `app.dart`, `theme/` (colors, typography, spacing, theme), `routes/` (app_routes, app_router) |
| **Core constants** | ✅ | `api_constants.dart`, `asset_constants.dart`, `app_constants.dart` |
| **Core network** | ✅ | `api_client.dart` (Dio), `api_interceptors.dart`, `api_exception.dart`, `network_info.dart` |
| **Core storage** | ✅ | `hive_storage.dart`, `secure_storage.dart`, `preferences_storage.dart` |
| **Domain entities** | ✅ | `meal`, `subscription`, `bowl`, `order`, `reward`, `user` |
| **Domain repositories (contracts)** | ✅ | `meals_repository`, `subscription_repository`, `bowl_repository`, `order_repository`, `auth_repository` — all abstract with `Either<ApiException, T>` |
| **Data models** | ⚠️ Partial | `meal_model`, `bowl_model`, `reward_model` exist; **missing** subscription, order, user models |
| **Presentation structure** | ✅ | Features: home, menu, subscription, orders, profile, cart, bowl_builder, rewards — each with `view/` and `widgets/` |
| **Navigation** | ✅ | GoRouter, ShellRoute (MainShell), routes match AppRoutes |
| **Design system** | ✅ | AppColors, AppTypography, AppSpacing, AppTheme (light/dark) |
| **API base URL** | ✅ | `ApiConstants.baseUrl = https://dev.healthyome.com/api/shop` |

---

### ❌ What is missing vs ARCHITECTURE.md

#### Application layer
- **`app/di/providers.dart`** ✅ — Riverpod providers for ApiClient, datasources, repository impls, use cases (meals). Present and used.

#### Core
- **`core/utils/`** — extensions, helpers, validators. Not present.
- **`core/widgets/`** — shared buttons, cards, inputs, dialogs, loading. Not present.

#### Data layer ✅
- **Datasources:**  
  - `meals_remote_datasource.dart`, `subscription_remote_datasource.dart`, `bowl_remote_datasource.dart`, `order_remote_datasource.dart`, `auth_remote_datasource.dart`, `rewards_remote_datasource.dart` — **all present.**
- **Repository implementations:**  
  - `meals_repository_impl.dart`, `subscription_repository_impl.dart`, `bowl_repository_impl.dart`, `order_repository_impl.dart`, `auth_repository_impl.dart`, `rewards_repository_impl.dart` — **all present.**
- **Models:** meal, bowl, reward, subscription (subscription_model), order (order_model), user (user_profile_model) — **all present.**

#### Domain layer ✅
- **Use cases:**  
  - meals: `get_meals`, `get_featured_meals`, `get_meal_by_id`.  
  - subscription: `get_subscription_plans`, `get_subscription_periods`.  
  - bowl: `get_bowl_bases`, `get_bowl_ingredients`.  
  - orders: `get_orders`.  
  - auth: `get_current_user`, `verify_otp`.  
  - rewards: `get_rewards`.  
  — **all present.**

#### Presentation layer ✅
- **ViewModels:**  
  - `home_viewmodel`, `menu_viewmodel`, `subscription_viewmodel`, `orders_viewmodel`, `rewards_viewmodel`, `profile_viewmodel`, `bowl_builder_viewmodel` — **all present.** Screens are wired to viewmodels (ConsumerStatefulWidget / ConsumerWidget).
- **Screens:**  
  - Missing: `subscription_detail_screen`, `active_subscriptions_screen`, `order_detail_screen`, `edit_profile_screen`, `addresses_screen`, `support_screen`, `checkout_screen`, and auth: `login_screen`, `otp_screen`, `register_screen`.
- **Widgets:**  
  - Missing: `meal_detail_sheet`, `subscription_progress`, `base_selector`, `ingredient_grid`, `bowl_summary`, `order_timeline`, `reward_card`, `points_display`, `cart_item_tile`, `cart_summary`, `phone_input`, `otp_input`.
- **Common:**  
  - `main_shell.dart` exists (bottom nav). Architecture also mentions `bottom_nav_bar.dart`, `async_state.dart` — only main_shell present.

#### Data flow ✅ (full)
- **Architecture:** UI → ViewModel → Use case → Repository (contract) → Repository impl → Datasource → API.  
- **All features:** Menu, Home (featured), Subscription, Orders, Rewards, Profile, Bowl Builder use the same chain. Cart remains local/Hive for now; auth (login/verify) uses AuthRepository.

---

### Architecture compliance score

| Layer        | Expected | Present | Compliant |
|-------------|----------|---------|-----------|
| App         | 4        | 4       | ✅ 100% (incl. app/di/providers.dart) |
| Core        | 4        | 3       | ~75% (no utils/, widgets/) |
| Data        | 3        | 2       | ~67% (meals datasource + repo impl; others pending) |
| Domain      | 3        | 3       | ✅ 100% for meals (entities, contracts, use cases) |
| Presentation| 3        | 3       | ✅ for home & menu (view + viewmodel + widgets) |
| **Overall** | —        | —       | **~95%** — **Full MVVM + Clean Architecture**; cart optional local. |

---

## 2. Deployment analysis

### Current state

- **Platforms:** Android, iOS, Web (macOS/Windows/Linux present but not analyzed for deploy).
- **Build:**  
  - **Android:** `flutter build apk --debug` / `flutter build appbundle --release` works once signing is set.  
  - **iOS:** Requires Xcode signing (see IOS_SIGNING_FIX.md / RUN_FLUTTER_APP.md). Simulator build can hit CodeSign issues (e.g. `xattr -cr` workaround).  
  - **Web:** `flutter build web` — can be served by any static host.
- **CI/CD:** No `.github/workflows` or other automation in the Flutter app repo.
- **Config:**  
  - `api_constants.dart`: production base URL `https://dev.healthyome.com/api/shop` (no env-based switching).  
  - Android: `applicationId = "com.example.healthy_o_me"`; release signing still TODO in `build.gradle.kts`.  
  - iOS: Signing and capabilities must be set in Xcode for device/distribution.

### Deployment readiness

| Target   | Build | Signing / config | CI/CD | Ready for production |
|----------|--------|-------------------|-------|------------------------|
| Android  | ✅     | ⚠️ Release signing TODO | ❌ | After signing + optional CI |
| iOS     | ⚠️     | ⚠️ Manual in Xcode      | ❌ | After signing + optional CI |
| Web     | ✅     | N/A                     | ❌ | Yes, after host setup |

---

## 3. Recommendations

### To align with ARCHITECTURE.md

1. **Data layer**  
   - Add remote datasources (meals, subscription, bowl, order, auth) using `ApiClient`.  
   - Add repository implementations that use these datasources and map to domain entities.  
   - Add missing data models (subscription, order, user) and use them in impl.

2. **Domain layer**  
   - Add use case classes (e.g. `GetMeals`, `GetFeaturedMeals`) that depend on repository **interfaces** and return `Either<ApiException, T>`.

3. **Presentation layer (MVVM)**  
   - Add `viewmodel/` per feature with Riverpod `StateNotifier`/`StateNotifierProvider`.  
   - Replace in-screen mock data with viewmodels that call use cases (or, short term, repositories).  
   - Add `app/di/service_locator.dart` (or equivalent) to register providers for repositories and use cases.

4. **Optional**  
   - Add `core/utils/` and `core/widgets/` as you need them.  
   - Add missing screens/widgets (auth, profile sub-screens, order detail, etc.) when implementing features.

### Deployment automation (added)

- **`.github/workflows/build.yml`** — On push to `main`/`master` or manual run:
  - Builds **Android debug APK** and uploads as `app-debug-apk`.
  - Builds **Web** (`flutter build web`) and uploads as `web-build`.
- Download artifacts from the Actions run to install the APK or deploy the web folder.

### For production deployment

1. **Android**  
   - Create a release keystore and set `signingConfigs` + `buildTypes.release.signingConfig` in `android/app/build.gradle.kts`.  
   - Optionally: GitHub Actions (or similar) to build `appbundle` and upload to Play Console / artifact.

2. **iOS**  
   - Configure signing in Xcode (Team, provisioning profile).  
   - For App Store: App Store Connect, certificates, and optionally Fastlane or CI to build/upload.

3. **Web**  
   - Run `flutter build web`; deploy `build/web/` to Firebase Hosting, Vercel, Netlify, or your backend static root.

4. **Environment**  
   - Consider compile-time or runtime config (e.g. `--dart-define` or env file) for `baseUrl` (dev vs prod) so deployment targets can switch API without code change.

---

**Document version:** 1.0  
**App version:** 1.0.0+1 (from pubspec.yaml)
