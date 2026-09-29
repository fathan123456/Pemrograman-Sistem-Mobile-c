import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'custom_card.dart';

/// Custom Widget untuk Menampilkan Kartu Item Tugas Mahasiswa
/// Menggunakan CustomCard sebagai pembungkus utama dengan styling konsisten.
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final ValueChanged<bool?> onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onStatusChanged,
  });

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return AppColors.danger;
      case 'sedang':
        return AppColors.warning;
      case 'rendah':
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(task.priority);

    return CustomCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 12),
      borderColor: task.isCompleted
          ? AppColors.success.withValues(alpha: 0.3)
          : AppColors.border,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox status pengerjaan
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 12),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: task.isCompleted,
                onChanged: onStatusChanged,
                activeColor: AppColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),

          // Detail informasi tugas
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag Mata Kuliah & Label Prioritas
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        task.subject,
                        style: AppTypography.badgeText.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        task.priority,
                        style: AppTypography.badgeText.copyWith(
                          color: priorityColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Judul Tugas
                Text(
                  task.title,
                  style: AppTypography.headingSmall.copyWith(
                    fontSize: 15,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),

                // Tenggat Waktu (Deadline)
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: task.isCompleted
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      task.deadline,
                      style: AppTypography.bodySmall.copyWith(
                        color: task.isCompleted
                            ? AppColors.textMuted
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Icon indikator navigasi detail
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 6),
            child: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
