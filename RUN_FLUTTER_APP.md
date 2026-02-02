# Build & Run Healthy-O-Me Flutter App

## Prerequisites

- **Flutter SDK** (3.3+): `flutter doctor -v` should show ✓ for Android, iOS, Chrome.
- **Android**: Android Studio with SDK and an AVD (emulator) or physical device.
- **iOS**: Xcode and iOS Simulator (or physical device with Apple Developer account).

## Quick run

```bash
cd /Users/arup/Desktop/HealthyOme/Healthy-o-me-futter-app
flutter pub get
flutter devices
```

Then run on a specific device:

```bash
# iOS Simulator (e.g. iPhone 16e)
flutter run -d <ios_device_id>

# Android Emulator (start emulator first)
flutter emulators --launch InboApp_Minimal   # or your AVD name
flutter run -d <android_device_id>

# Chrome (fastest for local testing)
flutter run -d chrome
```

## Android

1. **List emulators:** `flutter emulators`
2. **Launch Android emulator:**  
   - From terminal: `flutter emulators --launch <emulator_id>` (e.g. `InboApp_Minimal`).  
   - If the emulator exits with code 1, open **Android Studio → Device Manager** and start an AVD from there, or create a new Virtual Device (e.g. Pixel 6, API 34).
3. **Run app:** `flutter run` (picks device automatically) or `flutter run -d <device_id>`.
4. **Debug APK:** `flutter build apk --debug`  
   Output: `build/app/outputs/flutter-apk/app-debug.apk`  
   (First build can take several minutes while Gradle downloads dependencies.)

## iOS

1. **Open in Xcode (for signing):**  
   Open `ios/Runner.xcworkspace` in Xcode → select **Runner** target → **Signing & Capabilities** → choose your **Team** (Personal Team is fine for simulator).
2. **Run on simulator:** `flutter run -d <ios_simulator_id>`  
   Example: `flutter run -d D2EC91CE-648B-4C08-B3D4-D22C3230CBA9` (iPhone 16e).
3. **If you see CodeSign error** (“resource fork, Finder information, or similar detritus not allowed”):
   - Clean and strip extended attributes on Flutter SDK and project:
     ```bash
     flutter clean
     xattr -cr .
     xattr -cr /opt/homebrew/share/flutter   # or your Flutter install path
     flutter pub get
     flutter run -d <ios_device_id>
     ```
   - Or build/run from **Xcode** (Runner.xcworkspace) once so signing is applied, then use `flutter run` again.

See also **IOS_SIGNING_FIX.md** for detailed signing steps.

## Web (Chrome)

```bash
flutter run -d chrome
```

## Tests

```bash
flutter test
```

## Summary of fixes applied in this project

- **Test:** `test/widget_test.dart` updated to use `HealthyOmeApp` + `ProviderScope` (removed `MyApp`).
- **Router:** Unused `planId` / `orderId` in `app_router.dart` removed to clear analyzer warnings.
- **Assets:** `pubspec.yaml` assets uncommented; `assets/images/` added with placeholders (`subscription-img.png`, `quick-meal.png`) so home screen images load.
- **iOS Podfile:** `platform :ios, '13.0'` set for Xcode 26 compatibility.
