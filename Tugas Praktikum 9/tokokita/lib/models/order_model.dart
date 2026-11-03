import 'product.dart';

/// Model data untuk pesanan (Langkah 3 & 4: SQLite Riwayat Pesanan)
/// Menyimpan informasi pesanan sesuai kolom database:
/// id, tanggal, daftarItem, totalHarga, status
class OrderModel {
  final int? id;
  final String tanggal;
  final String daftarItem;
  final double totalHarga;
  final String status;

  OrderModel({
    this.id,
    required this.tanggal,
    required this.daftarItem,
    required this.totalHarga,
    required this.status,
  });

  /// Konversi dari OrderModel ke Map untuk disimpan di database SQLite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'tanggal': tanggal,
      'daftarItem': daftarItem,
      'totalHarga': totalHarga,
      'status': status,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Membuat instance OrderModel dari Map hasil query SQLite
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as int?,
      tanggal: map['tanggal'] as String,
      daftarItem: map['daftarItem'] as String,
      totalHarga: (map['totalHarga'] as num).toDouble(),
      status: map['status'] as String,
    );
  }

  /// Helper untuk memformat total harga dalam format Rupiah
  String get formattedTotalHarga => formatRupiah(totalHarga);

  /// Salin objek dengan perubahan status atau atribut lainnya
  OrderModel copyWith({
    int? id,
    String? tanggal,
    String? daftarItem,
    double? totalHarga,
    String? status,
  }) {
    return OrderModel(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      daftarItem: daftarItem ?? this.daftarItem,
      totalHarga: totalHarga ?? this.totalHarga,
      status: status ?? this.status,
    );
  }
}
