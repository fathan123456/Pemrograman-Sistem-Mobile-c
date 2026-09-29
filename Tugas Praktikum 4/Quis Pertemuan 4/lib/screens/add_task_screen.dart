import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/custom_secondary_button.dart';
import '../widgets/custom_text_field.dart';

/// Screen 2: Form Input untuk Menambah Tugas Baru
/// Menggunakan CustomTextField, CustomPrimaryButton, dan CustomSecondaryButton.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap kolom input
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Pilihan prioritas aktif
  String _selectedPriority = 'Sedang';
  final List<String> _priorities = const ['Tinggi', 'Sedang', 'Rendah'];

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _deadlineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Menampilkan dialog pemilih tanggal (DatePicker)
  Future<void> _selectDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];
      final formatted =
          '${pickedDate.day.toString().padLeft(2, '0')} ${months[pickedDate.month - 1]} ${pickedDate.year}';
      setState(() {
        _deadlineController.text = formatted;
      });
    }
  }

  // Menyimpan tugas dan kembali ke halaman utama
  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        subject: _subjectController.text.trim(),
        deadline: _deadlineController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        isCompleted: false,
      );

      // Kembalikan data tugas baru ke screen sebelumnya
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Tambah Tugas',
        subtitle: 'Isi detail tugas kuliah baru',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Pembungkus Form
              CustomCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input 1: Judul Tugas
                    CustomTextField(
                      controller: _titleController,
                      label: 'Judul Tugas',
                      hintText: 'Misal: Laporan Praktikum Pertemuan 4',
                      prefixIcon: Icons.title_rounded,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Judul tugas wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Input 2: Mata Kuliah
                    CustomTextField(
                      controller: _subjectController,
                      label: 'Mata Kuliah',
                      hintText: 'Misal: Pemrograman Sistem Mobile',
                      prefixIcon: Icons.school_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Mata kuliah wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Input 3: Tenggat Waktu (Deadline) dengan DatePicker
                    CustomTextField(
                      controller: _deadlineController,
                      label: 'Tenggat Waktu (Deadline)',
                      hintText: 'Pilih batas waktu pengumpulan',
                      prefixIcon: Icons.calendar_month_outlined,
                      readOnly: true,
                      onTap: _selectDate,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Tenggat waktu wajib dipilih';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Input 4: Tingkat Prioritas
                    Text(
                      'Tingkat Prioritas',
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: _priorities.map((priority) {
                        final isSelected = _selectedPriority == priority;
                        Color activeColor;
                        if (priority == 'Tinggi') {
                          activeColor = AppColors.danger;
                        } else if (priority == 'Sedang') {
                          activeColor = AppColors.warning;
                        } else {
                          activeColor = AppColors.secondary;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(priority),
                            selected: isSelected,
                            selectedColor: activeColor.withValues(alpha: 0.15),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: isSelected
                                  ? activeColor
                                  : AppColors.border,
                              width: 1.2,
                            ),
                            labelStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? activeColor
                                  : AppColors.textSecondary,
                            ),
                            onSelected: (_) {
                              setState(() {
                                _selectedPriority = priority;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Input 5: Deskripsi / Catatan Tugas
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Deskripsi / Catatan Tugas',
                      hintText:
                          'Tulis instruksi dosen, tautan pengumpulan, atau catatan penting...',
                      prefixIcon: Icons.notes_rounded,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Deskripsi tugas wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tombol Aksi (Primary & Secondary Button)
              CustomPrimaryButton(
                text: 'Simpan Tugas',
                icon: Icons.save_rounded,
                onPressed: _saveTask,
              ),
              const SizedBox(height: 10),
              CustomSecondaryButton(
                text: 'Batal',
                icon: Icons.close_rounded,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
