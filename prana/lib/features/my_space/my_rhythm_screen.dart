// lib/features/my_space/my_rhythm_screen.dart (WITH BACK BUTTON)
import 'package:flutter/material.dart';
import '../../widgets/ultimate_emoji.dart';
import 'theme/card_styles.dart';
import 'screens/rhythm_welcome_screen.dart';
import 'screens/rhythm_input_screen.dart';
import 'models/rhythm_model.dart';
import 'services/rhythm_storage_service.dart';

class MyRhythmScreen extends StatefulWidget {
  const MyRhythmScreen({super.key});

  @override
  State<MyRhythmScreen> createState() => _MyRhythmScreenState();
}

class _MyRhythmScreenState extends State<MyRhythmScreen> {
  UserRhythm? _rhythm;
  bool _isLoading = true;
  int _streak = 0;
  final RhythmStorageService _storageService = RhythmStorageService();

  @override
  void initState() {
    super.initState();
    _loadRhythm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRhythm();
  }

  Future<void> _loadRhythm() async {
    final rhythm = await _storageService.loadRhythm();
    final streak = await _storageService.getStreak();
    
    setState(() {
      _rhythm = rhythm;
      _streak = streak;
      _isLoading = false;
    });
  }

  Future<void> _toggleTask(RhythmTask task) async {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
    
    await _storageService.updateTaskCompletion(task.id, task.isCompleted);
    
    final streak = await _storageService.getStreak();
    setState(() {
      _streak = streak;
    });
  }

  void _editRhythm() {
    if (_rhythm != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RhythmInputScreen(
            existingTasks: _rhythm!.tasks,
          ),
        ),
      ).then((_) => _loadRhythm());
    }
  }

  void _createNewRhythm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Rhythm'),
        content: const Text('This will replace your current rhythm. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RhythmWelcomeScreen(
                    onStart: null,
                  ),
                ),
              ).then((_) => _loadRhythm());
            },
            child: const Text('Create New'),
          ),
        ],
      ),
    );
  }

  void _goBack() {
    Navigator.pop(context); // Goes back to My Space
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_rhythm == null) {
      return RhythmWelcomeScreen(
        onStart: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RhythmInputScreen(),
            ),
          ).then((_) => _loadRhythm());
        },
      );
    }

    final morningTasks = _rhythm!.tasks.where((t) => t.category == 'morning').toList();
    final afternoonTasks = _rhythm!.tasks.where((t) => t.category == 'afternoon').toList();
    final eveningTasks = _rhythm!.tasks.where((t) => t.category == 'evening').toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // Header with Back Button
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3E50)),
              onPressed: _goBack,
              tooltip: 'Back to My Space',
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 50, bottom: 16, right: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '⏰ MY RHYTHM',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3E50),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Color(0xFF2D3E50), size: 20),
                            onPressed: _editRhythm,
                            tooltip: 'Edit Current Rhythm',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: Color(0xFF2D3E50), size: 20),
                            onPressed: _createNewRhythm,
                            tooltip: 'Create New Rhythm',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Your personalized daily flow',
                    style: TextStyle(
                      fontSize: 11,
                      color: const Color(0xFF2D3E50).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Progress Card
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            sliver: SliverToBoxAdapter(
              child: CardStyles.wrapWithFrostedGlass(
                tintColor: const Color(0xFFB4A7F5),
                opacity: 0.15,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '🔥 TODAY\'S PROGRESS',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3E50),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 12)),
                              const SizedBox(width: 2),
                              Text(
                                '$_streak day',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_rhythm!.completedCount}/${_rhythm!.totalCount} tasks',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3E50),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${(_rhythm!.progress * 100).toInt()}% complete',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF2D3E50).withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_rhythm!.completedCount == _rhythm!.totalCount)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              children: [
                                Text('👑', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 4),
                                Text(
                                  'COMPLETE!',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3E50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _rhythm!.progress,
                        backgroundColor: const Color(0xFF2D3E50).withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2D3E50)),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Task Sections
          if (morningTasks.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              sliver: SliverToBoxAdapter(
                child: _buildTaskSection('☀️ MORNING', morningTasks),
              ),
            ),

          if (afternoonTasks.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              sliver: SliverToBoxAdapter(
                child: _buildTaskSection('⛅ AFTERNOON', afternoonTasks),
              ),
            ),

          if (eveningTasks.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              sliver: SliverToBoxAdapter(
                child: _buildTaskSection('🌙 EVENING', eveningTasks),
              ),
            ),

          // AI Tip
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFB4A7F5).withOpacity(0.2),
                      const Color(0xFF6C5CE7).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF6C5CE7).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB4A7F5),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🤖', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '70% more productive with morning study! 🔥',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2D3E50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSection(String title, List<RhythmTask> tasks) {
    return CardStyles.wrapWithFrostedGlass(
      tintColor: title.contains('MORNING') 
          ? const Color(0xFFFFE5A3)
          : title.contains('AFTERNOON')
              ? const Color(0xFFA3E4D7)
              : const Color(0xFFB4A7F5),
      opacity: 0.15,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3E50),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3E50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '✓ ${tasks.where((t) => t.isCompleted).length}/${tasks.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2D3E50),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...tasks.map((task) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _buildTaskTile(task),
          )),
        ],
      ),
    );
  }

  Widget _buildTaskTile(RhythmTask task) {
    return InkWell(
      onTap: () => _toggleTask(task),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF2D3E50).withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: task.isOptimized
                    ? const Color(0xFFB4A7F5).withOpacity(0.2)
                    : const Color(0xFF2D3E50).withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: UltimateEmoji(emoji: task.emoji, size: 14),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted 
                          ? const Color(0xFF2D3E50).withOpacity(0.5)
                          : const Color(0xFF2D3E50),
                    ),
                  ),
                  Text(
                    _formatTime(task.time),
                    style: TextStyle(
                      fontSize: 10,
                      color: const Color(0xFF2D3E50).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (task.isOptimized)
              Container(
                margin: const EdgeInsets.only(right: 4),
                child: const Text('✨', style: TextStyle(fontSize: 10)),
              ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted
                      ? const Color(0xFF2D3E50)
                      : const Color(0xFF2D3E50).withOpacity(0.3),
                  width: 1.5,
                ),
                color: task.isCompleted
                    ? const Color(0xFF2D3E50)
                    : Colors.transparent,
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
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