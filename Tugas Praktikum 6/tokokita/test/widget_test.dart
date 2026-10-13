import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tokokita/controllers/cart_controller.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/models/product.dart';

void main() {
  setUp(() {
    Get.reset();
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

    // Memverifikasi badge 'Diskon' muncul pada produk diskon
    expect(find.text('Diskon'), findsWidgets);

    // Verifikasi produk diskon tampil di katalog awal
    expect(find.text('MacBook Air M2 256GB'), findsOneWidget);
    expect(find.text('Smartphone Galaxy S24'), findsOneWidget);
  });

  testWidgets('Langkah 4: ListView.builder dapat me-render dan scroll 25 data produk', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());
    await tester.pumpAndSettle();

    // Pastikan total data produk dummy minimal 20 (sekarang 25 produk)
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
    // Uji pada layar sempit (320px)
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TokoKitaApp());
    await tester.pumpAndSettle();

    // Tidak boleh ada exception atau overflow yang terjadi
    expect(tester.takeException(), isNull);
  });

  testWidgets('Fitur Tambahan: Filter Kategori bekerja dinamis', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());
    await tester.pumpAndSettle();

    // Tap kategori 'Makanan'
    await tester.tap(find.text('Makanan'));
    await tester.pumpAndSettle();

    // Produk makanan harus muncul
    expect(find.text('Kopi Arabika Gayo Single Origin 250g'), findsOneWidget);
  });

  test('Praktikum 6: CartController reaktif addToCart, removeFromCart, totalItem, totalHarga', () {
    final controller = CartController();

    expect(controller.totalItem, 0);
    expect(controller.totalHarga, 0.0);

    final product1 = dummyProducts[0]; // MacBook Air M2, diskon 10% dari 16.499.000 -> 14.849.100
    final product2 = dummyProducts[1]; // Smartphone Galaxy S24, diskon 12% dari 13.999.000 -> 12.319.120

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
}
