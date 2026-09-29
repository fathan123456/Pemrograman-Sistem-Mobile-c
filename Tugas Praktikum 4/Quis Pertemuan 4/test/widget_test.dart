import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/screens/forgot_password_screen.dart';
import 'package:tokokita/screens/login_screen.dart';
import 'package:tokokita/screens/register_screen.dart';

void main() {
  testWidgets('Screen 1 (LoginScreen) memuat form login dan tombol navigasi', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AuthApp());

    // Verifikasi berada di LoginScreen
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Selamat Datang'), findsOneWidget);
    expect(find.text('Email / Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Masuk (Sign In)'), findsOneWidget);
    expect(find.text('Lupa Password?'), findsOneWidget);
    expect(find.text('Daftar Akun Baru (Sign Up)'), findsOneWidget);
  });

  testWidgets(
    'Navigasi dari LoginScreen ke ForgotPasswordScreen bekerja dengan baik',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const AuthApp());

      // Ketuk tombol 'Lupa Password?'
      final forgotBtn = find.text('Lupa Password?');
      expect(forgotBtn, findsOneWidget);
      await tester.tap(forgotBtn);
      await tester.pumpAndSettle();

      // Verifikasi berada di ForgotPasswordScreen
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      expect(find.text('Pemulihan Password'), findsOneWidget);
      expect(find.text('Email Terdaftar'), findsOneWidget);
      expect(find.text('Kirim Link Reset'), findsOneWidget);
    },
  );

  testWidgets(
    'Navigasi dari LoginScreen ke RegisterScreen (Sign Up) bekerja dengan baik',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const AuthApp());

      // Ketuk tombol 'Daftar Akun Baru (Sign Up)'
      final signUpBtn = find.text('Daftar Akun Baru (Sign Up)');
      expect(signUpBtn, findsOneWidget);
      await tester.ensureVisible(signUpBtn);
      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();

      // Verifikasi berada di RegisterScreen
      expect(find.byType(RegisterScreen), findsOneWidget);
      expect(find.text('Buat Akun Baru'), findsOneWidget);
      expect(find.text('Nama Lengkap'), findsOneWidget);
      expect(find.text('Alamat Email'), findsOneWidget);
      expect(find.text('Daftar Sekarang (Sign Up)'), findsOneWidget);
    },
  );
}
