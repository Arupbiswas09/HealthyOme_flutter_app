import '../../../domain/entities/reward.dart';

/// Reward data model for JSON serialization
class RewardModel {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final int pointsRequired;
  final String rewardType;
  final String? discountAmount;
  final double? discountPercentage;
  final String? cashbackAmount;
  final bool? isActive;

  const RewardModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.pointsRequired,
    required this.rewardType,
    this.discountAmount,
    this.discountPercentage,
    this.cashbackAmount,
    this.isActive,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      pointsRequired: json['points_required'] as int,
      rewardType: json['reward_type'] as String,
      discountAmount: json['discount_amount']?.toString(),
      discountPercentage: (json['discount_percentage'] as num?)?.toDouble(),
      cashbackAmount: json['cashback_amount']?.toString(),
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image_url': imageUrl,
    'points_required': pointsRequired,
    'reward_type': rewardType,
    'discount_amount': discountAmount,
    'discount_percentage': discountPercentage,
    'cashback_amount': cashbackAmount,
    'is_active': isActive,
  };

  Reward toEntity() {
    return Reward(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      pointsRequired: pointsRequired,
      type: RewardTypeExtension.fromString(rewardType),
      discountAmount: discountAmount != null ? double.tryParse(discountAmount!) : null,
      discountPercentage: discountPercentage,
      cashbackAmount: cashbackAmount != null ? double.tryParse(cashbackAmount!) : null,
      isActive: isActive ?? true,
    );
  }
}
