import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Custom Widget untuk Input Teks (Text Field)
/// Menstandarkan label di atas input, placeholder (hint), ikon, obscure text (password), dan validasi.
class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final bool obscureText;
  final VoidCallback? onTap;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.obscureText = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas form input
        Text(
          label,
          style: AppTypography.headingSmall.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan styling modern
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          obscureText: obscureText,
          onTap: onTap,
          validator: validator,
          keyboardType: keyboardType,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textSecondary, size: 20)
                : null,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.danger, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.danger, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}
