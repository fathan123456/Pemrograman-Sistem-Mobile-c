import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/main_page.dart';
import 'screens/order_history_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/wishlist_page.dart';
import 'services/order_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Langkah 3 Butir 3: Verifikasi database dan tabel berhasil dibuat tanpa error saat aplikasi dijalankan
  try {
    await OrderDatabase.instance.database;
    debugPrint('--> [main] Inisialisasi database SQLite dan tabel orders sukses tanpa error.');
  } catch (e) {
    debugPrint('--> [main] Error inisialisasi SQLite database: $e');
  }

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
        GetPage(name: '/wishlist', page: () => const WishlistPage()),
        GetPage(name: '/orders', page: () => const OrderHistoryPage()),
      ],
    );
  }
}
