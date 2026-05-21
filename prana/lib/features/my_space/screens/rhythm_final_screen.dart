// lib/features/my_space/screens/rhythm_final_screen.dart
import 'package:flutter/material.dart';
import '../models/rhythm_model.dart';
import '../services/rhythm_storage_service.dart';
import '../theme/card_styles.dart';
import '../../../widgets/ultimate_emoji.dart';

class RhythmFinalScreen extends StatefulWidget {
  final List<RhythmTask> tasks;

  const RhythmFinalScreen({super.key, required this.tasks});

  @override
  State<RhythmFinalScreen> createState() => _RhythmFinalScreenState();
}

class _RhythmFinalScreenState extends State<RhythmFinalScreen> {
  late List<RhythmTask> _tasks;
  final RhythmStorageService _storageService = RhythmStorageService();

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.tasks);
  }

  Future<void> _saveRhythm() async {
    final rhythm = UserRhythm(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      tasks: _tasks,
    );

    await _storageService.saveRhythm(rhythm);
    
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            const Expanded(child: Text('Rhythm saved successfully!')),
          ],
        ),
        backgroundColor: const Color(0xFF2D3E50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        duration: const Duration(seconds: 1),
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/my-rhythm',
      (route) => false,
    );
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var morningTasks = _tasks.where((t) => t.category == 'morning').toList();
    var afternoonTasks = _tasks.where((t) => t.category == 'afternoon').toList();
    var eveningTasks = _tasks.where((t) => t.category == 'evening').toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFFFFF9F0),
                  Color(0xFFF5F0FF),
                  Color(0xFFE8F0FE),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3E50)),
                        onPressed: _goBack,
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            '⏰ FINAL RHYTHM',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3E50),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (morningTasks.isNotEmpty) ...[
                          _buildSection('☀️ MORNING', morningTasks),
                          const SizedBox(height: 16),
                        ],
                        if (afternoonTasks.isNotEmpty) ...[
                          _buildSection('⛅ AFTERNOON', afternoonTasks),
                          const SizedBox(height: 16),
                        ],
                        if (eveningTasks.isNotEmpty) ...[
                          _buildSection('🌙 EVENING', eveningTasks),
                          const SizedBox(height: 16),
                        ],

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _saveRhythm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D3E50),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              '💾 SAVE MY RHYTHM',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<RhythmTask> tasks) {
    return CardStyles.wrapWithFrostedGlass(
      tintColor: title.contains('MORNING') 
          ? const Color(0xFFFFE5A3)
          : title.contains('AFTERNOON')
              ? const Color(0xFFA3E4D7)
              : const Color(0xFFB4A7F5),
      opacity: 0.15,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3E50),
            ),
          ),
          const SizedBox(height: 12),
          ...tasks.map((task) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildTaskItem(task),
          )),
        ],
      ),
    );
  }

  Widget _buildTaskItem(RhythmTask task) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF2D3E50).withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: UltimateEmoji(emoji: task.emoji, size: 16),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D3E50),
                ),
              ),
              Text(
                _formatTime(task.time),
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xFF2D3E50).withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        if (task.isOptimized)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFB4A7F5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('✨', style: TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  String _formatTime(String time) {
    if (time.length >= 5) {
      try {
        final hour = int.parse(time.substring(0, 2));
        final minute = time.substring(3, 5);
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$displayHour:$minute $period';
      } catch (e) {
        return time;
      }
    }
    return time;
  }
}