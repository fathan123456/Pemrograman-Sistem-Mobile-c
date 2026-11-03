import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tokokita/controllers/cart_controller.dart';
import 'package:tokokita/models/order_model.dart';
import 'package:tokokita/models/product.dart';
import 'package:tokokita/screens/order_history_page.dart';
import 'package:tokokita/screens/profile_page.dart';
import 'package:tokokita/screens/wishlist_page.dart';
import 'package:tokokita/services/order_database.dart';
import 'package:tokokita/services/product_service.dart';
import 'package:tokokita/widgets/product_card.dart';

void main() {
  setUpAll(() {
    // Inisialisasi SQLite FFI untuk environment test desktop/VM
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
    ProductService.client = MockClient((request) async {
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

  group('Langkah 1 & 2: SharedPreferences — Wishlist', () {
    testWidgets('Langkah 1: ProductCard menyimpan dan memuat status favorit ke SharedPreferences', (tester) async {
      SharedPreferences.setMockInitialValues({
        'favorite_ids': ['1'],
      });

      final testProduct1 = dummyProducts.first; // id: 1
      final testProduct2 = dummyProducts[1]; // id: 2

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ProductCard(product: testProduct1),
                ProductCard(product: testProduct2),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Produk 1 (id: 1) harus tampil sebagai favorit (Icons.favorite_rounded)
      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
      // Produk 2 (id: 2) harus tampil belum favorit (Icons.favorite_border_rounded)
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

      // Tekan tombol favorit pada Produk 2 untuk menjadikannya favorit
      await tester.tap(find.byIcon(Icons.favorite_border_rounded));
      await tester.pumpAndSettle();

      // Sekarang kedua produk menjadi favorit
      expect(find.byIcon(Icons.favorite_rounded), findsNWidgets(2));

      // Verifikasi tersimpan di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedIds = prefs.getStringList('favorite_ids') ?? [];
      expect(savedIds.contains('1'), isTrue);
      expect(savedIds.contains('2'), isTrue);
    });

    testWidgets('Langkah 2: WishlistPage menampilkan produk tersimpan dan tombol hapus memperbarui SharedPreferences', (tester) async {
      // Siapkan SharedPreferences dengan ID produk 1 dan 2
      SharedPreferences.setMockInitialValues({
        'favorite_ids': ['1', '2'],
      });
      Get.put(CartController());

      await tester.pumpWidget(
        const GetMaterialApp(
          home: WishlistPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verifikasi judul AppBar
      expect(find.text('Wishlist Saya'), findsOneWidget);

      // Verifikasi kedua produk tampil di WishlistPage
      expect(find.text(dummyProducts[0].name), findsOneWidget);
      expect(find.text(dummyProducts[1].name), findsOneWidget);

      // Tekan tombol hapus pada produk pertama
      final deleteButtons = find.byTooltip('Hapus dari Wishlist');
      expect(deleteButtons, findsNWidgets(2));

      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      // Produk pertama sudah tidak ada di tampilan
      expect(find.text(dummyProducts[0].name), findsNothing);
      expect(find.text(dummyProducts[1].name), findsOneWidget);

      // Verifikasi data di SharedPreferences juga terhapus
      final prefs = await SharedPreferences.getInstance();
      final updatedIds = prefs.getStringList('favorite_ids') ?? [];
      expect(updatedIds.contains('1'), isFalse);
      expect(updatedIds.contains('2'), isTrue);
    });

    testWidgets('Langkah 2 Butir 3: Halaman Profil menghubungkan navigasi ke WishlistPage dan OrderHistoryPage', (tester) async {
      Get.put(CartController());
      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Favorit Saya (Wishlist)'), findsOneWidget);
      expect(find.text('Riwayat Transaksi'), findsOneWidget);

      // Tekan menu Favorit Saya (Wishlist)
      await tester.tap(find.text('Favorit Saya (Wishlist)'));
      await tester.pumpAndSettle();

      // Harus berpindah ke WishlistPage
      expect(find.byType(WishlistPage), findsOneWidget);
    });
  });

  group('Langkah 3 & 4: SQLite — Operasi CRUD Riwayat Pesanan', () {
    test('Langkah 3 & 4: OrderDatabase inisialisasi tabel orders dan eksekusi operasi CRUD lengkap', () async {
      final dbHelper = OrderDatabase.instance;
      final db = await dbHelper.database;
      expect(db.isOpen, isTrue);

      // Pastikan tabel kosong sebelum pengujian
      await db.delete('orders');

      // 1. Create (insertOrder)
      final order1 = OrderModel(
        tanggal: '23-10-2026 20:30',
        daftarItem: 'MacBook Air M2 256GB (1x)',
        totalHarga: 16499000.0,
        status: 'Diproses',
      );
      final id1 = await dbHelper.insertOrder(order1);
      expect(id1, greaterThan(0));

      final order2 = OrderModel(
        tanggal: '23-10-2026 21:00',
        daftarItem: 'Smartphone Galaxy S24 (1x), Kacamata Hitam (1x)',
        totalHarga: 14164000.0,
        status: 'Diproses',
      );
      final id2 = await dbHelper.insertOrder(order2);
      expect(id2, greaterThan(id1));

      // 2. Read (getAllOrders)
      final allOrders = await dbHelper.getAllOrders();
      expect(allOrders.length, 2);
      expect(allOrders.first.id, id2); // Urutan DESC
      expect(allOrders.first.status, 'Diproses');
      expect(allOrders.first.daftarItem, contains('Smartphone Galaxy S24'));

      // 3. Update (updateOrderStatus)
      final updateResult = await dbHelper.updateOrderStatus(id1, 'Selesai');
      expect(updateResult, 1);

      final updatedOrders = await dbHelper.getAllOrders();
      final updatedOrder1 = updatedOrders.firstWhere((o) => o.id == id1);
      expect(updatedOrder1.status, 'Selesai');

      // 4. Delete (deleteOrder)
      final deleteResult = await dbHelper.deleteOrder(id2);
      expect(deleteResult, 1);

      final remainingOrders = await dbHelper.getAllOrders();
      expect(remainingOrders.length, 1);
      expect(remainingOrders.first.id, id1);
    });

    test('Langkah 4 Butir 1: CartController.checkout() menyimpan pesanan baru ke tabel orders SQLite', () async {
      final dbHelper = OrderDatabase.instance;
      final db = await dbHelper.database;
      await db.delete('orders');

      final cartController = Get.put(CartController());
      cartController.clearCart();

      // Tambahkan item ke keranjang
      cartController.addToCart(dummyProducts[0], quantity: 2); // MacBook Air
      cartController.addToCart(dummyProducts[1], quantity: 1); // Galaxy S24

      expect(cartController.totalItem, 3);

      // Jalankan checkout dari CartController
      final createdOrder = await cartController.checkout();

      expect(createdOrder, isNotNull);
      expect(createdOrder!.id, greaterThan(0));
      expect(createdOrder.status, 'Diproses');
      expect(createdOrder.daftarItem, contains('MacBook Air M2 256GB (2x)'));
      expect(createdOrder.daftarItem, contains('Smartphone Galaxy S24 (1x)'));

      // Keranjang belanja harus kosong setelah checkout
      expect(cartController.totalItem, 0);

      // Verifikasi di SQLite
      final ordersFromDb = await dbHelper.getAllOrders();
      expect(ordersFromDb.length, 1);
      expect(ordersFromDb.first.id, createdOrder.id);
      expect(ordersFromDb.first.daftarItem, createdOrder.daftarItem);
    });

    testWidgets('Langkah 4 Butir 2, 3, 4: OrderHistoryPage menampilkan ListView pesanan, ubah status, dan hapus', (tester) async {
      final dbHelper = OrderDatabase.instance;
      final db = await dbHelper.database;
      await db.delete('orders');

      await dbHelper.insertOrder(
        OrderModel(
          tanggal: '23-10-2026 20:30',
          daftarItem: 'Sony WH-1000XM5 Headphone (1x)',
          totalHarga: 4799000.0,
          status: 'Diproses',
        ),
      );

      await tester.pumpWidget(
        const GetMaterialApp(
          home: OrderHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verifikasi elemen halaman Riwayat Pesanan
      expect(find.text('Riwayat Pesanan'), findsOneWidget);
      expect(find.textContaining('Sony WH-1000XM5 Headphone'), findsOneWidget);
      expect(find.text('Diproses'), findsOneWidget);
      expect(find.text('Selesaikan'), findsOneWidget);

      // Uji Langkah 4 Butir 3: Tekan tombol 'Selesaikan'
      await tester.tap(find.text('Selesaikan'));
      await tester.pumpAndSettle();

      // Status terupdate menjadi Selesai
      expect(find.text('Selesai'), findsOneWidget);

      // Uji Langkah 4 Butir 4: Hapus pesanan
      final deleteBtn = find.byTooltip('Hapus Pesanan');
      expect(deleteBtn, findsOneWidget);

      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      // Dialog konfirmasi muncul
      expect(find.text('Hapus Pesanan'), findsOneWidget);
      await tester.tap(find.text('Hapus'));
      await tester.pumpAndSettle();

      // Tampilan ter-update: item terhapus dan menampilkan empty state
      expect(find.text('Belum Ada Riwayat Pesanan'), findsOneWidget);
    });
  });
}
