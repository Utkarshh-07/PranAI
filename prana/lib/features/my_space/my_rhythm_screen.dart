// lib/features/my_space/my_rhythm_screen.dart (FIXED)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/ultimate_emoji.dart';
import 'theme/card_styles.dart';

class MyRhythmScreen extends StatefulWidget {
  const MyRhythmScreen({super.key});

  @override
  State<MyRhythmScreen> createState() => _MyRhythmScreenState();
}

class _MyRhythmScreenState extends State<MyRhythmScreen> {
  late List<TaskCategory> _categories;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    // Default tasks
    _categories = [
      TaskCategory(
        name: '☀️ MORNING',
        tasks: [
          RoutineTask(title: 'Wake up', time: '7:00 AM', emoji: '🌅'),
          RoutineTask(title: 'Morning routine', time: '7:30 AM', emoji: '🚿'),
          RoutineTask(title: 'Breakfast', time: '8:00 AM', emoji: '🍳'),
          RoutineTask(title: 'Study', time: '9:00 AM', emoji: '📚'),
        ],
      ),
      TaskCategory(
        name: '⛅ AFTERNOON',
        tasks: [
          RoutineTask(title: 'Lunch', time: '12:00 PM', emoji: '🍲'),
          RoutineTask(title: 'Study', time: '1:00 PM', emoji: '📚'),
          RoutineTask(title: 'Self-care', time: '4:00 PM', emoji: '😌'),
        ],
      ),
      TaskCategory(
        name: '🌙 EVENING',
        tasks: [
          RoutineTask(title: 'Dinner', time: '7:00 PM', emoji: '🍽️'),
          RoutineTask(title: 'Relax', time: '8:00 PM', emoji: '🎮'),
          RoutineTask(title: 'Sleep', time: '11:00 PM', emoji: '😴'),
        ],
      ),
    ];

    // Load saved completion states
    final prefs = await SharedPreferences.getInstance();
    for (var category in _categories) {
      for (var task in category.tasks) {
        task.isCompleted = prefs.getBool(task.id) ?? false;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _toggleTask(RoutineTask task) async {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(task.id, task.isCompleted);
  }

  int _getCompletedCount() {
    int count = 0;
    for (var category in _categories) {
      count += category.tasks.where((task) => task.isCompleted).length;
    }
    return count;
  }

  int _getTotalCount() {
    int count = 0;
    for (var category in _categories) {
      count += category.tasks.length;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final completed = _getCompletedCount();
    final total = _getTotalCount();
    final progress = total > 0 ? completed / total : 0.0;

    return CustomScrollView(
      slivers: [
        // Progress Card - as Sliver
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: CardStyles.wrapWithFrostedGlass(
              tintColor: const Color(0xFFB4A7F5),
              opacity: 0.15,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔥 TODAY\'S PROGRESS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3E50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$completed/$total tasks',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3E50),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(progress * 100).toInt()}% complete',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF2D3E50).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (completed == total)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Text('👑', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 4),
                              Text(
                                'COMPLETE!',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFF2D3E50).withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2D3E50)),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(top: 8)),

        // Task Categories
        ..._categories.map((category) => SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          sliver: SliverToBoxAdapter(
            child: _buildTaskCategory(category),
          ),
        )),

        // Bottom padding to ensure no overflow
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }

  Widget _buildTaskCategory(TaskCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3E50),
          ),
        ),
        const SizedBox(height: 12),
        ...category.tasks.map((task) => _buildTaskTile(task)),
      ],
    );
  }

  Widget _buildTaskTile(RoutineTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: CardStyles.solidCard,
      child: CheckboxListTile(
        value: task.isCompleted,
        onChanged: (_) => _toggleTask(task),
        title: Row(
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted 
                          ? const Color(0xFF2D3E50).withOpacity(0.5)
                          : const Color(0xFF2D3E50),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task.time,
                    style: TextStyle(
                      fontSize: 11,
                      color: const Color(0xFF2D3E50).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: const Color(0xFF2D3E50),
        checkColor: Colors.white,
      ),
    );
  }
}

class TaskCategory {
  final String name;
  final List<RoutineTask> tasks;

  TaskCategory({required this.name, required this.tasks});
}

class RoutineTask {
  final String id;
  final String title;
  final String time;
  final String emoji;
  bool isCompleted;

  RoutineTask({
    required this.title,
    required this.time,
    required this.emoji,
    this.isCompleted = false,
  }) : id = 'task_${title}_${time}';
}