import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';

/// Bowl Builder Screen - Build custom bowl
class BowlBuilderScreen extends StatefulWidget {
  const BowlBuilderScreen({super.key});

  @override
  State<BowlBuilderScreen> createState() => _BowlBuilderScreenState();
}

class _BowlBuilderScreenState extends State<BowlBuilderScreen> {
  String? _selectedBase;
  final Set<String> _selectedVeggies = {};
  final Set<String> _selectedProteins = {};
  final Set<String> _selectedSeeds = {};

  final _bases = ['Brown Rice', 'Quinoa', 'Mixed Greens', 'Soba Noodles'];
  final _veggies = ['Cucumber', 'Tomato', 'Avocado', 'Corn', 'Carrot', 'Beans'];
  final _proteins = ['Grilled Chicken', 'Tofu', 'Paneer', 'Boiled Egg'];
  final _seeds = ['Chia Seeds', 'Pumpkin Seeds', 'Flax Seeds', 'Walnuts'];

  double get _total => 99 + 
      (_selectedBase != null ? 50 : 0) + 
      (_selectedVeggies.length * 20) + 
      (_selectedProteins.length * 40) + 
      (_selectedSeeds.length * 15);

  @override
  Widget build(BuildContext context) {
    // Light orange background from React design #FDE6C6
    const backgroundColor = Color(0xFFFDE6C6);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
              child: Row(
                children: [
                   IconButton(
                     icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                     onPressed: () => context.pop(),
                   ),
                   const Text(
                     'Make your own Bowl',
                     style: TextStyle(
                       fontSize: 20,
                       fontWeight: FontWeight.w600,
                       color: AppColors.textPrimary,
                     ),
                   ),
                ],
              ),
            ),

            // Scrollable Sections
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    // Mock Bowl Preview (Placeholder for image/visualization)
                    Container(
                      height: 200,
                      margin: const EdgeInsets.all(AppSpacing.md),
                      alignment: Alignment.center,
                      child: Image.asset(
                         'assets/images/make-your-own-bowl.webp',
                         fit: BoxFit.contain,
                         errorBuilder: (_,__,___) => const Icon(Icons.rice_bowl, size: 80, color: Colors.orange),
                      ),
                    ),

                    // Options Container - Rounded Top
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(
                            title: 'Base',
                            options: _bases,
                            selected: _selectedBase != null ? {_selectedBase!} : {},
                            onSelect: (item) => setState(() => _selectedBase = item),
                            isSingle: true,
                          ),
                          const Divider(height: 32),
                          _buildSection(
                            title: 'Veggies',
                            options: _veggies,
                            selected: _selectedVeggies,
                            onSelect: (item) => setState(() {
                              _selectedVeggies.contains(item) 
                                ? _selectedVeggies.remove(item) 
                                : _selectedVeggies.add(item);
                            }),
                          ),
                          const Divider(height: 32),
                          _buildSection(
                            title: 'Protein',
                            options: _proteins,
                            selected: _selectedProteins,
                            onSelect: (item) => setState(() {
                              _selectedProteins.contains(item) 
                                ? _selectedProteins.remove(item) 
                                : _selectedProteins.add(item);
                            }),
                          ),
                          const Divider(height: 32),
                           _buildSection(
                            title: 'Seeds & Nuts',
                            options: _seeds,
                            selected: _selectedSeeds,
                            onSelect: (item) => setState(() {
                              _selectedSeeds.contains(item) 
                                ? _selectedSeeds.remove(item) 
                                : _selectedSeeds.add(item);
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Footer
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Total Price', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        Text('₹${_total.toStringAsFixed(0)}', style: AppTypography.headline3.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _selectedBase != null 
                          ? () { 
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added Custom Bowl!'))); 
                              context.pop(); 
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> options,
    required Set<String> selected,
    required Function(String) onSelect,
    bool isSingle = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (isSingle) 
              const Text(' (Select 1)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return GestureDetector(
              onTap: () => onSelect(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryLight : Colors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
