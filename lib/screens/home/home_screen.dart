import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/outfit_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/outfit_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/outfit_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onSearchTap,
    required this.onFilterTap,
    required this.onOutfitTap,
  });

  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;
  final ValueChanged<OutfitModel> onOutfitTap;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final outfitProvider = context.watch<OutfitProvider>();
    final outfits = outfitProvider.filteredOutfits;
    final firstName = auth.user?.name.split(' ').first ?? 'Ayesha';

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 95),
          children: [
            // Date Header
            const Text(
              'WEDDING SEASON 2026',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.6,
                fontWeight: FontWeight.bold,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 6),

            // Greeting
            Text(
              'Shaadi ready,\n$firstName?',
              style: GoogleFonts.playfairDisplay(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                height: 1.08,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar
            SearchInputField(
              readOnly: true,
              onTap: onSearchTap,
              onFilterTap: onFilterTap,
            ),
            const SizedBox(height: 14),

            // Category Chips Carousel
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: AppConstants.categories.map((cat) {
                  final isSelected = outfitProvider.selectedCategory == cat;
                  return CustomChip(
                    label: cat,
                    isSelected: isSelected,
                    onTap: () => outfitProvider.selectCategory(cat),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Wedding Season Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wedding season',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      'Good things are meant to be shared.',
                      style: GoogleFonts.alexBrush(
                        fontSize: 20,
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${outfits.length} looks',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Outfits Grid
            if (outfits.isEmpty)
              Container(
                height: 260,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.checkroom, size: 48, color: AppColors.mutedLight),
                    const SizedBox(height: 12),
                    const Text(
                      'No outfits found in this category.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => outfitProvider.selectCategory('All'),
                      child: const Text('View all looks'),
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: outfits.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemBuilder: (context, index) {
                  final outfit = outfits[index];
                  return OutfitCard(
                    outfit: outfit,
                    onTap: () => onOutfitTap(outfit),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
