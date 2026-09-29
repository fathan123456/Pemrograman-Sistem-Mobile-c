import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const AuthApp());
}

/// Widget root aplikasi Autentikasi (Login, Forgot Password, Sign Up)
class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Autentikasi Pengguna',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
        ),
      ),
      // Halaman awal aplikasi adalah Login Screen (Sign In)
      home: const LoginScreen(),
    );
  }
}
