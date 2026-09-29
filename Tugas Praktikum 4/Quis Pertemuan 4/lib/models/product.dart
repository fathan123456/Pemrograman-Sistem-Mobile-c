// ignore_for_file: avoid_print

import 'dart:io';

// ============================================================================
// 1. VARIABEL & TIPE DATA (LANGKAH 1)
// ============================================================================
const String namaToko = 'TokoKita';
final DateTime tanggalDibuat = DateTime.now();
const List<String> kategoriList = ['Elektronik', 'Fashion', 'Makanan'];

final Map<String, dynamic> produkMentah = {
  'id': 101,
  'name': 'Mouse Wireless',
  'price': 125000.0,
  'category': 'Elektronik',
  'stock': 15,
};

// ============================================================================
// 2. HELPER FUNCTIONS & LOGIKA DISKON (LANGKAH 3 & 4, TUGAS MANDIRI 3)
// ============================================================================
// Langkah 4 Butir 3: Arrow function pemformatan mata uang rupiah
String formatRupiah(num harga) =>
    'Rp ${harga.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

// Langkah 3 Butir 4: Switch-case penentuan diskon berdasarkan kategori
double hitungDiskonKategori(String kategori) {
  switch (kategori.toLowerCase()) {
    case 'elektronik':
      return 10.0;
    case 'fashion':
      return 15.0;
    case 'makanan':
      return 5.0;
    default:
      return 0.0;
  }
}

// Langkah 4 Butir 1 & 2: Function dengan named optional parameter & nilai default
double hitungHargaSetelahDiskon(double harga, {double persenDiskon = 0.0}) {
  return harga - (harga * (persenDiskon / 100.0));
}

// Tugas Mandiri 3 & Langkah 3 Butir 2: Perulangan for menghitung total belanja
double hitungTotalBelanja(List<Product> keranjang) {
  double total = 0.0;
  for (var p in keranjang) {
    total += p.price;
  }
  return total;
}

// ============================================================================
// 3. CLASS MODEL, INHERITANCE & NULL SAFETY (LANGKAH 5 & TUGAS MANDIRI 1)
// ============================================================================
class Product {
  int id;
  String name;
  double price;
  String category;
  int stock;
  String? imageUrl; // Nullable: tanda ? mengizinkan null (Langkah 5 Butir 4)
  String? description; // Nullable: tanda ? mengizinkan null

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.stock,
    this.imageUrl,
    this.description,
  });

  // Tugas Mandiri 1 & Langkah 3 Butir 1 (if-else penentuan status ketersediaan)
  String getStatusStok() {
    if (stock > 5) return 'Tersedia';
    if (stock > 0) return 'Stok Terbatas';
    return 'Habis';
  }

  String get formattedPrice => formatRupiah(price);
}

// Langkah 5 Butir 2: Inheritance class turunan DiscountedProduct
class DiscountedProduct extends Product {
  double discountPercent;

  DiscountedProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
    required super.stock,
    super.imageUrl,
    super.description,
    required this.discountPercent,
  });

  double hitungHargaFinal() => price - (price * (discountPercent / 100.0));
  String get formattedFinalPrice => formatRupiah(hitungHargaFinal());
}

// ============================================================================
// 4. DATA DUMMY (TUGAS MANDIRI 2: MINIMAL 8 PRODUK)
// ============================================================================
final List<Product> dummyProducts = [
  DiscountedProduct(
    id: 1,
    name: 'MacBook Air M2 256GB',
    price: 16499000,
    category: 'Elektronik',
    stock: 8,
    description: 'Chip Apple M2, Layar Liquid Retina 13.6 inci',
    discountPercent: 10,
  ),
  DiscountedProduct(
    id: 2,
    name: 'Smartphone Galaxy S24',
    price: 13999000,
    category: 'Gadget',
    stock: 4,
    description: 'Layar Dynamic AMOLED 2X 120Hz & Galaxy AI',
    discountPercent: 15,
  ),
  Product(
    id: 3,
    name: 'Sony WH-1000XM5 Headphone',
    price: 4799000,
    category: 'Elektronik',
    stock: 12,
    description: 'Peredam bising terdepan di industri & Hi-Res Audio',
  ),
  DiscountedProduct(
    id: 4,
    name: 'Sepatu Nike Air Jordan 1 Retro',
    price: 2499000,
    category: 'Fashion',
    stock: 3,
    description: 'Material premium leather, sol empuk anti-selip',
    discountPercent: 20,
  ),
  Product(
    id: 5,
    name: 'Jaket Denim Oversized Vintage',
    price: 349000,
    category: 'Fashion',
    stock: 18,
    description: 'Bahan denim tebal 14oz washed style klasik',
  ),
  DiscountedProduct(
    id: 6,
    name: 'Kopi Arabika Gayo Single Origin 250g',
    price: 85000,
    category: 'Makanan',
    stock: 35,
    description: 'Notes aroma floral & fruity, medium roast segar',
    discountPercent: 15,
  ),
  Product(
    id: 7,
    name: 'Matcha Latte Bubuk Premium 500g',
    price: 120000,
    category: 'Makanan',
    stock: 22,
    description: 'Bubuk green tea murni dari perkebunan Uji Jepang',
  ),
  DiscountedProduct(
    id: 8,
    name: 'Apple Watch Series 9 GPS 45mm',
    price: 6999000,
    category: 'Gadget',
    stock: 6,
    description: 'Always-On Retina display & sensor kesehatan lengkap',
    discountPercent: 12,
  ),
  Product(
    id: 9,
    name: 'Logitech MX Master 3S Wireless Mouse',
    price: 1450000,
    category: 'Elektronik',
    stock: 15,
    description: 'Scroll elektromagnetik super senyap dengan 8K DPI',
  ),
  DiscountedProduct(
    id: 10,
    name: 'Keyboard Mechanical RGB Keychron K2',
    price: 1290000,
    category: 'Elektronik',
    stock: 9,
    description: 'Wireless Bluetooth/Wired, Gateron Brown Switch',
    discountPercent: 18,
  ),
  Product(
    id: 11,
    name: 'Tas Ransel Anti Air Roll-Top 25L',
    price: 285000,
    category: 'Aksesoris',
    stock: 20,
    description: 'Kompartemen laptop 15.6 inch, bahan bimo waterproof',
  ),
  DiscountedProduct(
    id: 12,
    name: 'Kaos Polos Katun Combed 30s',
    price: 85000,
    category: 'Fashion',
    stock: 40,
    description: 'Bahan super adem, menyerap keringat, jahitan rantai',
    discountPercent: 25,
  ),
  Product(
    id: 13,
    name: 'Kacamata Hitam Polarized UV400',
    price: 165000,
    category: 'Aksesoris',
    stock: 25,
    description: 'Frame titanium ringan lensa polarized anti silau',
  ),
  DiscountedProduct(
    id: 14,
    name: 'Croissant Butter Almond Box of 4',
    price: 95000,
    category: 'Makanan',
    stock: 10,
    description: 'Fresh baked harian, wangi butter Prancis asli',
    discountPercent: 10,
  ),
  Product(
    id: 15,
    name: 'Susu Oat Barista Blend 1 Liter',
    price: 48000,
    category: 'Makanan',
    stock: 30,
    description: 'Bebas laktosa, foam lembut dan gurih alami',
  ),
  DiscountedProduct(
    id: 16,
    name: 'Anker 65W GaN Fast Charger 3-Port',
    price: 499000,
    category: 'Gadget',
    stock: 14,
    description: 'Fast charging untuk laptop, tablet, dan ponsel',
    discountPercent: 20,
  ),
  Product(
    id: 17,
    name: 'Dompet Kulit Asli Bifold Minimalis',
    price: 215000,
    category: 'Aksesoris',
    stock: 12,
    description: 'Crazy horse genuine leather dengan RFID blocker',
  ),
  DiscountedProduct(
    id: 18,
    name: 'Speaker Bluetooth Marshall Emberton II',
    price: 2690000,
    category: 'Elektronik',
    stock: 7,
    description: 'True Stereophonic 360 derajat, tahan air IP67',
    discountPercent: 15,
  ),
  Product(
    id: 19,
    name: 'Hoodie Champion Reverse Weave Heavy',
    price: 650000,
    category: 'Fashion',
    stock: 16,
    description: 'Bahan fleece tebal premium dan nyaman dipakai',
  ),
  DiscountedProduct(
    id: 20,
    name: 'Powerbank Xiaomi 20000mAh 50W',
    price: 389000,
    category: 'Gadget',
    stock: 11,
    description: 'Support fast charge laptop dan gadget via Type-C',
    discountPercent: 22,
  ),
  Product(
    id: 21,
    name: 'Celana Jeans Slim Tapered 512',
    price: 799000,
    category: 'Fashion',
    stock: 8,
    description: 'Bahan denim stretch fleksibel dan tahan lama',
  ),
  DiscountedProduct(
    id: 22,
    name: 'Snack Almond Roasted Gurih 500g',
    price: 110000,
    category: 'Makanan',
    stock: 28,
    description: 'Kacang almond panggang renyah tanpa minyak',
    discountPercent: 15,
  ),
  Product(
    id: 23,
    name: 'Smart Lampu Meja LED Eye-Care',
    price: 299000,
    category: 'Elektronik',
    stock: 13,
    description: 'Temperatur warna dapat diatur, anti flicker',
  ),
  DiscountedProduct(
    id: 24,
    name: 'Jam Tangan Sport Chronograph Steel',
    price: 850000,
    category: 'Aksesoris',
    stock: 3,
    description: 'Water resistant 50M, strap stainless steel elegan',
    discountPercent: 30,
  ),
  Product(
    id: 25,
    name: 'Sandal Gunung Outdoor Ergonomis',
    price: 175000,
    category: 'Fashion',
    stock: 0,
    description: 'Sol grip cengkram kuat anti-slip saat hiking',
  ),
];

// List dinamis yang digunakan oleh program untuk operasi CRUD dan transaksi
List<Product> products = List<Product>.from(dummyProducts);

// ============================================================================
// 5. FITUR CRUD & TAMPILAN TABEL
// ============================================================================

// [READ] Menampilkan tabel produk secara rapi
void tampilkanTabel(List<Product> list) {
  const garis =
      '+----+-------------------------+---------------+-------+----------------+---------------+';
  print(garis);
  print(
    '| ID | ${'Nama Produk'.padRight(23)} | ${'Kategori'.padRight(13)} | ${'Stok'.padRight(5)} | ${'Harga'.padRight(14)} | ${'Status Stok'.padRight(13)} |',
  );
  print(garis);
  for (var p in list) {
    print(
      '| ${p.id.toString().padRight(2)} | ${p.name.padRight(23)} | ${p.category.padRight(13)} | ${p.stock.toString().padRight(5)} | ${p.formattedPrice.padRight(14)} | ${p.getStatusStok().padRight(13)} |',
    );
  }
  print(garis);
  print('${list.length} produk ditampilkan.\n');
}

// [CREATE] Menambah produk baru ke dalam katalog
void tambahProduk() {
  print('\n--- [CREATE] Tambah Produk Baru ---');
  stdout.write('Nama Produk : ');
  final name = stdin.readLineSync()?.trim() ?? '';
  if (name.isEmpty) {
    print('Error: Nama produk tidak boleh kosong!\n');
    return;
  }

  stdout.write('Kategori (Elektronik/Fashion/Makanan): ');
  final category = stdin.readLineSync()?.trim() ?? 'Umum';

  stdout.write('Harga       : ');
  final price = double.tryParse(stdin.readLineSync()?.trim() ?? '') ?? 0.0;

  stdout.write('Stok Awal   : ');
  final stock = int.tryParse(stdin.readLineSync()?.trim() ?? '') ?? 0;

  stdout.write('Deskripsi (Opsional, Enter jika kosong): ');
  final descInput = stdin.readLineSync()?.trim();
  final String? desc = (descInput == null || descInput.isEmpty)
      ? null
      : descInput;

  final newId = products.isEmpty
      ? 1
      : (products.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1);
  products.add(
    Product(
      id: newId,
      name: name,
      price: price,
      category: category,
      stock: stock,
      description: desc,
    ),
  );
  print('Sukses: Produk "$name" berhasil ditambahkan dengan ID $newId.\n');
}

// [UPDATE] Mengubah data produk atau menambah/mengedit stok
void ubahProduk() {
  print('\n--- [UPDATE] Ubah Data Produk & Stok ---');
  tampilkanTabel(products);
  stdout.write('Masukkan ID produk yang ingin diedit: ');
  final id = int.tryParse(stdin.readLineSync()?.trim() ?? '') ?? -1;
  final index = products.indexWhere((p) => p.id == id);

  if (index == -1) {
    print('Error: Produk dengan ID $id tidak ditemukan!\n');
    return;
  }

  final p = products[index];
  print(
    '\nMengedit "${p.name}" (Tekan Enter langsung jika tidak ingin mengubah):',
  );

  stdout.write('Nama baru [${p.name}]: ');
  final name = stdin.readLineSync()?.trim();

  stdout.write('Kategori baru [${p.category}]: ');
  final category = stdin.readLineSync()?.trim();

  stdout.write('Harga baru [${p.price.toInt()}]: ');
  final priceStr = stdin.readLineSync()?.trim();

  stdout.write('Stok baru [${p.stock}]: ');
  final stockStr = stdin.readLineSync()?.trim();

  if (name != null && name.isNotEmpty) {
    p.name = name;
  }
  if (category != null && category.isNotEmpty) {
    p.category = category;
  }
  if (priceStr != null && priceStr.isNotEmpty) {
    p.price = double.tryParse(priceStr) ?? p.price;
  }
  if (stockStr != null && stockStr.isNotEmpty) {
    p.stock = int.tryParse(stockStr) ?? p.stock;
  }

  print('Sukses: Data produk ID $id ("${p.name}") berhasil diperbarui.\n');
}

// [DELETE] Menghapus produk dari sistem
void hapusProduk() {
  print('\n--- [DELETE] Hapus Produk ---');
  tampilkanTabel(products);
  stdout.write('Masukkan ID produk yang ingin dihapus: ');
  final id = int.tryParse(stdin.readLineSync()?.trim() ?? '') ?? -1;
  final initialCount = products.length;
  products.removeWhere((p) => p.id == id);

  if (products.length < initialCount) {
    print('Sukses: Produk dengan ID $id berhasil dihapus.\n');
  } else {
    print('Error: Produk dengan ID $id tidak ditemukan!\n');
  }
}

// ============================================================================
// 6. FITUR TRANSAKSI INTERAKTIF: BELI BARANG, PILIH STOK & DISKON KATEGORI
// ============================================================================
void beliProduk() {
  print('\n--- [TRANSAKSI] Pembelian Produk & Diskon Kategori ---');
  tampilkanTabel(products);

  // 1. Pilih barang mana yang ingin dibeli
  stdout.write('Masukkan ID produk yang ingin dibeli: ');
  final id = int.tryParse(stdin.readLineSync()?.trim() ?? '') ?? -1;
  final index = products.indexWhere((p) => p.id == id);

  if (index == -1) {
    print('Error: Produk dengan ID $id tidak ditemukan!\n');
    return;
  }

  final p = products[index];

  // Cek ketersediaan stok
  if (p.stock <= 0) {
    print(
      'Pemberitahuan: Stok barang "${p.name}" sedang HABIS (${p.getStatusStok()})!\n',
    );
    return;
  }

  // 2. Pilih mau beli berapa stok
  print('\nProduk Dipilih : ${p.name}');
  print('Kategori       : ${p.category}');
  print('Harga Satuan   : ${p.formattedPrice}');
  print('Stok Tersedia  : ${p.stock} item (${p.getStatusStok()})');
  stdout.write('Mau beli berapa stok? (1 - ${p.stock}): ');
  final qty = int.tryParse(stdin.readLineSync()?.trim() ?? '') ?? 0;

  if (qty <= 0) {
    print('Error: Jumlah pembelian harus lebih dari 0!\n');
    return;
  }
  if (qty > p.stock) {
    print(
      'Error: Stok tidak mencukupi! Anda meminta $qty, namun stok hanya tersisa ${p.stock}.\n',
    );
    return;
  }

  // 3. Kalkulasi Diskon Kategori & Pemotongan Stok
  final persenDiskon = hitungDiskonKategori(p.category);
  final subtotal = p.price * qty;
  final hargaSetelahDiskonSatuan = hitungHargaSetelahDiskon(
    p.price,
    persenDiskon: persenDiskon,
  );
  final totalBayar = hargaSetelahDiskonSatuan * qty;
  final hemat = subtotal - totalBayar;

  // Stok berkurang secara realtime di list
  p.stock -= qty;

  // 4. Tampilkan Struk Pembelian
  print('\n================== STRUK PEMBELIAN ==================');
  print('Toko           : $namaToko');
  print('Waktu          : ${DateTime.now().toString().substring(0, 19)}');
  print('-----------------------------------------------------');
  print('Barang Dibeli  : ${p.name}');
  print('Kategori       : ${p.category}');
  print('Harga Satuan   : ${p.formattedPrice}');
  print('Jumlah Beli    : $qty item');
  print('Subtotal       : ${formatRupiah(subtotal)}');
  print('Diskon Kategori: $persenDiskon% (Kategori ${p.category})');
  if (persenDiskon > 0) {
    print('Hemat Diskon   : -${formatRupiah(hemat)}');
  }
  print('-----------------------------------------------------');
  print('TOTAL BAYAR    : ${formatRupiah(totalBayar)}');
  print('SISA STOK KINI : ${p.stock} (${p.getStatusStok()})');
  print('=====================================================');
  print('Transaksi Berhasil! Stok barang telah diperbarui secara realtime.\n');
}

// ============================================================================
// 7. PENGUJIAN OTOMATIS LANGKAH 1 - 5 (UNTUK LAPORAN PRAKTIKUM)
// ============================================================================
void ujiPraktikum() {
  print('\n============================================================');
  print('        HASIL PENGUJIAN LEMBAR KERJA PRAKTIKUM 2            ');
  print('============================================================');

  // Langkah 1: Variabel & Tipe Data
  print('\n[LANGKAH 1] Variabel & Tipe Data:');
  var namaKasir = 'Bastian';
  int contohStok = 20;
  double contohHarga = 150000.0;
  String contohNama = 'Keyboard Gaming';
  bool statusTersedia = contohStok > 0;
  print('- const (Nama Toko) : $namaToko');
  print('- final (Tgl Buat)  : $tanggalDibuat');
  print('- var   (Kasir)     : $namaKasir');
  print(
    '- int, double, String, bool: $contohNama | Stok: $contohStok | Harga: ${formatRupiah(contohHarga)} | Tersedia: $statusTersedia',
  );
  print('- List kategori     : $kategoriList');
  print('- Map data mentah   : $produkMentah');

  // Langkah 2: Operator Perhitungan Harga & Logika
  print('\n[LANGKAH 2] Operator Perhitungan Harga & Logika:');
  int beliItem = 3;
  double totalAritmatika = contohHarga * beliItem;
  int sisaStok = contohStok - beliItem;
  double rataRata = totalAritmatika / beliItem;
  int sisaBagi = contohStok % beliItem;
  print('- Aritmatika (+, -, *, /, %):');
  print(
    '  * Total $beliItem item: ${formatRupiah(totalAritmatika)} (Operator *)',
  );
  print('  * Sisa stok: $sisaStok (Operator -)');
  print('  * Rata-rata per item: ${formatRupiah(rataRata)} (Operator /)');
  print('  * Modulo stok (20 % 3): $sisaBagi (Operator %)');
  print('- Perbandingan (==, !=, >, <):');
  print('  * Harga > 100.000? ${contohHarga > 100000}');
  print(
    '  * Stok laptop == Stok smartphone? ${dummyProducts[0].stock == dummyProducts[1].stock}',
  );
  print('- Logika (&&, ||, !):');
  bool layakTampil = contohStok > 0 && contohHarga > 0;
  print('  * Layak tampil (stok > 0 && harga > 0): $layakTampil');

  // Langkah 3: Control Flow (if-else, for, while, switch)
  print('\n[LANGKAH 3] Control Flow Toko:');
  print('- if-else (Status Stok):');
  print(
    '  * Stok ${dummyProducts[0].stock} : ${dummyProducts[0].getStatusStok()}',
  );
  print(
    '  * Stok ${dummyProducts[1].stock} : ${dummyProducts[1].getStatusStok()}',
  );
  print(
    '  * Stok ${dummyProducts[5].stock} : ${dummyProducts[5].getStatusStok()}',
  );
  print('- switch-case (Diskon Kategori):');
  for (var k in kategoriList) {
    print('  * Kategori $k -> diskon: ${hitungDiskonKategori(k)}%');
  }
  print(
    '- for loop (Total Belanja Dummy): ${formatRupiah(hitungTotalBelanja(dummyProducts))}',
  );
  print('- while loop (Simulasi pengurangan stok satu per satu hingga habis):');
  int stokSimulasi = 4;
  stdout.write('  Simulasi: ');
  while (stokSimulasi > 0) {
    stdout.write('Stok $stokSimulasi -> ');
    stokSimulasi--;
  }
  print('Stok 0 (Habis)');

  // Langkah 4: Function untuk Logika Produk & Diskon
  print('\n[LANGKAH 4] Function & Arrow Function:');
  double hargaAwal = 250000;
  double hDiskon = hitungHargaSetelahDiskon(hargaAwal, persenDiskon: 20);
  double hTanpaDiskon = hitungHargaSetelahDiskon(hargaAwal); // default optional
  print('- hitungHargaSetelahDiskon (named optional):');
  print('  * Harga Rp 250.000 dengan diskon 20%   : ${formatRupiah(hDiskon)}');
  print(
    '  * Harga Rp 250.000 tanpa argumen diskon : ${formatRupiah(hTanpaDiskon)}',
  );
  print('- arrow function formatRupiah           : ${formatRupiah(1250000)}');

  // Langkah 5: Class Product & Null Safety + OOP Inheritance
  print('\n[LANGKAH 5] Class Product & Null Safety:');
  final pContoh = Product(
    id: 99,
    name: 'Earphone TWS',
    price: 180000,
    category: 'Elektronik',
    stock: 7,
    description: null, // Nullable field (String?)
  );
  print(
    '- Instance Product: ID ${pContoh.id} | ${pContoh.name} | Harga: ${pContoh.formattedPrice} | Status: ${pContoh.getStatusStok()}',
  );
  print(
    '- Null Safety: pContoh.description bernilai null -> "${pContoh.description}" (Diizinkan karena bertipe String?)',
  );

  final dp = DiscountedProduct(
    id: 100,
    name: 'Smartwatch Pro',
    price: 500000,
    category: 'Elektronik',
    stock: 5,
    discountPercent: 25,
  );
  print('- Inheritance DiscountedProduct:');
  print('  * Produk: ${dp.name} | Harga Normal: ${dp.formattedPrice}');
  print(
    '  * Diskon: ${dp.discountPercent}% | Harga Final: ${dp.formattedFinalPrice}',
  );

  print('\n[TUGAS MANDIRI]');
  print(
    '- 1. Method tambahan getStatusStok(): Sukses diimplementasikan pada class Product.',
  );
  print(
    '- 2. List<Product> data dummy: ${dummyProducts.length} produk siap digunakan.',
  );
  print(
    '- 3. Total belanja data dummy: ${formatRupiah(hitungTotalBelanja(dummyProducts))}',
  );
  print('============================================================\n');
}

// ============================================================================
// 8. PROGRAM UTAMA (CLI INTERAKTIF)
// ============================================================================
void main() {
  while (true) {
    print('============================================');
    print('      SISTEM CRUD & KASIR TOKOKITA          ');
    print('============================================');
    print('[1] Tampilkan Semua Produk (Read / Tabel)');
    print('[2] Beli Produk (Pilih Barang, Stok, & Diskon)');
    print('[3] Tambah Produk Baru (Create)');
    print('[4] Ubah Data Produk / Update Stok (Update)');
    print('[5] Hapus Produk (Delete)');
    print('[6] Jalankan Uji Lengkap Modul Praktikum');
    print('[0] Keluar');
    stdout.write('Pilih menu [0-6]: ');
    final input = stdin.readLineSync()?.trim();

    if (input == null || input == '0') {
      print('\nKeluar dari program. Terima kasih telah menggunakan TokoKita!');
      break;
    }

    switch (input) {
      case '1':
        tampilkanTabel(products);
        break;
      case '2':
        beliProduk();
        break;
      case '3':
        tambahProduk();
        break;
      case '4':
        ubahProduk();
        break;
      case '5':
        hapusProduk();
        break;
      case '6':
        ujiPraktikum();
        break;
      default:
        print('Pilihan tidak valid! Silakan masukkan angka 0-6.\n');
    }

    stdout.write('Tekan Enter untuk kembali ke menu utama...');
    stdin.readLineSync();
    print('');
  }
}
