import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import 'cart_page.dart';

/// Halaman Detail Produk yang menampilkan informasi lengkap dari sebuah [Product].
class ProductDetailPage extends StatelessWidget {
  // Objek Product yang dapat diterima via constructor atau ModalRoute / Get.arguments
  final Product? product;

  const ProductDetailPage({
    super.key,
    this.product,
  });

  // Helper untuk menentukan icon berdasarkan kategori
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'elektronik':
        return Icons.laptop_mac_rounded;
      case 'gadget':
        return Icons.smartphone_rounded;
      case 'fashion':
        return Icons.checkroom_rounded;
      case 'makanan':
        return Icons.fastfood_rounded;
      case 'aksesoris':
        return Icons.watch_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  // Helper untuk menentukan warna tema berdasarkan kategori
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'elektronik':
        return const Color(0xFF4F46E5);
      case 'gadget':
        return const Color(0xFF0D9488);
      case 'fashion':
        return const Color(0xFF9333EA);
      case 'makanan':
        return const Color(0xFFEA580C);
      case 'aksesoris':
        return const Color(0xFF0284C7);
      default:
        return Colors.deepPurple;
    }
  }

  // Helper untuk warna status stok
  Color _getStockColor(int stock) {
    if (stock > 5) return const Color(0xFF16A34A);
    if (stock > 0) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  Color _getStockBgColor(int stock) {
    if (stock > 5) return const Color(0xFFDCFCE7);
    if (stock > 0) return const Color(0xFFFEF3C7);
    return const Color(0xFFFEE2E2);
  }

  @override
  Widget build(BuildContext context) {
    // Langkah 3 Butir 1: Ambil instance CartController menggunakan Get.find() pada ProductDetailPage
    final CartController cartController = Get.find<CartController>();

    // Ambil data produk dari constructor atau Get.arguments / ModalRoute arguments
    final Product effectiveProduct = product ??
        (Get.arguments is Product ? Get.arguments as Product : null) ??
        (ModalRoute.of(context)!.settings.arguments as Product);

    final categoryColor = _getCategoryColor(effectiveProduct.category);
    final categoryIcon = _getCategoryIcon(effectiveProduct.category);
    final stockColor = _getStockColor(effectiveProduct.stock);
    final stockBgColor = _getStockBgColor(effectiveProduct.stock);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        // Langkah 4 Butir 2: Gunakan Get.back() pada ProductDetailPage untuk kembali ke halaman sebelumnya
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
          tooltip: 'Kembali',
        ),
        actions: [
          // Langkah 3 Butir 2: Badge keranjang belanja dengan Obx agar ter-update otomatis
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
                ),
              ),
              onPressed: () {
                Get.to(() => const CartPage());
              },
              tooltip: 'Keranjang Belanja',
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar / Icon Banner Produk
            Container(
              height: 240,
              color: categoryColor.withValues(alpha: 0.08),
              child: Center(
                child: Icon(
                  categoryIcon,
                  size: 110,
                  color: categoryColor,
                ),
              ),
            ),

            // Konten Detail Produk
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag Kategori & Status Stok
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          effectiveProduct.category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: stockBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: stockColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${effectiveProduct.getStatusStok()} (${effectiveProduct.stock} unit)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: stockColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 1. Nama Produk
                  Text(
                    effectiveProduct.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 2. Harga Produk (dengan diskon jika tipe DiscountedProduct)
                  if (effectiveProduct is DiscountedProduct) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          effectiveProduct.formattedFinalPrice,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          effectiveProduct.formattedPrice,
                          style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${effectiveProduct.discountPercent.toInt()}%',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      effectiveProduct.formattedPrice,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 16),

                  // 4. Deskripsi Produk
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    effectiveProduct.description != null && effectiveProduct.description!.isNotEmpty
                        ? effectiveProduct.description!
                        : 'Tidak ada deskripsi untuk produk ini.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Langkah 3 Butir 1 & 2: Tombol 'Tambah ke Keranjang' mengembalikan data ke halaman sebelumnya
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.add_shopping_cart_rounded),
            label: const Text(
              'Tambah ke Keranjang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              // Langkah 3 Butir 3: Hubungkan tombol 'Tambah ke Keranjang' pada ProductDetailPage
              // dengan method addToCart, lalu amati badge keranjang berubah tanpa pemanggilan setState
              cartController.addToCart(effectiveProduct);
            },
          ),
        ),
      ),
    );
  }
}
