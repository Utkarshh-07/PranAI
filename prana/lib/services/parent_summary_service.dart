// lib/services/parent_summary_service.dart (FIXED)
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentSummaryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> generateDailySummary({
    required String studentId,
    required String parentId,
    required DateTime date,
  }) async {
    try {
      final studentData = await _fetchStudentDailyData(studentId, date);
      
      final summaryText = _generateSummaryText(studentData);
      final insights = _generateInsights(studentData);
      final recommendations = _generateRecommendations(studentData);
      
      final summary = {
        'studentId': studentId,
        'parentId': parentId,
        'date': Timestamp.fromDate(date),
        'summary': summaryText,
        'moodScore': studentData['avgMood'],
        'tasksCompleted': studentData['tasksCompleted'],
        'aiChatsCount': studentData['aiChatsCount'],
        'stressLevel': studentData['stressLevel'],
        'keyInsights': insights,
        'recommendations': recommendations,
        'generatedAt': FieldValue.serverTimestamp(),
        'isRead': false,
      };
      
      final docRef = await _firestore
          .collection('users')
          .doc(parentId)
          .collection('daily_summaries')
          .add(summary);
      
      summary['id'] = docRef.id;
      return summary;
    } catch (e) {
      print('❌ Error generating summary: $e');
      return {
        'summary': 'Your child had a normal day. Continue to support them with love and care. 💗',
        'moodScore': 5.0,
        'tasksCompleted': 0,
        'stressLevel': 3,
        'keyInsights': ['Keep supporting your child'],
        'recommendations': ['Check in with your child about their day'],
      };
    }
  }

  Future<Map<String, dynamic>> _fetchStudentDailyData(String studentId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final moodEntries = await _firestore
        .collection('users')
        .doc(studentId)
        .collection('mood_entries')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .get();
    
    final tasks = await _firestore
        .collection('users')
        .doc(studentId)
        .collection('tasks')
        .where('completed', isEqualTo: true)
        .get();
    
    double avgMood = 5.0;
    int stressLevel = 3;
    
    for (var entry in moodEntries.docs) {
      final data = entry.data();
      avgMood = (data['mood'] ?? 5).toDouble();
      final stress = data['stress'] ?? 3;
      if (stress is int) {
        stressLevel = stress;
      } else if (stress is double) {
        stressLevel = stress.toInt();
      }
    }
    
    return {
      'avgMood': avgMood,
      'tasksCompleted': tasks.docs.length,
      'aiChatsCount': 0,
      'stressLevel': stressLevel,
      'moodEntries': moodEntries.docs.length,
    };
  }

  String _generateSummaryText(Map<String, dynamic> data) {
    final mood = data['avgMood'];
    
    if (mood >= 7) {
      return "🌟 Your child had a positive day! They seem to be in good spirits and engaging well with their activities. Keep up the great support!";
    } else if (mood >= 4) {
      return "📊 Your child had a steady day. They're managing well, though there might be some areas where they need extra support. A gentle check-in would be nice.";
    } else {
      return "💗 Your child might be going through a challenging time. They could benefit from some extra emotional support today. Your presence matters.";
    }
  }

  List<String> _generateInsights(Map<String, dynamic> data) {
    final List<String> insights = [];
    final mood = data['avgMood'];
    final tasks = data['tasksCompleted'];
    final stress = data['stressLevel'];
    
    if (mood >= 7) {
      insights.add("Maintained positive mood throughout the day");
    } else if (mood <= 3) {
      insights.add("Showed signs of needing additional emotional support");
    }
    
    if (tasks >= 5) {
      insights.add("Completed $tasks tasks - great productivity!");
    } else if (tasks > 0) {
      insights.add("Completed $tasks tasks today");
    } else {
      insights.add("Few tasks completed today - may need motivation");
    }
    
    if (stress >= 7) {
      insights.add("Showing signs of elevated stress levels");
    }
    
    if (insights.isEmpty) {
      insights.add("Had a normal, balanced day");
    }
    
    return insights;
  }

  List<String> _generateRecommendations(Map<String, dynamic> data) {
    final List<String> recommendations = [];
    final mood = data['avgMood'];
    final tasks = data['tasksCompleted'];
    final stress = data['stressLevel'];
    
    if (mood >= 7) {
      recommendations.add("Encourage them to share what made them happy today");
    } else if (mood <= 3) {
      recommendations.add("Have a gentle conversation about their feelings");
      recommendations.add("Spend quality time together doing something they enjoy");
    }
    
    if (tasks < 3) {
      recommendations.add("Help them break down tasks into smaller, manageable steps");
    }
    
    if (stress >= 7) {
      recommendations.add("Help them practice relaxation techniques like deep breathing");
      recommendations.add("Ensure they're taking regular breaks from studies");
    }
    
    if (recommendations.isEmpty) {
      recommendations.add("Continue providing your love and support");
      recommendations.add("Check in about their day before bedtime");
    }
    
    return recommendations;
  }
}