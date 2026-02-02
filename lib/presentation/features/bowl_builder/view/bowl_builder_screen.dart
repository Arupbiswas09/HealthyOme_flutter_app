import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../domain/entities/bowl.dart';
import '../viewmodel/bowl_builder_viewmodel.dart';

/// Bowl Builder Screen - Build custom bowl using API data (MVVM compliant)
class BowlBuilderScreen extends ConsumerStatefulWidget {
  const BowlBuilderScreen({super.key});

  @override
  ConsumerState<BowlBuilderScreen> createState() => _BowlBuilderScreenState();
}

class _BowlBuilderScreenState extends ConsumerState<BowlBuilderScreen> {
  @override
  void initState() {
    super.initState();
    // Load data from API via ViewModel
    Future.microtask(() {
      ref.read(bowlBuilderViewModelProvider.notifier).loadBases();
      ref.read(bowlBuilderViewModelProvider.notifier).loadIngredients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bowlBuilderViewModelProvider);
    
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

            // Content Area
            Expanded(
              child: _buildContent(state),
            ),

            // Sticky Footer
            _buildFooter(state),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BowlBuilderState state) {
    // Show loading if bases are loading
    if (state.bases.isLoading || state.ingredients.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: AppSpacing.md),
            Text('Loading bowl options...', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    // Show error if any
    if (state.bases.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load bowl options',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: () {
                ref.read(bowlBuilderViewModelProvider.notifier).loadBases();
                ref.read(bowlBuilderViewModelProvider.notifier).loadIngredients();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final bases = state.bases.value ?? [];
    final allIngredients = state.ingredients.value ?? [];
    
    // Group ingredients by type
    final veggies = allIngredients.where((i) => i.type == IngredientType.veggie).toList();
    final proteins = allIngredients.where((i) => i.type == IngredientType.protein).toList();
    final seedsNuts = allIngredients.where((i) => i.type == IngredientType.seedsNuts).toList();
    final dressings = allIngredients.where((i) => i.type == IngredientType.dressing || i.type == IngredientType.gravy).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          // Bowl Preview Image
          Container(
            height: 200,
            margin: const EdgeInsets.all(AppSpacing.md),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/make-your-own-bowl.webp',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.rice_bowl, size: 80, color: Colors.orange),
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
                // Base Section
                _buildBaseSection(bases, state.selectedBase),
                const Divider(height: 32),
                
                // Veggies Section
                if (veggies.isNotEmpty) ...[
                  _buildIngredientSection(
                    title: 'Veggies',
                    ingredients: veggies,
                    selectedIngredients: state.selectedIngredients,
                  ),
                  const Divider(height: 32),
                ],
                
                // Protein Section
                if (proteins.isNotEmpty) ...[
                  _buildIngredientSection(
                    title: 'Protein',
                    ingredients: proteins,
                    selectedIngredients: state.selectedIngredients,
                  ),
                  const Divider(height: 32),
                ],
                
                // Seeds & Nuts Section
                if (seedsNuts.isNotEmpty) ...[
                  _buildIngredientSection(
                    title: 'Seeds & Nuts',
                    ingredients: seedsNuts,
                    selectedIngredients: state.selectedIngredients,
                  ),
                ],
                
                // Dressings Section
                if (dressings.isNotEmpty) ...[
                  const Divider(height: 32),
                  _buildIngredientSection(
                    title: 'Dressing & Gravy',
                    ingredients: dressings,
                    selectedIngredients: state.selectedIngredients,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaseSection(List<BowlBase> bases, BowlBase? selectedBase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('Base', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(' (Select 1)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Text(' *', style: TextStyle(color: AppColors.error, fontSize: 14)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: bases.map((base) {
            final isSelected = selectedBase?.id == base.id;
            return GestureDetector(
              onTap: () => ref.read(bowlBuilderViewModelProvider.notifier).setSelectedBase(base),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      base.name,
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+₹${base.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIngredientSection({
    required String title,
    required List<BowlIngredient> ingredients,
    required List<BowlIngredient> selectedIngredients,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ingredients.map((ingredient) {
            final isSelected = selectedIngredients.any((i) => i.id == ingredient.id);
            return GestureDetector(
              onTap: () => ref.read(bowlBuilderViewModelProvider.notifier).toggleIngredient(ingredient),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Veg/Non-veg indicator
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: ingredient.isVeg 
                            ? AppColors.vegBadge 
                            : ingredient.isEgg 
                                ? AppColors.eggBadge 
                                : AppColors.nonVegBadge,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      ingredient.name,
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+₹${ingredient.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFooter(BowlBuilderState state) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
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
                Text(
                  '₹${state.totalPrice.toStringAsFixed(0)}',
                  style: AppTypography.headline3.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: state.selectedBase != null
                  ? () {
                      // Add to cart functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Custom Bowl with ${state.selectedBase!.name} added to cart!',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      context.pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.border,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: const StadiumBorder(),
              ),
              child: const Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
