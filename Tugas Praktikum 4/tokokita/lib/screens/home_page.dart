import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

/// Halaman utama TokoKita yang menampilkan header kustom dan katalog produk
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Kategori aktif untuk filter cepat
  String selectedCategory = 'Semua';

  final List<String> categories = const [
    'Semua',
    'Elektronik',
    'Gadget',
    'Fashion',
    'Makanan',
    'Aksesoris',
  ];

  @override
  Widget build(BuildContext context) {
    // Sumber data List<Product> dari dummyProducts, difilter jika kategori dipilih
    final filteredProducts = selectedCategory == 'Semua'
        ? dummyProducts
        : dummyProducts
            .where((p) =>
                p.category.toLowerCase() == selectedCategory.toLowerCase())
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // Langkah 1 Butir 1-3: App Bar Sederhana dengan Row & Column
      appBar: AppBar(
        toolbarHeight: 76,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        // Langkah 1 Butir 2: Header halaman (nama toko dan ikon keranjang)
        // menggunakan Row dengan mainAxisAlignment.spaceBetween
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Langkah 1 Butir 3: Susun judul dan subjudul menggunakan Column dengan crossAxisAlignment.start
            // Gunakan Expanded / Flexible untuk mencegah overflow di layar sempit (Langkah 5 Butir 2)
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
            // Ikon keranjang belanja dengan badge notifikasi
            IconButton(
              icon: Badge(
                label: const Text(
                  '3',
                  style: TextStyle(
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ikon Keranjang Belanja ditekan'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              tooltip: 'Keranjang Belanja',
            ),
          ],
        ),
      ),
      body: Column(
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
                                  color: Colors.deepPurple
                                      .withValues(alpha: 0.25),
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

          // Langkah 4 Butir 1 & 2: Gunakan List<Product> dari Pertemuan 2 (dummyProducts)
          // dan tampilkan menggunakan ListView.builder yang me-render ProductCard untuk setiap item
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}
