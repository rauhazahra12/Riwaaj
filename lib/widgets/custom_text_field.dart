import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 6),
          ],
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.ink,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchInputField extends StatelessWidget {
  const SearchInputField({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.onFilterTap,
    this.readOnly = false,
    this.hintText = 'Search outfits, occasions, designers...',
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final bool readOnly;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: AppColors.ink),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search, color: AppColors.muted, size: 20),
        suffixIcon: onFilterTap != null
            ? IconButton(
                icon: const Icon(Icons.tune, color: AppColors.ink, size: 20),
                onPressed: onFilterTap,
              )
            : null,
      ),
    );
  }
}
