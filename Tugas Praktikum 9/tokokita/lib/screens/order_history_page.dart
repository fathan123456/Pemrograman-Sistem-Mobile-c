import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/order_model.dart';
import '../services/order_database.dart';

/// Halaman Riwayat Pesanan (Langkah 4)
/// Menampilkan daftar seluruh riwayat pesanan dari database SQLite (sqflite)
/// Mendukung operasi CRUD: Read (getAllOrders), Update (updateOrderStatus), Delete (deleteOrder).
class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  bool _isLoading = true;
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    // Langkah 4 Butir 2: Ambil seluruh riwayat pesanan saat halaman dibuka
    _loadOrders();
  }

  /// Langkah 4 Butir 2: Method getAllOrders untuk mengambil seluruh riwayat pesanan
  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final orders = await OrderDatabase.instance.getAllOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('--> [OrderHistoryPage] Gagal memuat pesanan: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Langkah 4 Butir 3: Mengubah status sebuah pesanan (misal: 'Diproses' -> 'Selesai')
  Future<void> _changeStatus(OrderModel order, String newStatus) async {
    if (order.id == null) return;

    try {
      await OrderDatabase.instance.updateOrderStatus(order.id!, newStatus);
      await _loadOrders();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status pesanan #${order.id} diubah menjadi "$newStatus"'),
            duration: const Duration(seconds: 2),
            backgroundColor: newStatus == 'Selesai'
                ? const Color(0xFF16A34A)
                : Colors.deepPurple,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('--> [OrderHistoryPage] Gagal update status: $e');
    }
  }

  /// Langkah 4 Butir 4: Menghapus salah satu riwayat pesanan dan meng-update tampilan
  Future<void> _confirmDeleteOrder(OrderModel order) async {
    if (order.id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626)),
            SizedBox(width: 8),
            Text('Hapus Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus riwayat pesanan #${order.id} dari database SQLite?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await OrderDatabase.instance.deleteOrder(order.id!);
        // Refresh tampilan secara langsung
        await _loadOrders();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pesanan #${order.id} berhasil dihapus dari database'),
              duration: const Duration(seconds: 2),
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        debugPrint('--> [OrderHistoryPage] Gagal menghapus pesanan: $e');
      }
    }
  }

  // Helper warna badge status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return const Color(0xFF16A34A); // Hijau
      case 'diproses':
        return const Color(0xFFD97706); // Amber
      case 'dibatalkan':
        return const Color(0xFFDC2626); // Merah
      default:
        return Colors.deepPurple;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return const Color(0xFFDCFCE7);
      case 'diproses':
        return const Color(0xFFFEF3C7);
      case 'dibatalkan':
        return const Color(0xFFFEE2E2);
      default:
        return Colors.deepPurple.withValues(alpha: 0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Riwayat Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
          tooltip: 'Kembali',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.deepPurple),
            onPressed: _loadOrders,
            tooltip: 'Segarkan Riwayat',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : _orders.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  color: Colors.deepPurple,
                  onRefresh: _loadOrders,
                  // Langkah 4 Butir 2: Menggunakan ListView untuk menampilkan seluruh riwayat pesanan
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _orders.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      return _buildOrderCard(order);
                    },
                  ),
                ),
    );
  }

  /// Tampilan ketika belum ada pesanan yang tercatat
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum Ada Riwayat Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pesanan yang Anda buat melalui keranjang checkout akan tersimpan di database SQLite dan ditampilkan di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.shopping_cart_checkout, size: 18),
              label: const Text('Mulai Belanja'),
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
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu kartu riwayat pesanan (ListView Item)
  Widget _buildOrderCard(OrderModel order) {
    final statusColor = _getStatusColor(order.status);
    final statusBgColor = _getStatusBgColor(order.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu: ID Pesanan & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.receipt_outlined,
                      size: 18,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Pesanan #${order.id}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 3.5,
                      backgroundColor: statusColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      order.status,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Tanggal Pesanan
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 6),
              Text(
                order.tanggal,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // Rincian Daftar Item
          const Text(
            'Daftar Item:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.daftarItem,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
              height: 1.4,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // Total Harga & Aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.formattedTotalHarga,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),

              // Tombol-tombol Aksi CRUD (Update status & Delete)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Langkah 4 Butir 3: Tombol Ubah Status Pesanan
                  if (order.status.toLowerCase() == 'diproses')
                    ElevatedButton.icon(
                      onPressed: () => _changeStatus(order, 'Selesai'),
                      icon: const Icon(Icons.check, size: 14),
                      label: const Text('Selesaikan', style: TextStyle(fontSize: 11)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),

                  // Popup Menu untuk opsi ubah status lainnya
                  PopupMenuButton<String>(
                    tooltip: 'Ubah Status',
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                    onSelected: (newStatus) => _changeStatus(order, newStatus),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Diproses',
                        child: Row(
                          children: [
                            Icon(Icons.hourglass_empty_rounded, size: 18, color: Color(0xFFD97706)),
                            SizedBox(width: 8),
                            Text('Tandai Diproses'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Selesai',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF16A34A)),
                            SizedBox(width: 8),
                            Text('Tandai Selesai'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Dibatalkan',
                        child: Row(
                          children: [
                            Icon(Icons.cancel_outlined, size: 18, color: Color(0xFFDC2626)),
                            SizedBox(width: 8),
                            Text('Tandai Dibatalkan'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Langkah 4 Butir 4: Tombol Hapus Pesanan (Delete)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFDC2626),
                      size: 20,
                    ),
                    tooltip: 'Hapus Pesanan',
                    onPressed: () => _confirmDeleteOrder(order),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
