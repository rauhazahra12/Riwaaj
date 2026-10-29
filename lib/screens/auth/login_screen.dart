import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onBack,
    required this.onSuccess,
    required this.onContinueWithPhone,
  });

  final VoidCallback onBack;
  final VoidCallback onSuccess;
  final VoidCallback onContinueWithPhone;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSignUp = false;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Test User');
  final _emailController = TextEditingController(text: 'testuser@riwaaj.com');
  final _passwordController = TextEditingController(text: 'Password123!');

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    bool ok;
    if (_isSignUp) {
      ok = await auth.signUp(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      ok = await auth.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }

    if (ok && mounted) {
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Form(
            key: _formKey,
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
                  'Your next look\nstarts here.',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 20),

                // Mode Selector (Log in / Sign up)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _tabButton('Log in', !_isSignUp, () {
                          setState(() => _isSignUp = false);
                        }),
                      ),
                      Expanded(
                        child: _tabButton('Sign up', _isSignUp, () {
                          setState(() => _isSignUp = true);
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (auth.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      auth.errorMessage!,
                      style: const TextStyle(color: AppColors.red, fontSize: 12),
                    ),
                  ),

                if (_isSignUp)
                  CustomTextField(
                    label: 'Full Name',
                    hintText: 'e.g. Ayesha Khan',
                    controller: _nameController,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Please enter your name' : null,
                  ),

                CustomTextField(
                  label: 'Email Address',
                  hintText: 'ayesha@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v == null || !v.contains('@') ? 'Enter a valid email' : null,
                ),

                CustomTextField(
                  label: 'Password',
                  hintText: 'At least 8 characters',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.muted,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
                ),

                const SizedBox(height: 28),

                PrimaryButton(
                  text: _isSignUp ? 'Create Account' : 'Continue',
                  isLoading: auth.isLoading,
                  onPressed: _submit,
                ),

                const SizedBox(height: 12),

                Center(
                  child: TextButton(
                    onPressed: widget.onContinueWithPhone,
                    child: const Text(
                      'Continue with phone →',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String text, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
