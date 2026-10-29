import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/outfit_model.dart';
import '../providers/outfit_provider.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import 'dress_art.dart';
import 'custom_buttons.dart';

class OutfitCard extends StatelessWidget {
  const OutfitCard({
    super.key,
    required this.outfit,
    required this.onTap,
  });

  final OutfitModel outfit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final outfitProvider = context.watch<OutfitProvider>();
    final isFav = outfitProvider.isFavorite(outfit.id);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image / Art Container
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DressArt(index: outfit.artIndex),
                  if (outfit.isPromoted)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.ink.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'FEATURED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: RoundIconButton(
                      icon: isFav ? Icons.favorite : Icons.favorite_border,
                      iconColor: isFav ? AppColors.red : AppColors.ink,
                      size: 34,
                      elevation: 1,
                      onPressed: () => outfitProvider.toggleFavorite(outfit.id),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            outfit.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.ink,
            ),
          ),
          // Price
          Text(
            '${Formatters.pkr(outfit.pricePerDay)} / day',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          // City & size tag
          Text(
            '✦ ${outfit.city} · ${outfit.availableSizes.join(', ')}',
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
