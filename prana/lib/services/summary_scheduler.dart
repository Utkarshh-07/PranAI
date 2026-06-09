// lib/services/summary_scheduler.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'parent_summary_service.dart';
import 'notification_service.dart';

class SummaryScheduler {
  static final SummaryScheduler _instance = SummaryScheduler._internal();
  factory SummaryScheduler() => _instance;
  SummaryScheduler._internal();
  
  Timer? _dailyTimer;
  final ParentSummaryService _summaryService = ParentSummaryService();
  
  void startScheduler() {
    _scheduleDailySummary();
    print('✅ Summary scheduler started');
  }
  
  void _scheduleDailySummary() {
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, 20, 0);
    
    Duration delay;
    if (now.isAfter(scheduledTime)) {
      delay = scheduledTime.add(const Duration(days: 1)).difference(now);
    } else {
      delay = scheduledTime.difference(now);
    }
    
    _dailyTimer = Timer(delay, () {
      _generateAndSendSummaries();
      _dailyTimer = Timer(const Duration(days: 1), () {
        _generateAndSendSummaries();
      });
    });
  }
  
  Future<void> _generateAndSendSummaries() async {
    print('📊 Generating daily summaries...');
    
    try {
      final parentsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'parent')
          .get();
      
      for (var parentDoc in parentsSnapshot.docs) {
        final parentId = parentDoc.id;
        final studentId = parentDoc.data()['linkedStudentId'];
        
        if (studentId != null) {
          final summary = await _summaryService.generateDailySummary(
            studentId: studentId,
            parentId: parentId,
            date: DateTime.now(),
          );
          
          await NotificationService().sendNotificationToUser(
            userId: parentId,
            title: '📊 Daily Summary for Your Child',
            body: summary['summary'].toString().length > 100 
                ? summary['summary'].toString().substring(0, 100) 
                : summary['summary'].toString(),
            type: 'daily_summary',
            data: {'summaryId': summary['id']},
          );
        }
      }
      
      print('✅ Daily summaries sent to parents');
    } catch (e) {
      print('❌ Error generating summaries: $e');
    }
  }
  
  void dispose() {
    _dailyTimer?.cancel();
  }
}