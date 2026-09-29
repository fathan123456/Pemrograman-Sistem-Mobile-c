import 'package:flutter/material.dart';
import '../models/product.dart';

/// LANGKAH 2: ProductCard diubah menjadi StatefulWidget
/// StatefulWidget digunakan karena komponen ini memiliki state lokal dinamis (isFavorite)
/// yang dapat berubah saat pengguna berinteraksi (menekan tombol favorit).
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
  // 1. State lokal untuk mencatat apakah produk ini difavoritkan atau tidak
  bool isFavorite = false;

  // 2. Lifecycle initState: Dipanggil sekali saat widget pertama kali dimasukkan ke dalam widget tree
  @override
  void initState() {
    super.initState();
    // ignore: avoid_print
    print('--> [initState] Dipanggil untuk: ${widget.product.name}');
  }

  // 3. Lifecycle dispose: Dipanggil saat widget dihapus secara permanen dari widget tree
  @override
  void dispose() {
    // ignore: avoid_print
    print('--> [dispose] Dipanggil untuk: ${widget.product.name}');
    super.dispose();
  }

  // 4. Lifecycle build: Dipanggil setiap kali widget pertama dibuat atau saat setState() dipanggil
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(
      '--> [build] Dipanggil untuk: ${widget.product.name} | isFavorite: $isFavorite',
    );

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Placeholder Gambar Produk
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 36,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(width: 16),

            // Informasi Nama dan Harga Produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.product.formattedPrice,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),

            // 5. Tombol Favorit Interaktif (IconButton)
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
                size: 28,
              ),
              onPressed: () {
                // setState() memberitahu Flutter bahwa state internal berubah,
                // sehingga Flutter akan menjalankan ulang method build() pada widget ini
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
      ),
    );
  }
}
