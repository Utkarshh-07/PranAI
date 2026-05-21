// lib/features/my_space/screens/rhythm_optimization_screen.dart
import 'package:flutter/material.dart';
import '../models/rhythm_model.dart';
import '../services/rhythm_ai_service.dart';
import '../theme/card_styles.dart';
import '../../../widgets/ultimate_emoji.dart';
import 'rhythm_final_screen.dart';

class RhythmOptimizationScreen extends StatefulWidget {
  final List<RhythmTask> tasks;

  const RhythmOptimizationScreen({super.key, required this.tasks});

  @override
  State<RhythmOptimizationScreen> createState() => _RhythmOptimizationScreenState();
}

class _RhythmOptimizationScreenState extends State<RhythmOptimizationScreen> {
  late List<RhythmTask> _tasks;
  late List<AISuggestion> _suggestions;
  final RhythmAIService _aiService = RhythmAIService();
  List<String> _appliedSuggestions = [];

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.tasks);
    _suggestions = _aiService.generateOptimizations(_tasks, context);
  }

  void _applySuggestion(AISuggestion suggestion) {
    setState(() {
      _appliedSuggestions.add(suggestion.id);
      
      if (suggestion.type == 'study') {
        List<RhythmTask> newTasks = [];
        for (var task in _tasks) {
          if (task.title.contains('Study') && task.duration > 120) {
            var timeParts = task.time.split(':');
            int hour = int.parse(timeParts[0]);
            int minute = int.parse(timeParts[1]);
            
            newTasks.add(RhythmTask(
              id: 'study1_${DateTime.now().millisecondsSinceEpoch}',
              title: 'Study Block 1',
              time: task.time,
              emoji: '📚',
              category: task.category,
              duration: 90,
              isOptimized: true,
            ));
            
            hour += 1;
            minute += 30;
            if (minute >= 60) {
              hour += 1;
              minute -= 60;
            }
            String newTime = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
            
            newTasks.add(RhythmTask(
              id: 'study2_${DateTime.now().millisecondsSinceEpoch}',
              title: 'Study Block 2',
              time: newTime,
              emoji: '📚',
              category: task.category,
              duration: 90,
              isOptimized: true,
            ));
          } else {
            newTasks.add(task);
          }
        }
        _tasks = newTasks;
        _tasks.sort((a, b) => _timeToMinutes(a.time).compareTo(_timeToMinutes(b.time)));
        
      } else if (suggestion.type == 'break') {
        _tasks.add(RhythmTask(
          id: 'break_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Break',
          time: '10:30',
          emoji: '☕',
          category: 'morning',
          duration: 15,
          isOptimized: true,
        ));
        _tasks.sort((a, b) => _timeToMinutes(a.time).compareTo(_timeToMinutes(b.time)));
        
      } else if (suggestion.type == 'sleep') {
        for (var task in _tasks) {
          if (task.title == 'Sleep') {
            task.time = '22:00';
            task.duration = 540;
            task.isOptimized = true;
          }
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✨ Applied: ${suggestion.title}'),
        backgroundColor: suggestion.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  int _timeToMinutes(String time) {
    var parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  void _continueToFinal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RhythmFinalScreen(
          tasks: _tasks,
        ),
      ),
    );
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                            '✨ OPTIMIZATION',
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

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      final bool isApplied = _appliedSuggestions.contains(suggestion.id);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CardStyles.wrapWithFrostedGlass(
                          tintColor: suggestion.color,
                          opacity: isApplied ? 0.3 : 0.15,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: suggestion.color.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      suggestion.icon,
                                      color: suggestion.color,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          suggestion.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: suggestion.color,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          suggestion.description,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF2D3E50),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (!isApplied) ...[
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _applySuggestion(suggestion),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: suggestion.color,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text('APPLY'),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _continueToFinal,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2D3E50),
                            side: const BorderSide(color: Color(0xFF2D3E50)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('⏭️ SKIP'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _continueToFinal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D3E50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('✨ CONTINUE'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}