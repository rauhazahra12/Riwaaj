import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/outfit_model.dart';
import '../../providers/outfit_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/outfit_card.dart';

class SavedLooksScreen extends StatelessWidget {
  const SavedLooksScreen({
    super.key,
    required this.onBack,
    required this.onExplore,
    required this.onOutfitTap,
  });

  final VoidCallback onBack;
  final VoidCallback onExplore;
  final ValueChanged<OutfitModel> onOutfitTap;

  @override
  Widget build(BuildContext context) {
    final outfitProvider = context.watch<OutfitProvider>();
    final savedOutfits = outfitProvider.savedOutfits;

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: onBack,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'the maybe pile',
                style: GoogleFonts.alexBrush(
                  fontSize: 26,
                  color: AppColors.red,
                ),
              ),
              Text(
                'Saved looks',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${savedOutfits.length} outfits saved for your next main-character moment.',
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 18),

              Expanded(
                child: savedOutfits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.favorite_border,
                              size: 54,
                              color: AppColors.red,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Your dream rack starts here.',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Save wedding outfits, lehengas, and sarees to review anytime.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.muted, fontSize: 13),
                            ),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              text: 'Explore the wardrobe',
                              onPressed: onExplore,
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        itemCount: savedOutfits.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemBuilder: (context, index) {
                          final outfit = savedOutfits[index];
                          return OutfitCard(
                            outfit: outfit,
                            onTap: () => onOutfitTap(outfit),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
