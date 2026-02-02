import 'package:equatable/equatable.dart';

/// Order entity - Business logic representation
class Order extends Equatable {
  final String id;
  final DateTime date;
  final String? mealType;
  final String plan;
  final String title;
  final OrderStatus status;
  final DateTime? arrivalTime;
  final double? bill;
  final bool isCustomizable;
  final bool canReorder;
  final List<OrderItem> items;
  final DeliveryAddress? deliveryAddress;

  const Order({
    required this.id,
    required this.date,
    this.mealType,
    required this.plan,
    required this.title,
    required this.status,
    this.arrivalTime,
    this.bill,
    this.isCustomizable = false,
    this.canReorder = true,
    this.items = const [],
    this.deliveryAddress,
  });

  /// Check if order can be cancelled
  bool get canCancel =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  /// Check if order is completed
  bool get isCompleted => status == OrderStatus.delivered;

  /// Get formatted date
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Get formatted time
  String get formattedTime {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  List<Object?> get props => [
        id,
        date,
        mealType,
        plan,
        title,
        status,
        arrivalTime,
        bill,
        isCustomizable,
        canReorder,
        items,
        deliveryAddress,
      ];
}

/// Order Item entity
class OrderItem extends Equatable {
  final int id;
  final String name;
  final int quantity;
  final double price;
  final String? imageUrl;
  final List<String>? customizations;

  const OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imageUrl,
    this.customizations,
  });

  /// Get total price for this item
  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [
        id,
        name,
        quantity,
        price,
        imageUrl,
        customizations,
      ];
}

/// Delivery Address entity
class DeliveryAddress extends Equatable {
  final int id;
  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  /// Get full address string
  String get fullAddress {
    final parts = [
      addressLine1,
      if (addressLine2 != null) addressLine2,
      if (landmark != null) 'Near $landmark',
      '$city, $state - $pincode',
    ];
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [
        id,
        label,
        addressLine1,
        addressLine2,
        city,
        state,
        pincode,
        landmark,
        latitude,
        longitude,
        isDefault,
      ];
}

/// Order Status enum
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

/// Extension for OrderStatus
extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get apiValue {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.outForDelivery:
        return 'out_for_delivery';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'out_for_delivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
