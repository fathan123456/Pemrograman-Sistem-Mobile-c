import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Sistem tipografi utama aplikasi untuk menjamin konsistensi teks
class AppTypography {
  // Heading / Judul
  static const TextStyle headingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.25,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  // Body / Konten Teks
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // Button Style
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.2,
  );

  // Label & Kategori
  static const TextStyle badgeText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );
}
