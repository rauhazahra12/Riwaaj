import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/outfit_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.onOpenDashboard,
    required this.onOpenSaved,
    required this.onOpenBookings,
    required this.onLogout,
  });

  final VoidCallback onOpenDashboard;
  final VoidCallback onOpenSaved;
  final VoidCallback onOpenBookings;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final outfitProvider = context.watch<OutfitProvider>();
    final user = auth.user;
    final myListings = outfitProvider.allOutfits.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 95),
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.settings_outlined, color: AppColors.ink),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile and notification settings'),
                    ),
                  );
                },
              ),
            ),

            // Avatar
            Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: AppColors.pink,
                child: Text(
                  user?.avatarInitials ?? 'AK',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Name
            Center(
              child: Text(
                user?.name ?? 'Ayesha Khan',
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Verified Badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.sage,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.green, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '${user?.isVerified == true ? "Verified Member" : "Standard"} · ${user?.city ?? "Lahore"}',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Stats Row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statItem('${outfitProvider.allOutfits.length}', 'Listings'),
                  Container(width: 1, height: 32, color: AppColors.border),
                  _statItem('${user?.rentalsCount ?? 14}', 'Rentals'),
                  Container(width: 1, height: 32, color: AppColors.border),
                  _statItem('${user?.rating ?? 4.9} ★', 'Rating'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // My Listings Preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My listings',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  '${myListings.length} Active',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...myListings.map((outfit) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.blush,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.checkroom,
                        color: AppColors.red,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            outfit.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.ink,
                            ),
                          ),
                          Text(
                            '${Formatters.pkr(outfit.pricePerDay)}/day · Active',
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.mutedLight),
                  ],
                ),
              );
            }),

            const SizedBox(height: 18),

            // Menu Options
            _menuTile(
              Icons.store_mall_directory_outlined,
              'Boutique dashboard',
              'Manage your business, analytics & rack',
              onOpenDashboard,
            ),
            _menuTile(
              Icons.bookmark_outline,
              'Saved looks',
              '${outfitProvider.savedOutfits.length} looks in your maybe pile',
              onOpenSaved,
            ),
            _menuTile(
              Icons.calendar_month_outlined,
              'My bookings',
              'Rental timeline & outfit diary',
              onOpenBookings,
            ),
            _menuTile(
              Icons.logout,
              'Log out',
              '',
              onLogout,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _menuTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.red : AppColors.green,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDestructive ? AppColors.red : AppColors.ink,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              )
            : null,
        trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.mutedLight),
      ),
    );
  }
}
