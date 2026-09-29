import 'package:flutter/material.dart';
import '../models/product.dart';

/// ProductCard widget untuk menampilkan item katalog produk pada TokoKita.
/// Memadukan Container terangkat, Stack & Positioned untuk badge diskon,
/// serta tata letak responsif menggunakan Expanded dan Flexible.
class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // 1. State lokal untuk mencatat apakah produk ini difavoritkan
  bool isFavorite = false;

  // 2. Lifecycle initState: Dipanggil sekali saat widget pertama kali dimasukkan ke widget tree
  @override
  void initState() {
    super.initState();
    // ignore: avoid_print
    print('--> [initState] Dipanggil untuk: ${widget.product.name}');
  }

  // 3. Lifecycle dispose: Dipanggil saat widget dihapus dari widget tree
  @override
  void dispose() {
    // ignore: avoid_print
    print('--> [dispose] Dipanggil untuk: ${widget.product.name}');
    super.dispose();
  }

  // Helper untuk menentukan ikon berdasarkan kategori
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
        return const Color(0xFF4F46E5); // Indigo
      case 'gadget':
        return const Color(0xFF0D9488); // Teal
      case 'fashion':
        return const Color(0xFF9333EA); // Purple
      case 'makanan':
        return const Color(0xFFEA580C); // Deep Orange
      case 'aksesoris':
        return const Color(0xFF0284C7); // Sky Blue
      default:
        return Colors.deepPurple;
    }
  }

  // Helper untuk warna status stok
  Color _getStockColor(int stock) {
    if (stock > 5) return const Color(0xFF16A34A); // Hijau
    if (stock > 0) return const Color(0xFFD97706); // Amber
    return const Color(0xFFDC2626); // Merah
  }

  Color _getStockBgColor(int stock) {
    if (stock > 5) return const Color(0xFFDCFCE7);
    if (stock > 0) return const Color(0xFFFEF3C7);
    return const Color(0xFFFEE2E2);
  }

  // 4. Lifecycle build: Dipanggil setiap kali widget pertama dibuat atau saat setState() dipanggil
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(
      '--> [build] Dipanggil untuk: ${widget.product.name} | isFavorite: $isFavorite',
    );

    final categoryColor = _getCategoryColor(widget.product.category);
    final categoryIcon = _getCategoryIcon(widget.product.category);
    final stockColor = _getStockColor(widget.product.stock);
    final stockBgColor = _getStockBgColor(widget.product.stock);

    // Langkah 2: Menggunakan Container dengan padding, margin antar kartu,
    // warna latar putih, borderRadius, dan BoxShadow agar tampak seperti kartu terangkat.
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        // Langkah 2 Butir 2: Bayangan sederhana (BoxShadow) untuk efek kartu terangkat
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Langkah 3 Butir 1: Bungkus placeholder gambar dengan Stack
          Stack(
            children: [
              // Placeholder Gambar Produk bernuansa dinamis sesuai kategori
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: categoryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    categoryIcon,
                    size: 36,
                    color: categoryColor,
                  ),
                ),
              ),

              // Langkah 3 Butir 2: Badge kecil bertuliskan 'Diskon' menggunakan Positioned
              // di pojok kanan atas gambar, hanya untuk DiscountedProduct
              if (widget.product is DiscountedProduct)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDC2626).withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Diskon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Langkah 5 Butir 1: Expanded pada Column berisi nama dan harga produk
          // agar mengisi sisa ruang di samping gambar tanpa terjadi overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tag Kategori & Status Stok (menggunakan Wrap agar responsif di layar sempit)
                Wrap(
                  spacing: 5,
                  runSpacing: 2,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.product.category,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: categoryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: stockBgColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.product.getStatusStok(),
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: stockColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Nama Produk
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Deskripsi Produk (jika ada)
                if (widget.product.description != null &&
                    widget.product.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.product.description!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),

                // Harga Produk (Tampilkan harga diskon + coret harga awal jika DiscountedProduct)
                if (widget.product is DiscountedProduct)
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      Text(
                        (widget.product as DiscountedProduct)
                            .formattedFinalPrice,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      Text(
                        widget.product.formattedPrice,
                        style: const TextStyle(
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${(widget.product as DiscountedProduct).discountPercent.toInt()}%',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    widget.product.formattedPrice,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF16A34A),
                    ),
                  ),
              ],
            ),
          ),

          // Tombol Favorit Interaktif (IconButton)
          IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorite
                  ? const Color(0xFFE11D48)
                  : const Color(0xFFCBD5E1),
              size: 26,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              // ignore: avoid_print
              print(
                '--> [setState] Tombol Favorit ditekan pada "${widget.product.name}" -> Status Baru: $isFavorite',
              );
            },
            tooltip: isFavorite ? 'Hapus Favorit' : 'Tambah Favorit',
          ),
        ],
      ),
    );
  }
}
