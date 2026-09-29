import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Custom Widget untuk Tombol Sekunder (Secondary / Outlined Button)
/// Digunakan untuk aksi sekunder seperti 'Batal', 'Kembali', atau aksi alternatif.
class CustomSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double height;

  const CustomSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.textColor,
    this.borderColor,
    this.width = double.infinity,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? AppColors.primary;
    final effectiveBorderColor = borderColor ?? AppColors.border;

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveTextColor,
          backgroundColor: Colors.white,
          side: BorderSide(color: effectiveBorderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: effectiveTextColor),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                style: AppTypography.buttonSecondary.copyWith(
                  color: effectiveTextColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
