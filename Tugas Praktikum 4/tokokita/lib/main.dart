import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const TokoKitaApp());
}

/// Widget root aplikasi TokoKita
class TokoKitaApp extends StatelessWidget {
  const TokoKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Langkah 5 Butir 3: Jadikan HomePage sebagai halaman utama aplikasi (home pada MaterialApp)
      home: const HomePage(),
    );
  }
}
