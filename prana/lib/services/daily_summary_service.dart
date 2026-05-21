// lib/services/daily_summary_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DailySummaryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate daily summary for user
  Future<Map<String, dynamic>> generateDailySummary(String userId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Get today's tasks
    final tasksSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay)
        .get();

    // Get today's moods
    final moodsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('moods')
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay)
        .get();

    // Get today's shells
    final shellsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('shells')
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay)
        .get();

    // Calculate stats
    final completedTasks = tasksSnapshot.docs.where((doc) => doc['completed'] == true).length;
    final totalTasks = tasksSnapshot.docs.length;
    final completionRate = totalTasks > 0 ? (completedTasks / totalTasks * 100).round() : 0;

    final moods = moodsSnapshot.docs.map((doc) => doc['mood'] as String).toList();
    final primaryMood = _getPrimaryMood(moods);

    final summary = {
      'date': today.toIso8601String(),
      'tasks': {
        'total': totalTasks,
        'completed': completedTasks,
        'rate': completionRate,
      },
      'moods': {
        'count': moods.length,
        'primary': primaryMood,
      },
      'shells': shellsSnapshot.docs.length,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Save summary
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('summaries')
        .add(summary);

    return summary;
  }

  String _getPrimaryMood(List<String> moods) {
    if (moods.isEmpty) return 'neutral';
    
    final counts = <String, int>{};
    for (var mood in moods) {
      counts[mood] = (counts[mood] ?? 0) + 1;
    }
    
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  // Get AI prompt for daily summary
  String getSummaryPrompt(Map<String, dynamic> summary, String aiName) {
    final date = DateTime.parse(summary['date']);
    final formattedDate = DateFormat('EEEE, MMMM d').format(date);
    
    return '''
You are $aiName, a caring AI friend. Today is $formattedDate.
Here's what your friend achieved today:

Tasks: ${summary['tasks']['completed']}/${summary['tasks']['total']} completed (${summary['tasks']['rate']}%)
Mood: Mostly ${summary['moods']['primary']}
Shells found: ${summary['shells']}

Write a warm, encouraging message summarizing their day.
Be proud of their achievements but also acknowledge any struggles.
Keep it under 100 words and make it feel like a friend checking in.
''';
  }
}