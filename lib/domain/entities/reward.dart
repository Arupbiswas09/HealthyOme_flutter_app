import 'package:equatable/equatable.dart';

/// Reward entity - Business logic representation
class Reward extends Equatable {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final int pointsRequired;
  final RewardType type;
  final double? discountAmount;
  final double? discountPercentage;
  final double? cashbackAmount;
  final bool isActive;

  const Reward({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.pointsRequired,
    required this.type,
    this.discountAmount,
    this.discountPercentage,
    this.cashbackAmount,
    this.isActive = true,
  });

  /// Get reward value description
  String get valueDescription {
    switch (type) {
      case RewardType.freeMeal:
        return 'Free Meal';
      case RewardType.discount:
        if (discountPercentage != null) {
          return '${discountPercentage!.toStringAsFixed(0)}% Off';
        }
        if (discountAmount != null) {
          return '₹${discountAmount!.toStringAsFixed(0)} Off';
        }
        return 'Discount';
      case RewardType.cashback:
        if (cashbackAmount != null) {
          return '₹${cashbackAmount!.toStringAsFixed(0)} Cashback';
        }
        return 'Cashback';
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        pointsRequired,
        type,
        discountAmount,
        discountPercentage,
        cashbackAmount,
        isActive,
      ];
}

/// Reward Type enum
enum RewardType {
  freeMeal,
  discount,
  cashback,
}

/// Extension for RewardType
extension RewardTypeExtension on RewardType {
  String get apiValue {
    switch (this) {
      case RewardType.freeMeal:
        return 'free_meal';
      case RewardType.discount:
        return 'discount';
      case RewardType.cashback:
        return 'cashback';
    }
  }

  static RewardType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'free_meal':
        return RewardType.freeMeal;
      case 'discount':
        return RewardType.discount;
      case 'cashback':
        return RewardType.cashback;
      default:
        return RewardType.discount;
    }
  }
}

/// User Points entity
class UserPoints extends Equatable {
  final int totalPoints;
  final int availablePoints;
  final int redeemedPoints;
  final List<PointTransaction> transactions;

  const UserPoints({
    required this.totalPoints,
    required this.availablePoints,
    required this.redeemedPoints,
    this.transactions = const [],
  });

  @override
  List<Object?> get props => [
        totalPoints,
        availablePoints,
        redeemedPoints,
        transactions,
      ];
}

/// Point Transaction entity
class PointTransaction extends Equatable {
  final int id;
  final int points;
  final TransactionType type;
  final String description;
  final DateTime date;

  const PointTransaction({
    required this.id,
    required this.points,
    required this.type,
    required this.description,
    required this.date,
  });

  @override
  List<Object?> get props => [id, points, type, description, date];
}

/// Transaction Type enum
enum TransactionType {
  earned,
  redeemed,
  expired,
}
