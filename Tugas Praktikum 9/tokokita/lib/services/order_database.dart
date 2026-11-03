import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/order_model.dart';

/// Helper class OrderDatabase untuk mengelola database SQLite TokoKita (Langkah 3 & 4)
/// Menginisialisasi database dan menangani operasi CRUD untuk tabel orders.
class OrderDatabase {
  static final OrderDatabase instance = OrderDatabase._init();
  static Database? _database;

  OrderDatabase._init();

  /// Mendapatkan instance database yang sudah terbuka (atau menginisialisasinya)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tokokita_orders.db');
    return _database!;
  }

  /// Inisialisasi database dengan path yang sesuai
  Future<Database> _initDB(String filePath) async {
    // Inisialisasi SQLite FFI jika berjalan di platform Windows, Linux, atau testing desktop
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Buka database dan buat tabel orders jika belum ada
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Langkah 3 Butir 2: Pembuatan tabel orders
  /// Kolom: id (INTEGER PRIMARY KEY AUTOINCREMENT),
  /// tanggal (TEXT), daftarItem (TEXT), totalHarga (REAL), status (TEXT)
  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE orders (
        id $idType,
        tanggal $textType,
        daftarItem $textType,
        totalHarga $realType,
        status $textType
      )
    ''');
    debugPrint('--> [OrderDatabase] Tabel "orders" berhasil dibuat.');
  }

  // ==========================================================================
  // OPERASI CRUD (LANGKAH 4)
  // ==========================================================================

  /// Langkah 4 Butir 1: Menyimpan data pesanan baru ke tabel orders (Create)
  Future<int> insertOrder(OrderModel order) async {
    final db = await database;
    final id = await db.insert('orders', order.toMap());
    debugPrint('--> [OrderDatabase] insertOrder berhasil, id: $id');
    return id;
  }

  /// Langkah 4 Butir 2: Mengambil seluruh riwayat pesanan dari tabel orders (Read)
  /// Diurutkan berdasarkan id DESC (pesanan terbaru di atas)
  Future<List<OrderModel>> getAllOrders() async {
    final db = await database;
    final result = await db.query('orders', orderBy: 'id DESC');
    debugPrint('--> [OrderDatabase] getAllOrders mengembalikan ${result.length} pesanan.');
    return result.map((json) => OrderModel.fromMap(json)).toList();
  }

  /// Langkah 4 Butir 3: Mengubah status sebuah pesanan (Update)
  /// Misalnya mengubah status dari 'Diproses' menjadi 'Selesai'
  Future<int> updateOrderStatus(int id, String newStatus) async {
    final db = await database;
    final count = await db.update(
      'orders',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('--> [OrderDatabase] updateOrderStatus id: $id menjadi "$newStatus" ($count baris terupdate).');
    return count;
  }

  /// Langkah 4 Butir 4: Menghapus salah satu riwayat pesanan (Delete)
  Future<int> deleteOrder(int id) async {
    final db = await database;
    final count = await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('--> [OrderDatabase] deleteOrder id: $id ($count baris terhapus).');
    return count;
  }

  /// Menutup koneksi database (berguna saat pengujian atau logout)
  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}
