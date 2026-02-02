import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/routes/app_routes.dart';

/// Checkout Screen - Handles order checkout and payment
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'card';
  String _selectedAddress = 'home';

  @override
  Widget build(BuildContext context) {
    // Mock cart data - TODO: Get from cart state
    const subtotal = 647.0;
    const deliveryFee = 30.0;
    const total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Checkout'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address Section
                  Text('Delivery Address', style: AppTypography.headline3),
                  const SizedBox(height: AppSpacing.md),
                  _buildAddressCard(
                    id: 'home',
                    label: 'Home',
                    address: 'Pune, Maharashtra, 411001',
                    isSelected: _selectedAddress == 'home',
                    onTap: () => setState(() => _selectedAddress = 'home'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildAddressCard(
                    id: 'work',
                    label: 'Work',
                    address: 'Mumbai, Maharashtra, 400001',
                    isSelected: _selectedAddress == 'work',
                    onTap: () => setState(() => _selectedAddress = 'work'),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Payment Method Section
                  Text('Payment Method', style: AppTypography.headline3),
                  const SizedBox(height: AppSpacing.md),
                  _buildPaymentMethodCard(
                    id: 'card',
                    icon: Icons.credit_card,
                    label: 'Credit/Debit Card',
                    isSelected: _selectedPaymentMethod == 'card',
                    onTap: () => setState(() => _selectedPaymentMethod = 'card'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildPaymentMethodCard(
                    id: 'upi',
                    icon: Icons.account_balance_wallet,
                    label: 'UPI',
                    isSelected: _selectedPaymentMethod == 'upi',
                    onTap: () => setState(() => _selectedPaymentMethod = 'upi'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildPaymentMethodCard(
                    id: 'cod',
                    icon: Icons.money,
                    label: 'Cash on Delivery',
                    isSelected: _selectedPaymentMethod == 'cod',
                    onTap: () => setState(() => _selectedPaymentMethod = 'cod'),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Order Summary
                  Text('Order Summary', style: AppTypography.headline3),
                  const SizedBox(height: AppSpacing.md),
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
                            Text('₹${subtotal.toStringAsFixed(0)}'),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee'),
                            Text('₹${deliveryFee.toStringAsFixed(0)}'),
                          ],
                        ),
                        const Divider(height: AppSpacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: AppTypography.titleMedium),
                            Text(
                              '₹${total.toStringAsFixed(0)}',
                              style: AppTypography.priceLarge.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Place Order Button
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Process payment and place order
                    _showOrderSuccessDialog(context);
                  },
                  child: const Text('Place Order'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required String id,
    required String label,
    required String address,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.titleSmall),
                  const SizedBox(height: 4),
                  Text(address, style: AppTypography.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String id,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
            ),
            const SizedBox(width: AppSpacing.md),
            Icon(icon, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.md),
            Text(label, style: AppTypography.titleSmall),
          ],
        ),
      ),
    );
  }

  void _showOrderSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Order Placed Successfully!',
              style: AppTypography.headline3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your order has been confirmed and will be delivered soon.',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // Close dialog
              context.go(AppRoutes.ordersPath); // Navigate to orders
            },
            child: const Text('View Orders'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop(); // Close dialog
              context.go(AppRoutes.homePath); // Navigate to home
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
