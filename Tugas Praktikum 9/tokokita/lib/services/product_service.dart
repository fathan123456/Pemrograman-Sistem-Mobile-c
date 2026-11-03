// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

/// Service untuk menangani komunikasi jaringan dan pengambilan data produk dari API
class ProductService {
  static const String apiUrl = 'https://fakestoreapi.com/products';

  /// Client HTTP yang dapat diinjeksi (berguna untuk testing / mocking)
  static http.Client? client;

  /// Mengambil daftar semua produk dari FakeStore API
  /// [customClient] opsional untuk pengujian mock
  /// [urlOverride] opsional jika ingin mengubah target endpoint
  static Future<List<Product>> fetchProducts({
    String? urlOverride,
    http.Client? customClient,
  }) async {
    final targetUrl = Uri.parse(urlOverride ?? apiUrl);
    final activeClient = customClient ?? client;

    try {
      // Langkah 2 Butir 1 & 2: Request GET ke endpoint FakeStoreAPI dengan async/await dan timeout 15 detik
      final response = activeClient != null
          ? await activeClient.get(targetUrl).timeout(const Duration(seconds: 15))
          : await http.get(targetUrl).timeout(const Duration(seconds: 15));

      // Langkah 2 Butir 2: Cetak response.statusCode dan response.body pada console
      print('=== [ProductService] Response Status Code: ${response.statusCode} ===');
      print('=== [ProductService] Response Body: ${response.body} ===');

      if (response.statusCode == 200) {
        // Langkah 3 Butir 2: Ubah response.body menggunakan jsonDecode
        // lalu petakan hasilnya (List of Map) menjadi List<Product> menggunakan Product.fromJson
        final List<dynamic> data = jsonDecode(response.body);
        final List<Product> products = data
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
        return products;
      } else {
        // Status code non-200 (misalnya 404/500)
        throw Exception(
          'Gagal mengambil data dari server (Status Code: ${response.statusCode})',
        );
      }
    } on SocketException catch (e) {
      // Penanganan spesifik ketika tidak ada koneksi internet
      print('=== [ProductService] ERROR KONEKSI (SocketException): $e ===');
      throw Exception(
        'Tidak ada koneksi internet. Pastikan perangkat Anda terhubung ke jaringan.',
      );
    } on TimeoutException catch (e) {
      // Penanganan timeout
      print('=== [ProductService] ERROR TIMEOUT: $e ===');
      throw Exception(
        'Waktu permintaan habis. Koneksi internet mungkin sedang lambat.',
      );
    } on http.ClientException catch (e) {
      // http.ClientException biasanya membungkus kegagalan DNS atau host lookup saat offline
      print('=== [ProductService] ERROR CLIENT (ClientException): $e ===');
      if (e.message.toLowerCase().contains('failed host lookup') ||
          e.message.toLowerCase().contains('socketexception') ||
          e.message.toLowerCase().contains('network')) {
        throw Exception(
          'Tidak ada koneksi internet. Periksa koneksi Wi-Fi atau data seluler Anda.',
        );
      }
      throw Exception('Gagal terhubung ke server: ${e.message}');
    } catch (e) {
      // Langkah 5 Butir 1: Tangkap error dengan try-catch dan cetak pesan error
      print('=== [ProductService] ERROR TERTANGKAP: $e ===');
      rethrow; // Lempar kembali agar ditangkap oleh FutureBuilder (snapshot.hasError)
    }
  }

  /// Mengambil detail satu produk dari API berdasarkan ID
  /// Endpoint: https://fakestoreapi.com/products/{id}
  static Future<Product> fetchProductDetail(
    int id, {
    http.Client? customClient,
  }) async {
    final targetUrl = Uri.parse('$apiUrl/$id');
    final activeClient = customClient ?? client;

    try {
      print('=== [ProductService] Request Detail Produk ID $id: $targetUrl ===');
      final response = activeClient != null
          ? await activeClient.get(targetUrl).timeout(const Duration(seconds: 15))
          : await http.get(targetUrl).timeout(const Duration(seconds: 15));

      print('=== [ProductService] Detail Status Code: ${response.statusCode} ===');
      print('=== [ProductService] Detail Body: ${response.body} ===');

      if (response.statusCode == 200) {
        if (response.body.isEmpty || response.body == 'null') {
          throw Exception('Produk dengan ID $id tidak ditemukan.');
        }
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Produk dengan ID $id tidak ditemukan di server.');
      } else {
        throw Exception(
          'Gagal memuat detail produk (Status Code: ${response.statusCode})',
        );
      }
    } on SocketException catch (e) {
      print('=== [ProductService] ERROR KONEKSI (SocketException): $e ===');
      throw Exception(
        'Tidak ada koneksi internet. Pastikan perangkat Anda terhubung ke jaringan.',
      );
    } on TimeoutException catch (e) {
      print('=== [ProductService] ERROR TIMEOUT: $e ===');
      throw Exception(
        'Waktu permintaan habis. Koneksi internet mungkin sedang lambat.',
      );
    } on http.ClientException catch (e) {
      print('=== [ProductService] ERROR CLIENT (ClientException): $e ===');
      if (e.message.toLowerCase().contains('failed host lookup') ||
          e.message.toLowerCase().contains('socketexception') ||
          e.message.toLowerCase().contains('network')) {
        throw Exception(
          'Tidak ada koneksi internet. Periksa koneksi Wi-Fi atau data seluler Anda.',
        );
      }
      throw Exception('Gagal terhubung ke server: ${e.message}');
    } catch (e) {
      print('=== [ProductService] ERROR TERTANGKAP: $e ===');
      rethrow;
    }
  }
}

/// Langkah 3 Butir 3: Function `Future<List<Product>>` fetchProducts() pada product_service.dart
/// yang mengembalikan hasil parsing tersebut.
Future<List<Product>> fetchProducts({
  String? urlOverride,
  http.Client? customClient,
}) =>
    ProductService.fetchProducts(
      urlOverride: urlOverride,
      customClient: customClient,
    );

/// Function `Future<Product>` fetchProductDetail(int id) yang mengambil detail satu produk
/// dari endpoint https://fakestoreapi.com/products/{id}
Future<Product> fetchProductDetail(
  int id, {
  http.Client? customClient,
}) =>
    ProductService.fetchProductDetail(
      id,
      customClient: customClient,
    );
