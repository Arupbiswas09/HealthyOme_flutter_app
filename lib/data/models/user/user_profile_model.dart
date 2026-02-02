import '../../../domain/entities/order.dart';
import '../../../domain/entities/user.dart';
import '../order/order_model.dart';

/// User profile data model (auth/profile API)
class UserProfileModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? profileImageUrl;
  final String? dateJoined;
  final List<dynamic>? addresses;
  final int? totalOrders;
  final int? rewardPoints;
  final Map<String, dynamic>? preferences;

  const UserProfileModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.profileImageUrl,
    this.dateJoined,
    this.addresses,
    this.totalOrders,
    this.rewardPoints,
    this.preferences,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profileImageUrl: json['profile_image_url'] as String? ?? json['avatar'] as String?,
      dateJoined: json['date_joined'] as String?,
      addresses: json['addresses'] as List<dynamic>?,
      totalOrders: json['total_orders'] as int?,
      rewardPoints: json['reward_points'] as int? ?? json['points'] as int?,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );
  }

  UserProfile toEntity() {
    final addrList = addresses ?? [];
    final addressEntities = addrList
        .map((e) => e is Map<String, dynamic>
            ? DeliveryAddressModel.fromJson(e).toEntity()
            : null)
        .whereType<DeliveryAddress>()
        .toList();
    return UserProfile(
      id: id,
      name: name,
      email: email,
      phone: phone ?? '',
      profileImageUrl: profileImageUrl,
      dateJoined: dateJoined != null ? DateTime.tryParse(dateJoined!) : null,
      addresses: addressEntities,
      totalOrders: totalOrders ?? 0,
      rewardPoints: rewardPoints ?? 0,
      preferences: _prefsToEntity(preferences),
    );
  }

  UserPreferences _prefsToEntity(Map<String, dynamic>? p) {
    if (p == null) return const UserPreferences();
    return UserPreferences(
      notificationsEnabled: p['notifications_enabled'] as bool? ?? true,
      emailNotifications: p['email_notifications'] as bool? ?? true,
      smsNotifications: p['sms_notifications'] as bool? ?? true,
      preferredLanguage: p['preferred_language'] as String? ?? 'en',
      dietaryPreference: _dietFromString(p['dietary_preference'] as String?),
    );
  }

  DietaryPreference _dietFromString(String? s) {
    switch (s?.toLowerCase()) {
      case 'veg': return DietaryPreference.veg;
      case 'non_veg': return DietaryPreference.nonVeg;
      case 'egg': return DietaryPreference.egg;
      default: return DietaryPreference.all;
    }
  }
}
