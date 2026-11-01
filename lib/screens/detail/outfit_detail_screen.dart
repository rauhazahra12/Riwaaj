import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/outfit_model.dart';
import '../../providers/chat_provider.dart';
import '../../providers/outfit_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/dress_art.dart';

class OutfitDetailScreen extends StatefulWidget {
  const OutfitDetailScreen({
    super.key,
    required this.outfit,
    required this.onBack,
    required this.onBook,
    required this.onChat,
  });

  final OutfitModel outfit;
  final VoidCallback onBack;
  final ValueChanged<OutfitModel> onBook;
  final VoidCallback onChat;

  @override
  State<OutfitDetailScreen> createState() => _OutfitDetailScreenState();
}

class _OutfitDetailScreenState extends State<OutfitDetailScreen> {
  late String _selectedSize;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.outfit.availableSizes.isNotEmpty
        ? widget.outfit.availableSizes.first
        : 'M';
  }

  @override
  Widget build(BuildContext context) {
    final outfitProvider = context.watch<OutfitProvider>();
    final isFav = outfitProvider.isFavorite(widget.outfit.id);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Column(
          children: [
            // Top Image/Artwork Section with Back & Fav buttons
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.outfit.imageUrl != null)
                    Image.network(widget.outfit.imageUrl!, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => DressArt(index: widget.outfit.artIndex))
                  else if (widget.outfit.imageData != null)
                    Image.memory(base64Decode(widget.outfit.imageData!), fit: BoxFit.cover)
                  else if (widget.outfit.assetPath != null)
                    Image.asset(
                      widget.outfit.assetPath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => DressArt(index: widget.outfit.artIndex),
                    )
                  else
                    DressArt(index: widget.outfit.artIndex),
                  Positioned(
                    top: 14,
                    left: 16,
                    child: RoundIconButton(
                      icon: Icons.arrow_back_ios_new,
                      size: 42,
                      onPressed: widget.onBack,
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 16,
                    child: RoundIconButton(
                      icon: isFav ? Icons.favorite : Icons.favorite_border,
                      iconColor: isFav ? AppColors.red : AppColors.ink,
                      size: 42,
                      onPressed: () =>
                          outfitProvider.toggleFavorite(widget.outfit.id),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Details Body
            Expanded(
              flex: 6,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                children: [
                  // Subtitle & Designer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.outfit.subtitle.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.4,
                          color: AppColors.muted,
                        ),
                      ),
                      Text(
                        widget.outfit.designer,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    widget.outfit.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Pricing
                  Text(
                    '${Formatters.pkr(widget.outfit.pricePerDay)} / day · Refundable deposit ${Formatters.pkr(widget.outfit.deposit)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkLight,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Available Sizes
                  const Text(
                    'SELECT SIZE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: widget.outfit.availableSizes.map((s) {
                      final isSelected = _selectedSize == s;
                      return CustomChip(
                        label: s,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedSize = s),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    widget.outfit.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.inkLight,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Owner Info Card
                  _infoCard(
                    icon: Icons.verified_user_outlined,
                    iconColor: AppColors.green,
                    title: '${widget.outfit.ownerName} · Verified',
                    subtitle: '${widget.outfit.city} · ★ ${widget.outfit.ownerRating} (14+ reviews)',
                  ),

                  // Availability Card
                  _infoCard(
                    icon: Icons.calendar_month,
                    iconColor: AppColors.blue,
                    title: 'Availability',
                    subtitle: widget.outfit.availabilityRange,
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryOutlineButton(
                          text: 'Chat with owner',
                          icon: Icons.chat_bubble_outline,
                          onPressed: () async {
                            final chatProv = context.read<ChatProvider>();
                            await chatProv.startChatForOutfit(widget.outfit);
                            widget.onChat();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Request to rent',
                          icon: Icons.checkroom,
                          onPressed: () => widget.onBook(widget.outfit),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.mutedLight, size: 20),
        ],
      ),
    );
  }
}
