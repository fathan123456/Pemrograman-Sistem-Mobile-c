import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/custom_secondary_button.dart';
import '../widgets/custom_text_field.dart';

/// Screen 3: Tampilan Sign Up / Daftar Akun Baru
/// Formulir pembuatan akun baru dengan validasi nama, email, dan konfirmasi kata sandi.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isConfirmObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan masuk.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Kembali ke layar Login
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Daftar Akun',
        subtitle: 'Buat akun baru untuk mulai',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Ikon Daftar
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 34,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Judul & Subjudul
                  Text(
                    'Buat Akun Baru',
                    textAlign: TextAlign.center,
                    style: AppTypography.headingLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Lengkapi data di bawah untuk mendaftar',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Card Formulir Pendaftaran
                  CustomCard(
                    padding: const EdgeInsets.all(22),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Nama Lengkap
                          CustomTextField(
                            controller: _nameController,
                            label: 'Nama Lengkap',
                            hintText: 'Misal: Budi Santoso',
                            prefixIcon: Icons.person_outline_rounded,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Nama lengkap tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // 2. Email
                          CustomTextField(
                            controller: _emailController,
                            label: 'Alamat Email',
                            hintText: 'budi@email.com',
                            prefixIcon: Icons.mail_outline_rounded,
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
                          const SizedBox(height: 16),

                          // 3. Password
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hintText: 'Minimal 6 karakter',
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
                                return 'Password wajib diisi';
                              }
                              if (val.length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // 4. Konfirmasi Password
                          CustomTextField(
                            controller: _confirmPasswordController,
                            label: 'Konfirmasi Password',
                            hintText: 'Ulangi password di atas',
                            prefixIcon: Icons.lock_clock_outlined,
                            obscureText: _isConfirmObscured,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmObscured = !_isConfirmObscured;
                                });
                              },
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Konfirmasi password wajib diisi';
                              }
                              if (val != _passwordController.text) {
                                return 'Konfirmasi password tidak cocok';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 22),

                          // Tombol Daftar
                          CustomPrimaryButton(
                            text: 'Daftar Sekarang (Sign Up)',
                            icon: Icons.check_circle_outline_rounded,
                            isLoading: _isLoading,
                            onPressed: _handleRegister,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tombol Sudah Punya Akun (Kembali ke Login)
                  CustomSecondaryButton(
                    text: 'Sudah Punya Akun? Masuk',
                    icon: Icons.login_rounded,
                    onPressed: () => Navigator.pop(context),
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
