import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/dress_art.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    super.key,
    required this.onFinish,
    required this.onSkip,
  });

  final VoidCallback onFinish;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: onSkip,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Central art container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.pink,
                    borderRadius: BorderRadius.circular(150),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: CustomPaint(
                      painter: DressPainter(color: AppColors.blue),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Rent the wow,\nskip the cost.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Access curated bridal couture, lehengas, sarees, and sherwanis from top designers and verified lenders across Pakistan.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Let’s go',
                onPressed: onFinish,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
