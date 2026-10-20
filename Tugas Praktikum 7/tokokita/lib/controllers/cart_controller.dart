import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';

/// Langkah 2: CartController sebagai State Management berbasis GetX
/// Mengelola state keranjang belanja dengan variabel reaktif.
class CartController extends GetxController {
  // Langkah 2 Butir 1: Variabel reaktif RxList<Product> untuk menyimpan item keranjang
  final RxList<Product> cartItems = <Product>[].obs;

  // Langkah 2 Butir 2: Method addToCart untuk menambahkan item ke keranjang dengan fleksibilitas kuantitas
  void addToCart(Product product, {int quantity = 1}) {
    final qty = quantity <= 0 ? 1 : quantity;
    for (int i = 0; i < qty; i++) {
      cartItems.add(product);
    }

    // Feedback visual menggunakan Get.snackbar (jika overlay konteks tersedia)
    if (Get.overlayContext != null) {
      Get.snackbar(
        'Berhasil Ditambahkan',
        qty > 1
            ? '$qty item ${product.name} berhasil dimasukkan ke keranjang belanja.'
            : '${product.name} berhasil dimasukkan ke keranjang belanja.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.deepPurple,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // Langkah 2 Butir 2: Method removeFromCart untuk menghapus item dari keranjang
  void removeFromCart(Product product, {bool removeAll = true}) {
    if (removeAll) {
      cartItems.removeWhere((item) => item.id == product.id);
    } else {
      cartItems.remove(product);
    }

    if (Get.overlayContext != null) {
      Get.snackbar(
        'Dihapus dari Keranjang',
        '${product.name} telah dihapus dari keranjang.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
        icon: const Icon(Icons.delete_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // Menghitung jumlah item untuk satu produk tertentu di dalam keranjang
  int getQuantity(Product product) {
    return cartItems.where((item) => item.id == product.id).length;
  }

  // Mengubah kuantitas item produk di keranjang secara langsung
  void setQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
      return;
    }
    final currentQty = getQuantity(product);
    if (quantity > currentQty) {
      for (int i = 0; i < quantity - currentQty; i++) {
        cartItems.add(product);
      }
    } else if (quantity < currentQty) {
      for (int i = 0; i < currentQty - quantity; i++) {
        final index = cartItems.indexWhere((item) => item.id == product.id);
        if (index != -1) {
          cartItems.removeAt(index);
        }
      }
    }
  }

  // Langkah 2 Butir 3: Getter reaktif untuk menghitung totalItem
  int get totalItem => cartItems.length;

  // Langkah 2 Butir 3: Getter reaktif untuk menghitung totalHarga berdasarkan isi keranjang
  double get totalHarga {
    return cartItems.fold<double>(0.0, (sum, item) {
      if (item is DiscountedProduct) {
        return sum + item.hitungHargaFinal();
      }
      return sum + item.price;
    });
  }

  // Helper untuk menampilkan total harga yang sudah terformat dalam Rupiah
  String get formattedTotalHarga => formatRupiah(totalHarga);

  // Method untuk mengosongkan keranjang (digunakan saat checkout selesai)
  void clearCart() {
    cartItems.clear();
  }
}
