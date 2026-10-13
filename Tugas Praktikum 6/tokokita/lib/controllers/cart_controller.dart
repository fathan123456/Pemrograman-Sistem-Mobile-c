import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';

/// Langkah 2: CartController sebagai State Management berbasis GetX
/// Mengelola state keranjang belanja dengan variabel reaktif.
class CartController extends GetxController {
  // Langkah 2 Butir 1: Variabel reaktif RxList<Product> untuk menyimpan item keranjang
  final RxList<Product> cartItems = <Product>[].obs;

  // Langkah 2 Butir 2: Method addToCart untuk menambahkan item ke keranjang
  void addToCart(Product product) {
    cartItems.add(product);

    // Feedback visual menggunakan Get.snackbar (jika overlay konteks tersedia)
    if (Get.overlayContext != null) {
      Get.snackbar(
        'Berhasil Ditambahkan',
        '${product.name} berhasil dimasukkan ke keranjang belanja.',
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
  void removeFromCart(Product product) {
    cartItems.remove(product);

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
