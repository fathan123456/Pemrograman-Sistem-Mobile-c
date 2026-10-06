import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/models/product.dart';

void main() {
  testWidgets('Langkah 1: Header App Bar dengan Row & Column serta ikon keranjang', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());

    // Memverifikasi judul dan subjudul
    expect(find.text('TokoKita'), findsOneWidget);
    expect(find.text('Belanja jadi lebih mudah'), findsOneWidget);

    // Memverifikasi ikon keranjang belanja
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
  });

  testWidgets('Langkah 3: Badge Diskon hanya muncul pada DiscountedProduct', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());

    // Memverifikasi badge 'Diskon' muncul pada produk diskon
    expect(find.text('Diskon'), findsWidgets);

    // Verifikasi produk diskon tampil di katalog awal
    expect(find.text('MacBook Air M2 256GB'), findsOneWidget);
    expect(find.text('Smartphone Galaxy S24'), findsOneWidget);
  });

  testWidgets('Langkah 4: ListView.builder dapat me-render dan scroll 25 data produk', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());

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

    // Tap kategori 'Makanan'
    await tester.tap(find.text('Makanan'));
    await tester.pumpAndSettle();

    // Produk makanan harus muncul
    expect(find.text('Kopi Arabika Gayo Single Origin 250g'), findsOneWidget);
  });
}
