import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';

class BoutiqueDashboardScreen extends StatelessWidget {
  const BoutiqueDashboardScreen({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: onBack,
        ),
        title: const Text(
          'NOOR BOUTIQUE · LAHORE',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.4,
            fontWeight: FontWeight.bold,
            color: AppColors.muted,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(
              'Looking good,\nNoor.',
              style: GoogleFonts.playfairDisplay(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                height: 1.1,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 18),

            // Monthly Earnings Banner
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.green.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MONTHLY EARNINGS',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PKR 84,500',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.arrow_upward, color: Colors.white70, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '18% increase from last month',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Performance Metrics
            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    Icons.mark_chat_unread_outlined,
                    '12 requests',
                    '4 need replies',
                    AppColors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    Icons.visibility_outlined,
                    '2.8k views',
                    '↑ 24% this week',
                    AppColors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Your Rack Section
            Text(
              'Your rack',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 12),

            _rackItem('Ruby farshi lehenga', '12 rentals completed', 'Active · PKR 12.5k'),
            _rackItem('Ivory nikkah ensemble', '8 rentals completed', 'Active · PKR 9.5k'),
            _rackItem('Sunlit mayun lehenga', '5 rentals completed', 'Active · PKR 6.5k'),
            const SizedBox(height: 20),

            // Promote Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Be seen · Promote an outfit',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Get featured in the Wedding Season Edit and boost inquiries by up to 3.5×.',
                    style: TextStyle(color: AppColors.inkLight, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    text: 'Choose an outfit to promote',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selected outfit boosted to top search results!'),
                          backgroundColor: AppColors.green,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Plans
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Free: 15%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    'Silver: 10%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                  Text(
                    'Gold: 7%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _rackItem(String title, String rentals, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
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
            child: const Icon(Icons.checkroom, color: AppColors.red, size: 20),
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
                  rentals,
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            status,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}
