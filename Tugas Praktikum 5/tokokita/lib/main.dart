import 'package:flutter/material.dart';
import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';

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
      // Langkah 5 Butir 7: Jadikan MainPage sebagai halaman awal aplikasi
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/detail': (context) => const ProductDetailPage(),
      },
    );
  }
}
