import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

/// Halaman utama TokoKita yang menampilkan header kustom dan katalog produk dari API
class HomePage extends StatefulWidget {
  final Future<List<Product>>? productsFuture;

  const HomePage({super.key, this.productsFuture});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Ambil instance CartController menggunakan Get.find() pada HomePage
  final CartController cartController = Get.find<CartController>();

  // Langkah 4 Butir 1: Future untuk menampung pemanggilan fetchProducts()
  late Future<List<Product>> _productsFuture;

  // Kategori aktif untuk filter cepat
  String selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Memuat data produk pertama kali
  void _loadProducts() {
    setState(() {
      _productsFuture = widget.productsFuture ?? fetchProducts();
    });
  }

  // Fitur Segarkan Data (Pull-to-refresh / Tombol Refresh)
  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = widget.productsFuture ?? fetchProducts();
    });
    try {
      await _productsFuture;
    } catch (_) {
      // Ditangani oleh FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        toolbarHeight: 76,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'TokoKita',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Belanja jadi lebih mudah',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Tombol Refresh Cepat pada Header
            IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.deepPurple,
                size: 24,
              ),
              onPressed: _refreshProducts,
              tooltip: 'Segarkan Data Produk',
            ),
            // Badge Keranjang Belanja Reaktif dengan Obx
            Obx(() {
              final count = cartController.totalItem;
              return IconButton(
                icon: Badge(
                  isLabelVisible: count > 0,
                  label: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFFDC2626),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.deepPurple,
                    size: 26,
                  ),
                ),
                onPressed: () {
                  Get.to(() => const CartPage());
                },
                tooltip: 'Keranjang Belanja',
              );
            }),
          ],
        ),
      ),
      // Langkah 4 Butir 1: Menggunakan FutureBuilder untuk menampilkan data dari fetchProducts()
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // Langkah 4 Butir 3: Loading Indicator saat data masih dimuat
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memuat produk dari server...',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            );
          }

          // Langkah 5 Butir 2: Tampilan pesan error yang ramah pengguna apabila terjadi kesalahan
          if (snapshot.hasError) {
            final rawError = snapshot.error.toString();
            final isOffline = rawError.toLowerCase().contains('internet') ||
                rawError.toLowerCase().contains('koneksi') ||
                rawError.toLowerCase().contains('network') ||
                rawError.toLowerCase().contains('socket');

            final cleanErrorMsg = rawError.replaceFirst('Exception: ', '');

            return RefreshIndicator(
              color: Colors.deepPurple,
              onRefresh: _refreshProducts,
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isOffline
                                    ? const Color(0xFFFEF2F2)
                                    : const Color(0xFFFFFBEB),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isOffline
                                      ? const Color(0xFFFCA5A5)
                                      : const Color(0xFFFDE68A),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                isOffline
                                    ? Icons.wifi_off_rounded
                                    : Icons.error_outline_rounded,
                                color: isOffline
                                    ? const Color(0xFFDC2626)
                                    : const Color(0xFFD97706),
                                size: 54,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Gagal memuat produk, coba lagi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isOffline
                                  ? 'Tidak ada koneksi internet. Silakan periksa jaringan Wi-Fi atau data seluler Anda, lalu coba lagi.'
                                  : cleanErrorMsg,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF64748B),
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Tarik ke bawah atau tekan tombol di bawah untuk menyegarkan.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Langkah 5 Butir 3: Tombol 'Coba Lagi' yang memanggil ulang fetchProducts()
                            ElevatedButton.icon(
                              onPressed: _refreshProducts,
                              icon:
                                  const Icon(Icons.refresh_rounded, size: 20),
                              label: const Text('Coba Lagi'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // Data berhasil diterima
          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return RefreshIndicator(
              color: Colors.deepPurple,
              onRefresh: _refreshProducts,
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada produk ditemukan',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: _refreshProducts,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Segarkan'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // Kategori dinamis dari data API
          final categories = [
            'Semua',
            ...products.map((p) => p.category).toSet(),
          ];

          final filteredProducts = selectedCategory == 'Semua'
              ? products
              : products
                  .where(
                    (p) =>
                        p.category.toLowerCase() ==
                        selectedCategory.toLowerCase(),
                  )
                  .toList();

          return Column(
            children: [
              // Filter Kategori Cepat (Horizontal Scroll)
              Container(
                height: 48,
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = cat == selectedCategory;
                    return Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() {
                            selectedCategory = cat;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.deepPurple
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.deepPurple
                                  : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.deepPurple.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Langkah 4 Butir 2: ListView.builder dan ProductCard dengan Pull-To-Refresh (Hot Refresh)
              Expanded(
                child: RefreshIndicator(
                  color: Colors.deepPurple,
                  backgroundColor: Colors.white,
                  onRefresh: _refreshProducts,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Get.to(() => ProductDetailPage(product: product));
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
