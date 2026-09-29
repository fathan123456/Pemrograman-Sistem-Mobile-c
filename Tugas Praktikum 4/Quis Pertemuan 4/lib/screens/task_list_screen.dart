import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

/// Screen 1: Layar Utama Daftar Tugas Mahasiswa
/// Menampilkan ringkasan progres, filter tugas, dan daftar seluruh tugas kuliah.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Sumber data daftar tugas
  late List<TaskModel> _tasks;

  // Filter aktif: 'Semua', 'Belum Selesai', 'Selesai'
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _tasks = TaskModel.getInitialTasks();
  }

  // Menghitung statistik tugas
  int get _totalCount => _tasks.length;
  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  int get _pendingCount => _totalCount - _completedCount;

  // Memfilter daftar tugas sesuai tab filter yang dipilih
  List<TaskModel> get _filteredTasks {
    if (_selectedFilter == 'Belum Selesai') {
      return _tasks.where((t) => !t.isCompleted).toList();
    } else if (_selectedFilter == 'Selesai') {
      return _tasks.where((t) => t.isCompleted).toList();
    }
    return _tasks;
  }

  // Navigasi ke Layar Tambah Tugas
  Future<void> _navigateToAddTask() async {
    final newTask = await Navigator.push<TaskModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );

    if (newTask != null) {
      setState(() {
        _tasks.insert(0, newTask);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil ditambahkan!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Navigasi ke Layar Detail Tugas
  Future<void> _navigateToTaskDetail(TaskModel task) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );

    if (result != null) {
      final action = result['action'] as String;
      final updatedTask = result['task'] as TaskModel;

      setState(() {
        final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
        if (action == 'delete' && index != -1) {
          _tasks.removeAt(index);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tugas telah dihapus.'),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (action == 'update' && index != -1) {
          _tasks[index] = updatedTask;
        }
      });
    }
  }

  // Toggle status checkbox langsung dari daftar
  void _toggleTaskStatus(TaskModel task, bool? value) {
    setState(() {
      task.isCompleted = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTasks;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'EduTask',
        subtitle: 'Catatan & Monitoring Tugas Kuliah',
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            color: AppColors.textSecondary,
            tooltip: 'Info Aplikasi',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'EduTask Mobile',
                applicationVersion: '1.0.0',
                children: const [
                  Text(
                    'Aplikasi sederhana untuk manajemen tugas kuliah mahasiswa dengan implementasi custom widget dan konsistensi UI.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // 1. Bagian Kartu Ringkasan Statistik
          _buildSummaryCards(),
          const SizedBox(height: 18),

          // 2. Filter Kategori Tugas
          _buildFilterChips(),
          const SizedBox(height: 16),

          // 3. Header Daftar Tugas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Tugas (${filtered.length})',
                style: AppTypography.headingSmall,
              ),
              Text(
                'Ketuk untuk detail',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4. Daftar Item Tugas atau State Kosong
          if (filtered.isEmpty)
            _buildEmptyState()
          else
            ...filtered.map(
              (task) => TaskCard(
                key: ValueKey(task.id),
                task: task,
                onTap: () => _navigateToTaskDetail(task),
                onStatusChanged: (val) => _toggleTaskStatus(task, val),
              ),
            ),

          // Ruang scroll tambahan di bawah
          const SizedBox(height: 70),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddTask,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Tugas',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Widget kartu ringkasan progres
  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: CustomCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: AppTypography.bodySmall),
                    const Icon(Icons.assignment_outlined,
                        size: 18, color: AppColors.primary),
                  ],
                ),
                const SizedBox(height: 6),
                Text('$_totalCount', style: AppTypography.headingLarge),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Belum', style: AppTypography.bodySmall),
                    const Icon(Icons.pending_actions_rounded,
                        size: 18, color: AppColors.warning),
                  ],
                ),
                const SizedBox(height: 6),
                Text('$_pendingCount',
                    style: AppTypography.headingLarge
                        .copyWith(color: AppColors.warning)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Selesai', style: AppTypography.bodySmall),
                    const Icon(Icons.check_circle_outline_rounded,
                        size: 18, color: AppColors.success),
                  ],
                ),
                const SizedBox(height: 6),
                Text('$_completedCount',
                    style: AppTypography.headingLarge
                        .copyWith(color: AppColors.success)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Widget pemilihan tab filter
  Widget _buildFilterChips() {
    final filters = ['Semua', 'Belum Selesai', 'Selesai'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              showCheckmark: false,
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
              ),
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              onSelected: (_) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  /// State saat daftar tugas tidak memiliki item
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 64,
            color: AppColors.border,
          ),
          const SizedBox(height: 12),
          Text(
            'Tidak ada tugas pada kategori ini',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tekan tombol + di bawah untuk membuat tugas baru',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
