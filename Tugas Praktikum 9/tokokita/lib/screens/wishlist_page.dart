import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'product_detail_page.dart';

/// Halaman Wishlist (Langkah 2)
/// Menampilkan produk-produk yang ID-nya tersimpan pada SharedPreferences.
/// Pengguna dapat menghapus produk langsung dari wishlist dan menambahkan ke keranjang belanja.
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final CartController cartController = Get.find<CartController>();

  bool _isLoading = true;
  List<Product> _wishlistItems = [];
  List<String> _favoriteIds = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  /// Langkah 2 Butir 1: Memuat daftar ID dari SharedPreferences dan mencocokkan produk
  Future<void> _loadWishlist() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      _favoriteIds = prefs.getStringList('favorite_ids') ?? [];

      if (_favoriteIds.isEmpty) {
        setState(() {
          _wishlistItems = [];
          _isLoading = false;
        });
        return;
      }

      // Ambil daftar produk dari API, jika gagal/offline gunakan dummyProducts sebagai fallback
      List<Product> allProducts = [];
      try {
        allProducts = await fetchProducts();
      } catch (_) {
        allProducts = dummyProducts;
      }

      // Filter hanya produk yang ID-nya ada di daftar favorit SharedPreferences
      final matchedProducts = allProducts
          .where((p) => _favoriteIds.contains(p.id.toString()))
          .toList();

      setState(() {
        _wishlistItems = matchedProducts;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('--> [WishlistPage] Error memuat wishlist: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Langkah 2 Butir 2: Menghapus produk dari wishlist dan memperbarui SharedPreferences secara langsung
  Future<void> _removeFromWishlist(Product product) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _favoriteIds = prefs.getStringList('favorite_ids') ?? [];

      _favoriteIds.remove(product.id.toString());
      await prefs.setStringList('favorite_ids', _favoriteIds);

      setState(() {
        _wishlistItems.removeWhere((item) => item.id == product.id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} dihapus dari Wishlist'),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('--> [WishlistPage] Gagal menghapus dari wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Wishlist Saya',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
          tooltip: 'Kembali',
        ),
        actions: [
          if (_wishlistItems.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  '${_wishlistItems.length} Produk',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : _wishlistItems.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  color: Colors.deepPurple,
                  onRefresh: _loadWishlist,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _wishlistItems.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = _wishlistItems[index];
                      return _buildWishlistItemCard(product);
                    },
                  ),
                ),
    );
  }

  /// Tampilan ketika Wishlist masih kosong
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 64,
                color: Color(0xFFE11D48),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Wishlist Masih Kosong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Simpan produk yang Anda sukai dengan menekan ikon hati pada katalog produk.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.shopping_bag_outlined, size: 18),
              label: const Text('Jelajahi Produk'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu item wishlist dengan tombol hapus dan tombol tambah keranjang
  Widget _buildWishlistItemCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            await Get.to(() => ProductDetailPage(product: product));
            _loadWishlist();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Icon / Avatar Kategori
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.deepPurple,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),

                // Detail Produk
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product is DiscountedProduct
                            ? (product as DiscountedProduct).formattedFinalPrice
                            : product.formattedPrice,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tombol Aksi: Tambah ke Keranjang & Hapus
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        color: Colors.deepPurple,
                        size: 22,
                      ),
                      tooltip: 'Tambah ke Keranjang',
                      onPressed: () {
                        cartController.addToCart(product);
                      },
                    ),
                    // Langkah 2 Butir 2: Tombol untuk menghapus produk dari wishlist
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFDC2626),
                        size: 22,
                      ),
                      tooltip: 'Hapus dari Wishlist',
                      onPressed: () => _removeFromWishlist(product),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
