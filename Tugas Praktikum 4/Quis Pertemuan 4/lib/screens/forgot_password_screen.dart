import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/custom_secondary_button.dart';
import '../widgets/custom_text_field.dart';

/// Screen 2: Tampilan Lupa Password (Forgot Password)
/// Memungkinkan pengguna memasukkan email untuk menerima instruksi reset password.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        // Dialog sukses pengiriman
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: const [
                Icon(Icons.mark_email_read_rounded,
                    color: AppColors.success, size: 28),
                SizedBox(width: 10),
                Text('Email Terkirim'),
              ],
            ),
            content: Text(
              'Tautan reset password telah dikirim ke ${_emailController.text.trim()}. Silakan periksa kotak masuk atau spam email Anda.',
              style: AppTypography.bodyMedium,
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context); // Kembali ke LoginScreen
                },
                child: const Text('OK, Kembali ke Login'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Lupa Password',
        subtitle: 'Atur ulang kata sandi akun',
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
                  // Ikon Pemulihan Akun
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        size: 34,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Judul & Deskripsi
                  Text(
                    'Pemulihan Password',
                    textAlign: TextAlign.center,
                    style: AppTypography.headingLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan alamat email yang terdaftar. Kami akan mengirimkan link untuk membuat password baru.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Form di dalam CustomCard
                  CustomCard(
                    padding: const EdgeInsets.all(22),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email Terdaftar',
                            hintText: 'contoh@email.com',
                            prefixIcon: Icons.alternate_email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!val.contains('@')) {
                                return 'Masukkan format email yang benar';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 22),
                          CustomPrimaryButton(
                            text: 'Kirim Link Reset',
                            icon: Icons.send_rounded,
                            isLoading: _isLoading,
                            onPressed: _handleResetPassword,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tombol Kembali
                  CustomSecondaryButton(
                    text: 'Kembali ke Halaman Login',
                    icon: Icons.arrow_back_rounded,
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
