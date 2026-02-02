import 'package:equatable/equatable.dart';
import 'order.dart';

/// User Profile entity - Business logic representation
class UserProfile extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String? profileImageUrl;
  final DateTime? dateJoined;
  final List<DeliveryAddress> addresses;
  final int totalOrders;
  final int rewardPoints;
  final UserPreferences preferences;

  const UserProfile({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    this.profileImageUrl,
    this.dateJoined,
    this.addresses = const [],
    this.totalOrders = 0,
    this.rewardPoints = 0,
    this.preferences = const UserPreferences(),
  });

  /// Guest profile when /user/profile/ returns 404 (endpoint not yet available)
  static UserProfile get guest => const UserProfile(
        id: 0,
        name: 'Guest',
        phone: '',
      );

  /// Get default address
  DeliveryAddress? get defaultAddress {
    try {
      return addresses.firstWhere((a) => a.isDefault);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  /// Get display name (first name)
  String get firstName => name.split(' ').first;

  /// Get initials
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  /// Check if profile is complete
  bool get isComplete =>
      name.isNotEmpty && phone.isNotEmpty && email != null && addresses.isNotEmpty;

  /// Copy with method
  UserProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    DateTime? dateJoined,
    List<DeliveryAddress>? addresses,
    int? totalOrders,
    int? rewardPoints,
    UserPreferences? preferences,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateJoined: dateJoined ?? this.dateJoined,
      addresses: addresses ?? this.addresses,
      totalOrders: totalOrders ?? this.totalOrders,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        profileImageUrl,
        dateJoined,
        addresses,
        totalOrders,
        rewardPoints,
        preferences,
      ];
}

/// User Preferences entity
class UserPreferences extends Equatable {
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final String preferredLanguage;
  final DietaryPreference dietaryPreference;

  const UserPreferences({
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.smsNotifications = true,
    this.preferredLanguage = 'en',
    this.dietaryPreference = DietaryPreference.all,
  });

  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? smsNotifications,
    String? preferredLanguage,
    DietaryPreference? dietaryPreference,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
    );
  }

  @override
  List<Object?> get props => [
        notificationsEnabled,
        emailNotifications,
        smsNotifications,
        preferredLanguage,
        dietaryPreference,
      ];
}

/// Dietary Preference enum
enum DietaryPreference {
  all,
  veg,
  nonVeg,
  egg,
}

extension DietaryPreferenceExtension on DietaryPreference {
  String get displayName {
    switch (this) {
      case DietaryPreference.all:
        return 'All';
      case DietaryPreference.veg:
        return 'Vegetarian';
      case DietaryPreference.nonVeg:
        return 'Non-Vegetarian';
      case DietaryPreference.egg:
        return 'Eggetarian';
    }
  }
}
