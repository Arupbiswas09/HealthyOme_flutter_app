import '../../../domain/entities/order.dart';

/// Order data model
class OrderModel {
  final dynamic id;
  final String? date;
  final String? mealType;
  final String? plan;
  final String? title;
  final String? status;
  final String? arrivalTime;
  final dynamic bill;
  final bool? isCustomizable;
  final bool? canReorder;
  final List<dynamic>? items;
  final Map<String, dynamic>? deliveryAddress;

  const OrderModel({
    required this.id,
    this.date,
    this.mealType,
    this.plan,
    this.title,
    this.status,
    this.arrivalTime,
    this.bill,
    this.isCustomizable,
    this.canReorder,
    this.items,
    this.deliveryAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      date: json['date'] as String?,
      mealType: json['meal_type'] as String?,
      plan: json['plan'] as String?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      arrivalTime: json['arrival_time'] as String?,
      bill: json['bill'],
      isCustomizable: json['is_customizable'] as bool?,
      canReorder: json['can_reorder'] as bool?,
      items: json['items'] as List<dynamic>?,
      deliveryAddress: json['delivery_address'] as Map<String, dynamic>?,
    );
  }

  Order toEntity() {
    final itemList = items ?? [];
    final orderItems = itemList
        .map((e) => e is Map<String, dynamic>
            ? OrderItemModel.fromJson(e).toEntity()
            : null)
        .whereType<OrderItem>()
        .toList();
    return Order(
      id: id.toString(),
      date: DateTime.tryParse(date ?? '') ?? DateTime.now(),
      mealType: mealType,
      plan: plan ?? '',
      title: title ?? '',
      status: OrderStatusExtension.fromString(status ?? 'pending'),
      arrivalTime: arrivalTime != null ? DateTime.tryParse(arrivalTime!) : null,
      bill: bill != null ? _num(bill) : null,
      isCustomizable: isCustomizable ?? false,
      canReorder: canReorder ?? true,
      items: orderItems,
      deliveryAddress: deliveryAddress != null
          ? DeliveryAddressModel.fromJson(deliveryAddress!).toEntity()
          : null,
    );
  }

  double? _num(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}

/// Order item data model
class OrderItemModel {
  final int id;
  final String name;
  final int quantity;
  final dynamic price;
  final String? imageUrl;
  final List<String>? customizations;

  const OrderItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imageUrl,
    this.customizations,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      price: json['price'],
      imageUrl: json['image_url'] as String?,
      customizations: (json['customizations'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  OrderItem toEntity() {
    return OrderItem(
      id: id,
      name: name,
      quantity: quantity,
      price: price != null ? _num(price) : 0,
      imageUrl: imageUrl,
      customizations: customizations,
    );
  }

  double _num(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }
}

/// Delivery address data model
class DeliveryAddressModel {
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
  final bool? isDefault;

  const DeliveryAddressModel({
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
    this.isDefault,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
      id: json['id'] as int,
      label: json['label'] as String? ?? 'Home',
      addressLine1: json['address_line1'] as String? ?? json['address_line_1'] as String? ?? '',
      addressLine2: json['address_line2'] as String? ?? json['address_line_2'] as String?,
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      pincode: json['pincode'] as String? ?? json['zip'] as String? ?? '',
      landmark: json['landmark'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isDefault: json['is_default'] as bool?,
    );
  }

  DeliveryAddress toEntity() {
    return DeliveryAddress(
      id: id,
      label: label,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      pincode: pincode,
      landmark: landmark,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault ?? false,
    );
  }
}
