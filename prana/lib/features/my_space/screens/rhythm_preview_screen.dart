// lib/features/my_space/screens/rhythm_preview_screen.dart
import 'package:flutter/material.dart';
import '../models/rhythm_model.dart';
import '../services/rhythm_ai_service.dart';
import '../theme/card_styles.dart';
import '../../../widgets/ultimate_emoji.dart';
import 'rhythm_optimization_screen.dart';
import 'rhythm_input_screen.dart';

class RhythmPreviewScreen extends StatefulWidget {
  final List<RhythmTask> tasks;
  final String originalText;

  const RhythmPreviewScreen({
    super.key,
    required this.tasks,
    required this.originalText,
  });

  @override
  State<RhythmPreviewScreen> createState() => _RhythmPreviewScreenState();
}

class _RhythmPreviewScreenState extends State<RhythmPreviewScreen> {
  late List<RhythmTask> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.tasks);
  }

  int _calculateStudyHours() {
    int minutes = 0;
    for (var task in _tasks) {
      if (task.title.contains('Study')) {
        minutes += task.duration;
      }
    }
    return (minutes / 60).round();
  }

  int _calculateBreakCount() {
    return _tasks.where((t) => t.title.contains('Break')).length;
  }

  double _calculateSleepHours() {
    for (var task in _tasks) {
      if (task.title == 'Sleep') {
        return task.duration / 60.0;
      }
    }
    return 7.0;
  }

  void _goToOptimization() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RhythmOptimizationScreen(
          tasks: _tasks,
        ),
      ),
    );
  }

  void _goBack() {
    Navigator.pop(context);
  }

  void _tryAgain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const RhythmInputScreen(),
      ),
    );
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
                // Header
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
                            '📊 YOUR RHYTHM',
                            style: TextStyle(
                              fontSize: 16,
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

                const SizedBox(height: 8),

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

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: CardStyles.solidCard,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStat('📚 Study', '${_calculateStudyHours()}h'),
                              _buildStat('☕ Breaks', '${_calculateBreakCount()}'),
                              _buildStat('😴 Sleep', '${_calculateSleepHours().toStringAsFixed(1)}h'),
                              _buildStat('📋 Total', '${_tasks.length}'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _tryAgain,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF2D3E50),
                                  side: const BorderSide(color: Color(0xFF2D3E50)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text('🔄 TRY AGAIN'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _goToOptimization,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2D3E50),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text('✨ OPTIMIZE'),
                              ),
                            ),
                          ],
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF2D3E50).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${task.duration}min',
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF2D3E50),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF2D3E50),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3E50),
          ),
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