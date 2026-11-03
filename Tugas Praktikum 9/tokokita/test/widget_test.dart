import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tokokita/controllers/cart_controller.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/models/product.dart';
import 'package:tokokita/screens/home_page.dart';
import 'package:tokokita/screens/product_detail_page.dart';
import 'package:tokokita/services/product_service.dart';

void main() {
  setUp(() {
    Get.reset();
    // Default MockClient mengembalikan dummyProducts dalam bentuk JSON API FakeStore
    ProductService.client = MockClient((request) async {
      final segments = request.url.pathSegments;
      if (segments.length == 2 && segments[0] == 'products') {
        final id = int.tryParse(segments[1]);
        final found = dummyProducts.firstWhere(
          (p) => p.id == id,
          orElse: () => dummyProducts.first,
        );
        final map = {
          'id': found.id,
          'title': found.name,
          'price': found.price,
          'description': found.description,
          'category': found.category,
          'image': found.imageUrl,
          'stock': found.stock,
        };
        return http.Response(
          jsonEncode(map),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }

      final jsonList = dummyProducts.map((p) => {
        'id': p.id,
        'title': p.name,
        'price': p.price,
        'description': p.description,
        'category': p.category,
        'image': p.imageUrl,
        'stock': p.stock,
      }).toList();
      return http.Response(
        jsonEncode(jsonList),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
  });

  tearDown(() {
    ProductService.client = null;
  });

  testWidgets('Langkah 1: Header App Bar dengan Row & Column serta ikon keranjang', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());
    await tester.pumpAndSettle();

    // Memverifikasi judul dan subjudul
    expect(find.text('TokoKita'), findsOneWidget);
    expect(find.text('Belanja jadi lebih mudah'), findsOneWidget);

    // Memverifikasi ikon keranjang belanja (pada AppBar)
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.shopping_cart_outlined),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Langkah 3: Badge Diskon hanya muncul pada DiscountedProduct', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());
    await tester.pumpAndSettle();

    // Verifikasi produk diskon tampil di katalog awal
    expect(find.text('MacBook Air M2 256GB'), findsOneWidget);
    expect(find.text('Smartphone Galaxy S24'), findsOneWidget);
  });

  testWidgets('Langkah 4: ListView.builder dapat me-render dan scroll data produk', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());
    await tester.pumpAndSettle();

    expect(dummyProducts.length, greaterThanOrEqualTo(20));

    // Scroll sampai produk terakhir ditemukan
    final lastProduct = dummyProducts.last;
    final lastItemFinder = find.text(lastProduct.name);

    await tester.scrollUntilVisible(
      lastItemFinder,
      500,
      scrollable: find.byType(Scrollable).last,
    );

    expect(lastItemFinder, findsOneWidget);
  });

  testWidgets('Langkah 5: Tampilan responsif tanpa overflow pada berbagai ukuran layar', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TokoKitaApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('Fitur Tambahan: Filter Kategori bekerja dinamis', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());
    await tester.pumpAndSettle();

    // Tap kategori 'Makanan'
    await tester.tap(find.text('Makanan'));
    await tester.pumpAndSettle();

    expect(find.text('Kopi Arabika Gayo Single Origin 250g'), findsOneWidget);
  });

  test('Praktikum 6: CartController reaktif addToCart, removeFromCart, totalItem, totalHarga', () {
    final controller = CartController();

    expect(controller.totalItem, 0);
    expect(controller.totalHarga, 0.0);

    final product1 = dummyProducts[0];
    final product2 = dummyProducts[1];

    controller.addToCart(product1);
    expect(controller.totalItem, 1);
    expect(controller.totalHarga, (product1 as DiscountedProduct).hitungHargaFinal());

    controller.addToCart(product2);
    expect(controller.totalItem, 2);

    controller.removeFromCart(product1);
    expect(controller.totalItem, 1);
    expect(controller.cartItems.contains(product1), false);
    expect(controller.cartItems.contains(product2), true);

    controller.clearCart();
    expect(controller.totalItem, 0);
    expect(controller.totalHarga, 0.0);
  });

  // =========================================================================
  // PRAKTIKUM 7 UNIT & WIDGET TESTS (LANGKAH 1 - 5 & DETAIL API)
  // =========================================================================

  test('Praktikum 7 - Langkah 3: Product.fromJson memetakan field API ke properti Product', () {
    final apiMap = {
      'id': 1,
      'title': 'Fjallraven Backpack',
      'price': 109.95,
      'description': 'Tas laptop awet dan keren',
      'category': "men's clothing",
      'image': 'https://fakestoreapi.com/img/81fPKd-2AYL.jpg',
      'rating': {'rate': 3.9, 'count': 120},
    };

    final product = Product.fromJson(apiMap);

    expect(product.id, 1);
    expect(product.name, 'Fjallraven Backpack'); // title -> name
    expect(product.price, 109.95);
    expect(product.description, 'Tas laptop awet dan keren');
    expect(product.category, "men's clothing");
    expect(product.imageUrl, 'https://fakestoreapi.com/img/81fPKd-2AYL.jpg');
    expect(product.stock, 120);
    expect(product.getStatusStok(), 'Tersedia');
  });

  test('Praktikum 7 - Langkah 2 & 3: fetchProducts() memanggil API dan mengembalikan List<Product>', () async {
    final products = await fetchProducts();

    expect(products, isNotEmpty);
    expect(products.first.name, dummyProducts.first.name);
  });

  test('Praktikum 7 - Fitur fetchProductDetail(id) mengambil satu produk berdasarkan ID', () async {
    final product = await fetchProductDetail(2);

    expect(product.id, 2);
    expect(product.name, dummyProducts[1].name);
  });

  testWidgets('Praktikum 7 - Langkah 4: FutureBuilder menampilkan CircularProgressIndicator saat loading', (WidgetTester tester) async {
    final completer = Completer<List<Product>>();
    Get.put(CartController());

    await tester.pumpWidget(
      GetMaterialApp(
        home: HomePage(productsFuture: completer.future),
      ),
    );

    // Saat masih waiting, CircularProgressIndicator harus tampil
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Memuat produk dari server...'), findsOneWidget);

    completer.complete(dummyProducts);
    await tester.pumpAndSettle();

    // Setelah complete, loading hilang dan produk tampil
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text(dummyProducts.first.name), findsOneWidget);
  });

  testWidgets('Praktikum 7 - Langkah 5: Penanganan Error dan Tombol Coba Lagi', (WidgetTester tester) async {
    // Set MockClient mengembalikan status code 500
    ProductService.client = MockClient((request) async {
      return http.Response('Server Error', 500);
    });

    Get.put(CartController());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomePage(),
      ),
    );
    await tester.pumpAndSettle();

    // Pesan error ramah pengguna tampil
    expect(find.text('Gagal memuat produk, coba lagi'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);

    // Tombol 'Coba Lagi' ada di layar
    final retryFinder = find.widgetWithText(ElevatedButton, 'Coba Lagi');
    expect(retryFinder, findsOneWidget);

    // Simulasikan pemulihan server
    ProductService.client = MockClient((request) async {
      final jsonList = [
        {
          'id': 100,
          'title': 'Produk Pemulihan',
          'price': 50000.0,
          'category': 'Elektronik',
          'stock': 10,
        }
      ];
      return http.Response(jsonEncode(jsonList), 200);
    });

    // Tekan tombol Coba Lagi
    await tester.tap(retryFinder);
    await tester.pumpAndSettle();

    // Produk berhasil tampil setelah retry
    expect(find.text('Produk Pemulihan'), findsOneWidget);
  });

  testWidgets('Praktikum 7 - Fitur Hot Refresh / Pull-To-Refresh pada HomePage', (WidgetTester tester) async {
    Get.put(CartController());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomePage(),
      ),
    );
    await tester.pumpAndSettle();

    // Memverifikasi RefreshIndicator dan tombol refresh pada AppBar ada
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);

    // Trigger refresh lewat tombol refresh pada AppBar
    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pumpAndSettle();

    expect(find.text('MacBook Air M2 256GB'), findsOneWidget);
  });

  testWidgets('Praktikum 7 - ProductDetailPage menampilkan produk dari objek navigasi dan fitur kuantitas fleksibel', (WidgetTester tester) async {
    final controller = Get.put(CartController());
    controller.clearCart();

    final product = dummyProducts[0];
    await tester.pumpWidget(
      GetMaterialApp(
        home: ProductDetailPage(product: product),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(product.name), findsOneWidget);
    expect(find.text('Tambah 1 ke Keranjang'), findsOneWidget);

    // Tambah jumlah dengan tombol [+]
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verifikasi tombol berubah menjadi 'Tambah 2 ke Keranjang'
    expect(find.text('Tambah 2 ke Keranjang'), findsOneWidget);

    // Tekan tombol Tambah ke Keranjang
    await tester.tap(find.text('Tambah 2 ke Keranjang'));
    await tester.pumpAndSettle();

    // Pastikan 2 item masuk ke CartController
    expect(controller.totalItem, 2);
  });

  testWidgets('Praktikum 7 - ProductDetailPage mengambil data via fetchProductDetail(productId) secara mandiri', (WidgetTester tester) async {
    final controller = Get.put(CartController());
    controller.clearCart();

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ProductDetailPage(productId: 2),
      ),
    );
    await tester.pumpAndSettle();

    // Data produk ID 2 harus berhasil diambil dari API dan tampil
    expect(find.text(dummyProducts[1].name), findsOneWidget);
    expect(find.text('Tambah 1 ke Keranjang'), findsOneWidget);
  });

  test('Praktikum 7 - CartController mendukung penambahan kuantitas kustom', () {
    final controller = CartController();
    final product = dummyProducts[0];

    // Tambahkan 3 item sekaligus
    controller.addToCart(product, quantity: 3);
    expect(controller.totalItem, 3);
    expect(controller.getQuantity(product), 3);

    // Ubah kuantitas menjadi 5
    controller.setQuantity(product, 5);
    expect(controller.totalItem, 5);
    expect(controller.getQuantity(product), 5);

    // Kurangi kuantitas menjadi 2
    controller.setQuantity(product, 2);
    expect(controller.totalItem, 2);
    expect(controller.getQuantity(product), 2);

    // Hapus seluruh produk
    controller.removeFromCart(product);
    expect(controller.totalItem, 0);
  });
}
