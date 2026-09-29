import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/custom_secondary_button.dart';

/// Screen 3: Layar Detail Tugas Kuliah
/// Menampilkan informasi lengkap tugas, status penyelesaian, serta aksi update dan hapus.
class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TaskModel _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  // Mengubah status selesai / belum selesai
  void _toggleStatus() {
    setState(() {
      _currentTask = _currentTask.copyWith(
        isCompleted: !_currentTask.isCompleted,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentTask.isCompleted
              ? 'Tugas ditandai selesai!'
              : 'Tugas ditandai belum selesai.',
        ),
        backgroundColor:
            _currentTask.isCompleted ? AppColors.success : AppColors.warning,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Kembalikan status baru ke TaskListScreen
    Navigator.pop(context, {
      'action': 'update',
      'task': _currentTask,
    });
  }

  // Konfirmasi dialog sebelum menghapus tugas
  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Hapus Tugas?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus tugas "${_currentTask.title}"? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.pop(context, {
        'action': 'delete',
        'task': _currentTask,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = _currentTask.isCompleted;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Detail Tugas',
        subtitle: _currentTask.subject,
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: AppColors.danger,
            tooltip: 'Hapus Tugas',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Kartu Header Status & Mata Kuliah
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges: Status dan Prioritas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDone
                              ? AppColors.successLight
                              : AppColors.warningLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isDone
                                  ? Icons.check_circle_rounded
                                  : Icons.access_time_filled_rounded,
                              size: 16,
                              color: isDone
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isDone ? 'Selesai' : 'Belum Selesai',
                              style: AppTypography.badgeText.copyWith(
                                color: isDone
                                    ? AppColors.success
                                    : AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Prioritas: ${_currentTask.priority}',
                          style: AppTypography.badgeText.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Judul Tugas
                  Text(
                    _currentTask.title,
                    style: AppTypography.headingLarge.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 14),

                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 14),

                  // Info Mata Kuliah
                  Row(
                    children: [
                      const Icon(Icons.school_outlined,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Mata Kuliah:',
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _currentTask.subject,
                          style: AppTypography.headingSmall.copyWith(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Info Tenggat Waktu
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Tenggat Waktu:',
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _currentTask.deadline,
                        style: AppTypography.headingSmall.copyWith(
                          fontSize: 14,
                          color: isDone ? AppColors.textSecondary : AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 2. Kartu Deskripsi Tugas
            CustomCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.description_outlined,
                          size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Deskripsi Tugas',
                        style: AppTypography.headingSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentTask.description,
                    style: AppTypography.bodyLarge,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 3. Kartu Tips & Saran Pengerjaan
            CustomCard(
              padding: const EdgeInsets.all(16),
              backgroundColor: AppColors.secondaryLight.withValues(alpha: 0.4),
              borderColor: AppColors.secondary.withValues(alpha: 0.3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.tips_and_updates_outlined,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tips Mahasiswa',
                          style: AppTypography.headingSmall.copyWith(
                            fontSize: 14,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Selesaikan tugas sebelum H-1 tenggat waktu untuk menghindari kendala teknis jaringan saat pengumpulan.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Tombol Aksi Bawah
            CustomPrimaryButton(
              text: isDone ? 'Tandai Belum Selesai' : 'Tandai Selesai',
              icon: isDone
                  ? Icons.replay_rounded
                  : Icons.check_circle_outline_rounded,
              onPressed: _toggleStatus,
            ),
            const SizedBox(height: 10),
            CustomSecondaryButton(
              text: 'Hapus Tugas',
              icon: Icons.delete_outline_rounded,
              textColor: AppColors.danger,
              borderColor: AppColors.danger.withValues(alpha: 0.4),
              onPressed: _confirmDelete,
            ),
          ],
        ),
      ),
    );
  }
}
