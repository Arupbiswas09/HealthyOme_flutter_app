import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

/// Hive storage initialization and management
class HiveStorage {
  HiveStorage._();

  static bool _initialized = false;

  /// Initialize Hive and register adapters
  static Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Register adapters here when models are created
    // Example:
    // if (!Hive.isAdapterRegistered(0)) {
    //   Hive.registerAdapter(MealModelAdapter());
    // }

    // Open boxes
    await Future.wait([
      Hive.openBox(AppConstants.mealsBox),
      Hive.openBox(AppConstants.cartBox),
      Hive.openBox(AppConstants.userBox),
      Hive.openBox(AppConstants.settingsBox),
      Hive.openBox(AppConstants.cacheBox),
    ]);

    _initialized = true;
  }

  /// Get a Hive box
  static Box<dynamic> getBox(String name) => Hive.box(name);

  /// Get meals box
  static Box<dynamic> get mealsBox => getBox(AppConstants.mealsBox);

  /// Get cart box
  static Box<dynamic> get cartBox => getBox(AppConstants.cartBox);

  /// Get user box
  static Box<dynamic> get userBox => getBox(AppConstants.userBox);

  /// Get settings box
  static Box<dynamic> get settingsBox => getBox(AppConstants.settingsBox);

  /// Get cache box
  static Box<dynamic> get cacheBox => getBox(AppConstants.cacheBox);

  /// Clear all data
  static Future<void> clearAll() async {
    await Future.wait([
      mealsBox.clear(),
      cartBox.clear(),
      userBox.clear(),
      cacheBox.clear(),
    ]);
  }

  /// Clear cache only
  static Future<void> clearCache() async {
    await Future.wait([
      mealsBox.clear(),
      cacheBox.clear(),
    ]);
  }

  /// Close all boxes
  static Future<void> close() async {
    await Hive.close();
    _initialized = false;
  }
}
