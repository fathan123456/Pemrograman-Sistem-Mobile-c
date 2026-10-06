import 'package:flutter/material.dart';

/// Halaman placeholder untuk Profil Pengguna pada Bottom Navigation (Langkah 5)
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Header Profil
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.deepPurple.withValues(alpha: 0.15),
                    child: const Icon(
                      Icons.person,
                      size: 54,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Pengguna TokoKita',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'mahasiswa@tokokita.id',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 28),

            // Menu Pengaturan Profil
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined, color: Colors.deepPurple),
                    title: const Text('Riwayat Transaksi'),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, color: Color(0xFFF1F5F9)),
                  ListTile(
                    leading: const Icon(Icons.favorite_outline_rounded, color: Colors.deepPurple),
                    title: const Text('Favorit Saya'),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, color: Color(0xFFF1F5F9)),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined, color: Colors.deepPurple),
                    title: const Text('Pengaturan Akun'),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, color: Color(0xFFF1F5F9)),
                  ListTile(
                    leading: const Icon(Icons.help_outline_rounded, color: Colors.deepPurple),
                    title: const Text('Pusat Bantuan'),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
