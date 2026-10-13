import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';

void main() {
  runApp(const TokoKitaApp());
}

/// Widget root aplikasi TokoKita (Langkah 1: Menggunakan GetMaterialApp)
class TokoKitaApp extends StatelessWidget {
  const TokoKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TokoKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Langkah 1 Butir 2: Menggunakan GetMaterialApp untuk integrasi GetX
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MainPage()),
        GetPage(name: '/detail', page: () => const ProductDetailPage()),
      ],
    );
  }
}
