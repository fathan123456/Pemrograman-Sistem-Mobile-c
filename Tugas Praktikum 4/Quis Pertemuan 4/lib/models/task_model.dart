/// Model data untuk tugas mahasiswa
class TaskModel {
  final String id;
  final String title;
  final String subject;
  final String deadline;
  final String description;
  final String priority;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.description,
    this.priority = 'Sedang',
    this.isCompleted = false,
  });

  /// Salin objek dengan beberapa field yang diperbarui
  TaskModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? deadline,
    String? description,
    String? priority,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      deadline: deadline ?? this.deadline,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Data dummy awal untuk memudahkan pengujian aplikasi saat pertama dijalankan
  static List<TaskModel> getInitialTasks() {
    return [
      TaskModel(
        id: '1',
        title: 'Tugas Praktikum 4: Custom Widget & Navigation',
        subject: 'Pemrograman Sistem Mobile',
        deadline: '30 September 2026',
        description:
            'Membuat aplikasi Flutter dengan minimal 3 screen, desain konsisten menggunakan custom widget, dan navigasi yang berfungsi baik.',
        priority: 'Tinggi',
        isCompleted: false,
      ),
      TaskModel(
        id: '2',
        title: 'Laporan Analisis Normalisasi Database',
        subject: 'Basis Data Lanjut',
        deadline: '03 Oktober 2026',
        description:
            'Menyusun query SQL dan laporan normalisasi 1NF sampai 3NF untuk sistem e-commerce.',
        priority: 'Sedang',
        isCompleted: false,
      ),
      TaskModel(
        id: '3',
        title: 'Review Jurnal Machine Learning',
        subject: 'Kecerdasan Buatan',
        deadline: '28 September 2026',
        description:
            'Membaca dan merangkum jurnal internasional tentang implementasi algoritma CNN untuk klasifikasi citra.',
        priority: 'Rendah',
        isCompleted: true,
      ),
    ];
  }
}
