import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/dress_art.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    required this.onEnter,
    required this.onLogin,
  });

  final VoidCallback onEnter;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Dress Illustration
            Positioned.fill(
              child: CustomPaint(
                painter: DressPainter(color: AppColors.blue),
              ),
            ),

            // Soft Blush Circle Accent
            Positioned(
              left: -60,
              top: 260,
              child: Container(
                width: 270,
                height: 320,
                decoration: BoxDecoration(
                  color: AppColors.pink.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(140),
                ),
              ),
            ),

            // Tagline Header
            const Positioned(
              left: 24,
              top: 36,
              child: Text(
                'THE WARDROBE, REIMAGINED',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
            ),

            // Riwaaj Brand Title
            Positioned(
              left: 20,
              top: 68,
              child: Text(
                'Riwaaj',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -4,
                  color: AppColors.ink,
                ),
              ),
            ),

            // Cursive Sub-Tagline
            Positioned(
              left: 110,
              top: 146,
              child: Text(
                'wear a story',
                style: GoogleFonts.alexBrush(
                  fontSize: 34,
                  color: AppColors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Bottom CTA Section
            Positioned(
              left: 24,
              right: 24,
              bottom: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Wear the wow.\nNot the bill.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.15,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Enter the wardrobe',
                    onPressed: onEnter,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onLogin,
                    child: const Text(
                      'Already a member? Log in',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
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
}
