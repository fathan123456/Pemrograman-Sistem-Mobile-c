import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/custom_secondary_button.dart';
import '../widgets/custom_text_field.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

/// Screen 1: Tampilan Login (Sign In)
/// Menyediakan formulir masuk akun dengan navigasi ke Lupa Password dan Sign Up.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulasi proses autentikasi singkat
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login berhasil! Selamat datang.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Ikon Brand
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_person_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Judul & Subjudul
                  Text(
                    'Selamat Datang',
                    textAlign: TextAlign.center,
                    style: AppTypography.headingLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Silakan masukkan akun Anda untuk masuk',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 28),

                  // Form Login di dalam CustomCard
                  CustomCard(
                    padding: const EdgeInsets.all(22),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Input Email
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email / Username',
                            hintText: 'nama@email.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!val.contains('@')) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // Input Password
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hintText: 'Masukkan password Anda',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _isPasswordObscured,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordObscured = !_isPasswordObscured;
                                });
                              },
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              if (val.length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Tombol Lupa Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Lupa Password?',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Tombol Masuk (Primary Button)
                          CustomPrimaryButton(
                            text: 'Masuk (Sign In)',
                            icon: Icons.login_rounded,
                            isLoading: _isLoading,
                            onPressed: _handleLogin,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Pembatas / Garis Atau
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'Atau belum punya akun?',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Tombol Daftar / Sign Up (Secondary Button)
                  CustomSecondaryButton(
                    text: 'Daftar Akun Baru (Sign Up)',
                    icon: Icons.person_add_alt_1_rounded,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
