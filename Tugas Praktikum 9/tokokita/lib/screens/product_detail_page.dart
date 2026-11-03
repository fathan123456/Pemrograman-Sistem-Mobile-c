import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'cart_page.dart';

/// Halaman Detail Produk yang menampilkan informasi lengkap dari sebuah [Product].
/// Mendukung penerimaan objek [Product] langsung lewat navigasi,
/// ATAU alternatif pengambilan data detail secara mandiri dari API menggunakan [fetchProductDetail],
/// serta memberikan kebebasan memilih jumlah produk yang ingin dimasukkan ke keranjang belanja.
class ProductDetailPage extends StatefulWidget {
  // Objek Product yang dapat diterima langsung via navigasi
  final Product? product;

  // Alternatif: ID produk untuk mengambil data detail dari endpoint API https://fakestoreapi.com/products/{id}
  final int? productId;

  const ProductDetailPage({
    super.key,
    this.product,
    this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Ambil instance CartController menggunakan Get.find() pada ProductDetailPage
  final CartController cartController = Get.find<CartController>();

  // Future penampung data detail produk
  late Future<Product> _productFuture;

  // Menyimpan ID produk yang sedang ditampilkan
  int? _activeProductId;

  // Kebebasan kuantitas yang dapat ditentukan oleh pengguna saat menambahkan ke keranjang
  int _selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    _initProductData();
  }

  /// Inisialisasi data produk:
  /// Jika dikirim objek Product utuh -> langsung gunakan.
  /// Jika dikirim productId (atau int di Get.arguments) -> panggil fetchProductDetail(id).
  void _initProductData() {
    // 1. Cek parameter eksplisit productId
    if (widget.productId != null) {
      _activeProductId = widget.productId;
      _productFuture = fetchProductDetail(widget.productId!);
      return;
    }

    // 2. Cek apakah ada objek Product dari constructor
    if (widget.product != null) {
      _activeProductId = widget.product!.id;
      _productFuture = Future.value(widget.product!);
      return;
    }

    // 3. Cek argumen dari Get.arguments
    final navArgs = Get.arguments;
    if (navArgs is int) {
      // Alternatif: Navigasi mengirimkan ID integer -> ambil via API
      _activeProductId = navArgs;
      _productFuture = fetchProductDetail(navArgs);
    } else if (navArgs is Product) {
      // Navigasi mengirimkan objek Product utuh
      _activeProductId = navArgs.id;
      _productFuture = Future.value(navArgs);
    } else {
      // Fallback default: Ambil produk ID 1 dari API
      _activeProductId = 1;
      _productFuture = fetchProductDetail(1);
    }
  }

  /// Memuat ulang / menyegarkan detail produk langsung dari API
  Future<void> _refreshDetail() async {
    final id = _activeProductId ?? widget.product?.id ?? widget.productId ?? 1;
    setState(() {
      _productFuture = fetchProductDetail(id);
    });
    try {
      await _productFuture;
    } catch (_) {
      // Handled by FutureBuilder
    }
  }

  // Helper untuk menentukan icon berdasarkan kategori
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'elektronik':
      case 'electronics':
        return Icons.laptop_mac_rounded;
      case 'gadget':
        return Icons.smartphone_rounded;
      case 'fashion':
      case "men's clothing":
      case "women's clothing":
        return Icons.checkroom_rounded;
      case 'makanan':
        return Icons.fastfood_rounded;
      case 'aksesoris':
      case 'jewelery':
        return Icons.watch_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  // Helper untuk menentukan warna tema berdasarkan kategori
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'elektronik':
      case 'electronics':
        return const Color(0xFF4F46E5);
      case 'gadget':
        return const Color(0xFF0D9488);
      case 'fashion':
      case "men's clothing":
      case "women's clothing":
        return const Color(0xFF9333EA);
      case 'makanan':
        return const Color(0xFFEA580C);
      case 'aksesoris':
      case 'jewelery':
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
          tooltip: 'Kembali',
        ),
        actions: [
          // Tombol Segarkan data langsung dari endpoint API
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.deepPurple),
            onPressed: _refreshDetail,
            tooltip: 'Segarkan dari API',
          ),
          // Badge keranjang belanja dengan Obx
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
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          // 1. Status Loading saat fetchProductDetail berjalan
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.deepPurple),
                  SizedBox(height: 16),
                  Text(
                    'Memuat detail produk dari API...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // 2. Status Error jika gagal memuat detail produk
          if (snapshot.hasError) {
            final rawError = snapshot.error.toString();
            final isOffline = rawError.toLowerCase().contains('internet') ||
                rawError.toLowerCase().contains('koneksi') ||
                rawError.toLowerCase().contains('socket');

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
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
                        size: 52,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Gagal Memuat Detail Produk',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rawError.replaceFirst('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _refreshDetail,
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      label: const Text('Coba Lagi'),
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
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Status Sukses: Data produk tersedia
          final effectiveProduct = snapshot.data!;
          final categoryColor = _getCategoryColor(effectiveProduct.category);
          final categoryIcon = _getCategoryIcon(effectiveProduct.category);
          final stockColor = _getStockColor(effectiveProduct.stock);
          final stockBgColor = _getStockBgColor(effectiveProduct.stock);

          final double singleItemPrice = effectiveProduct is DiscountedProduct
              ? effectiveProduct.hitungHargaFinal()
              : effectiveProduct.price;
          final int maxStock =
              effectiveProduct.stock > 0 ? effectiveProduct.stock : 1;

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: Colors.deepPurple,
                  onRefresh: _refreshDetail,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Gambar Produk (Menggunakan gambar dari URL jika ada, atau fallback ke ikon kategori)
                        Container(
                          height: 260,
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: Center(
                            child: effectiveProduct.imageUrl != null &&
                                    effectiveProduct.imageUrl!.isNotEmpty
                                ? Image.network(
                                    effectiveProduct.imageUrl!,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(
                                      categoryIcon,
                                      size: 100,
                                      color: categoryColor,
                                    ),
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.deepPurple,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: double.infinity,
                                    color: categoryColor.withValues(alpha: 0.08),
                                    child: Center(
                                      child: Icon(
                                        categoryIcon,
                                        size: 100,
                                        color: categoryColor,
                                      ),
                                    ),
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
                                      color:
                                          categoryColor.withValues(alpha: 0.12),
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

                              // Nama Produk
                              Text(
                                effectiveProduct.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Harga Produk
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
                                        decoration:
                                            TextDecoration.lineThrough,
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

                              // Deskripsi Produk
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
                                effectiveProduct.description != null &&
                                        effectiveProduct.description!.isNotEmpty
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
                ),
              ),

              // Tombol Tambah ke Keranjang dengan Pengatur Kuantitas Fleksibel
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Baris Pengatur Kuantitas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Jumlah Pembelian',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Subtotal: ${formatRupiah(singleItemPrice * _selectedQuantity)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                          // Kontrol Jumlah [-] [qty] [+]
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  color: _selectedQuantity > 1
                                      ? Colors.deepPurple
                                      : Colors.grey,
                                  onPressed: _selectedQuantity > 1
                                      ? () {
                                          setState(() {
                                            _selectedQuantity--;
                                          });
                                        }
                                      : null,
                                  tooltip: 'Kurangi Jumlah',
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                InkWell(
                                  onTap: () async {
                                    final textController =
                                        TextEditingController(
                                      text: '$_selectedQuantity',
                                    );
                                    final customQty = await showDialog<int>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Tentukan Jumlah'),
                                        content: TextField(
                                          controller: textController,
                                          keyboardType: TextInputType.number,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Jumlah (Maksimal: ${effectiveProduct.stock})',
                                            border: const OutlineInputBorder(),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx),
                                            child: const Text('Batal'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              final val = int.tryParse(
                                                textController.text.trim(),
                                              );
                                              if (val != null && val > 0) {
                                                final clamped = val.clamp(
                                                  1,
                                                  maxStock,
                                                );
                                                Navigator.pop(ctx, clamped);
                                              }
                                            },
                                            child: const Text('Terapkan'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (customQty != null) {
                                      setState(() {
                                        _selectedQuantity = customQty;
                                      });
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(minWidth: 40),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      '$_selectedQuantity',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  color: (effectiveProduct.stock > 0 &&
                                          _selectedQuantity < maxStock)
                                      ? Colors.deepPurple
                                      : Colors.grey,
                                  onPressed: (effectiveProduct.stock > 0 &&
                                          _selectedQuantity < maxStock)
                                      ? () {
                                          setState(() {
                                            _selectedQuantity++;
                                          });
                                        }
                                      : null,
                                  tooltip: 'Tambah Jumlah',
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: effectiveProduct.stock > 0
                                ? Colors.deepPurple
                                : Colors.grey.shade400,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: effectiveProduct.stock > 0 ? 1 : 0,
                          ),
                          icon: const Icon(Icons.add_shopping_cart_rounded),
                          label: Text(
                            effectiveProduct.stock > 0
                                ? 'Tambah $_selectedQuantity ke Keranjang'
                                : 'Stok Habis',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: effectiveProduct.stock > 0
                              ? () {
                                  cartController.addToCart(
                                    effectiveProduct,
                                    quantity: _selectedQuantity,
                                  );
                                }
                              : null,
                        ),
                      ),
                    ],
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
