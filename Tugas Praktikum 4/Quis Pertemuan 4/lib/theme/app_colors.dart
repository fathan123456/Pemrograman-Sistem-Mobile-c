import 'package:flutter/material.dart';

/// Palet warna utama aplikasi yang konsisten di seluruh layar
class AppColors {
  // Warna Utama (Brand)
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color primaryLight = Color(0xFFEEF2FF); // Indigo Soft
  static const Color primaryDark = Color(0xFF3730A3);

  // Warna Sekunder / Aksen
  static const Color secondary = Color(0xFF0EA5E9); // Sky Blue
  static const Color secondaryLight = Color(0xFFE0F2FE);

  // Warna Netral & Background
  static const Color background = Color(0xFFF8FAFC); // Slate 50 (Bersih & Modern)
  static const Color surface = Color(0xFFFFFFFF); // Card & Modal White
  static const Color border = Color(0xFFE2E8F0); // Slate 200

  // Warna Teks
  static const Color textPrimary = Color(0xFF1E293B); // Slate 800
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textWhite = Color(0xFFFFFFFF);

  // Warna Status
  static const Color success = Color(0xFF10B981); // Emerald (Selesai)
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B); // Amber (Deadline dekat)
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFEF4444); // Red (Hapus / Terlewat)
  static const Color dangerLight = Color(0xFFFEE2E2);
}
