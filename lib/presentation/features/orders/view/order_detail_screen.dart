import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';

/// Order Detail Screen - Shows detailed information about a specific order
class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  
  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    // Mock order data - TODO: Replace with actual API call
    final order = {
      'id': orderId,
      'orderNumber': '#ORD-${orderId.padLeft(5, '0')}',
      'date': '2026-02-02',
      'status': 'Delivered',
      'total': 478.0,
      'items': [
        {'name': 'Grilled Chicken Salad', 'quantity': 1, 'price': 249.0, 'isVeg': false},
        {'name': 'Quinoa Buddha Bowl', 'quantity': 2, 'price': 199.0, 'isVeg': true},
      ],
      'deliveryAddress': 'Pune, Maharashtra',
      'deliveryFee': 30.0,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(order['orderNumber'] as String),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status', style: AppTypography.labelMedium),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: AppSpacing.borderRadiusSm,
                        ),
                        child: Text(
                          order['status'] as String,
                          style: const TextStyle(
                            color: AppColors.success,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Order Date: ${order['date']}',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Delivery Address: ${order['deliveryAddress']}',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Order Items
            Text('Order Items', style: AppTypography.headline3),
            const SizedBox(height: AppSpacing.md),
            
            ...(order['items'] as List).map((item) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  // Veg/Non-veg indicator
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: item['isVeg'] ? AppColors.vegBadge : AppColors.nonVegBadge,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] as String,
                          style: AppTypography.titleSmall,
                        ),
                        Text(
                          'Qty: ${item['quantity']}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${(item['price'] as double).toStringAsFixed(0)}',
                    style: AppTypography.priceMedium.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            )),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Price Breakdown
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal'),
                      Text('₹${((order['total'] as double) - (order['deliveryFee'] as double)).toStringAsFixed(0)}'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery Fee'),
                      Text('₹${(order['deliveryFee'] as double).toStringAsFixed(0)}'),
                    ],
                  ),
                  const Divider(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTypography.titleMedium),
                      Text(
                        '₹${(order['total'] as double).toStringAsFixed(0)}',
                        style: AppTypography.priceLarge.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Reorder Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reorder functionality coming soon!')),
                  );
                },
                child: const Text('Reorder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
