import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_text_field.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({
    super.key,
    required this.onBack,
    required this.onSuccess,
  });

  final VoidCallback onBack;
  final VoidCallback onSuccess;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final _cnicController = TextEditingController(text: '12345-1234567-1');

  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate 4 2 8 like in the prototype design
    _otpControllers[0].text = '4';
    _otpControllers[1].text = '2';
    _otpControllers[2].text = '8';
  }

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    _cnicController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    final code = _otpControllers.map((c) => c.text).join();
    final cnic = _cnicController.text.trim();

    final auth = context.read<AuthProvider>();
    final ok = await auth.verifyCnicAndOtp(
      otpCode: code.isNotEmpty ? code : '428000',
      cnic: cnic.isNotEmpty ? cnic : '12345-1234567-1',
    );

    if (ok && mounted) {
      setState(() => _isVerified = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 20),
              Text(
                'A little check-in.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Verify your phone and CNIC to build trust across the Riwaaj community.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                '6-DIGIT VERIFICATION CODE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 10),
              // OTP Boxes
              Row(
                children: List.generate(
                  6,
                  (i) => Expanded(
                    child: Container(
                      height: 52,
                      margin: EdgeInsets.only(right: i == 5 ? 0 : 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _otpControllers[i].text.isNotEmpty
                              ? AppColors.ink
                              : AppColors.border,
                        ),
                      ),
                      child: TextField(
                        controller: _otpControllers[i],
                        focusNode: _focusNodes[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) {
                          if (val.isNotEmpty && i < 5) {
                            _focusNodes[i + 1].requestFocus();
                          } else if (val.isEmpty && i > 0) {
                            _focusNodes[i - 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              CustomTextField(
                label: 'National Identity (CNIC)',
                hintText: '12345-1234567-1',
                controller: _cnicController,
                keyboardType: TextInputType.number,
              ),
              const Spacer(),
              if (!_isVerified)
                PrimaryButton(
                  text: 'Verify & continue',
                  isLoading: auth.isLoading,
                  onPressed: _handleVerify,
                )
              else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.sage,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: AppColors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Verified Profile ✓',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: 'Continue to Riwaaj',
                  onPressed: widget.onSuccess,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
