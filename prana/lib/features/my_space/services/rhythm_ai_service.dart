// lib/features/my_space/services/rhythm_ai_service.dart
import 'package:flutter/material.dart';
import '../models/rhythm_model.dart';
import 'package:uuid/uuid.dart';

class RhythmAIService {
  final Uuid _uuid = const Uuid();

  // Natural Language Parser with robust error handling
  List<RhythmTask> parseUserInput(String text) {
    List<RhythmTask> tasks = [];
    
    if (text.trim().isEmpty) return tasks;
    
    try {
      final lowerText = text.toLowerCase();
      
      // Extract all time mentions
      List<Map<String, dynamic>> timeMatches = [];
      final timePattern = RegExp(r'(\d{1,2})(?::(\d{2}))?\s*(am|pm)?', caseSensitive: false);
      final matches = timePattern.allMatches(lowerText);
      
      for (var match in matches) {
        try {
          String timeStr = _formatTimeSafely(match);
          timeMatches.add({
            'time': timeStr,
            'position': match.start,
          });
        } catch (e) {
          continue;
        }
      }
      
      // Sort by position in text
      timeMatches.sort((a, b) => a['position'].compareTo(b['position']));
      
      // Extract activities between times
      List<String> activities = [];
      List<String> times = [];
      
      int lastPos = 0;
      for (var match in timeMatches) {
        int pos = match['position'];
        if (lastPos < pos) {
          String activity = lowerText.substring(lastPos, pos).trim();
          if (activity.isNotEmpty) {
            activities.add(activity);
            times.add(match['time']);
          }
        }
        lastPos = pos + 10; // Approximate end of time string
      }
      
      // Create tasks from activities and times
      for (int i = 0; i < times.length && i < activities.length; i++) {
        String activity = activities[i];
        String time = times[i];
        
        String title = _extractActivityTitle(activity);
        String emoji = _getEmojiForActivity(activity);
        String category = _getCategoryFromTime(time);
        int duration = _getDefaultDuration(activity);
        
        if (title.isNotEmpty) {
          tasks.add(RhythmTask(
            id: _uuid.v4(),
            title: title,
            time: time,
            emoji: emoji,
            category: category,
            duration: duration,
          ));
        }
      }
      
      // Sort all tasks by time
      tasks.sort((a, b) => _timeToMinutes(a.time).compareTo(_timeToMinutes(b.time)));
      
    } catch (e) {
      print('Error parsing input: $e');
    }
    
    return tasks;
  }

  String _formatTimeSafely(RegExpMatch match) {
    try {
      int hour = int.parse(match.group(1)!);
      String minute = match.group(2) ?? '00';
      String period = match.group(3)?.toLowerCase() ?? '';
      
      if (period == 'pm' && hour != 12) hour += 12;
      if (period == 'am' && hour == 12) hour = 0;
      
      hour = hour.clamp(0, 23);
      int minuteInt = int.tryParse(minute) ?? 0;
      minuteInt = minuteInt.clamp(0, 59);
      
      return '${hour.toString().padLeft(2, '0')}:${minuteInt.toString().padLeft(2, '0')}';
    } catch (e) {
      return '09:00';
    }
  }

  String _extractActivityTitle(String activity) {
    if (activity.contains('wake') || activity.contains('get up')) return 'Wake up';
    if (activity.contains('breakfast')) return 'Breakfast';
    if (activity.contains('lunch')) return 'Lunch';
    if (activity.contains('dinner')) return 'Dinner';
    if (activity.contains('sleep') || activity.contains('bed')) return 'Sleep';
    if (activity.contains('study')) return 'Study';
    if (activity.contains('gym')) return 'Gym';
    if (activity.contains('work')) return 'Work';
    if (activity.contains('relax')) return 'Relax';
    if (activity.contains('break')) return 'Break';
    return 'Activity';
  }

  String _getEmojiForActivity(String activity) {
    if (activity.contains('wake')) return '🌅';
    if (activity.contains('breakfast')) return '🍳';
    if (activity.contains('lunch')) return '🍲';
    if (activity.contains('dinner')) return '🍽️';
    if (activity.contains('sleep')) return '😴';
    if (activity.contains('study')) return '📚';
    if (activity.contains('gym')) return '💪';
    if (activity.contains('work')) return '💼';
    if (activity.contains('relax')) return '😌';
    if (activity.contains('break')) return '☕';
    return '⏰';
  }

  int _getDefaultDuration(String activity) {
    if (activity.contains('wake')) return 15;
    if (activity.contains('breakfast')) return 30;
    if (activity.contains('lunch')) return 45;
    if (activity.contains('dinner')) return 45;
    if (activity.contains('sleep')) return 480;
    if (activity.contains('study')) return 90;
    if (activity.contains('gym')) return 60;
    if (activity.contains('work')) return 120;
    if (activity.contains('relax')) return 30;
    if (activity.contains('break')) return 15;
    return 60;
  }

  String _getCategoryFromTime(String time) {
    try {
      int hour = int.parse(time.split(':')[0]);
      if (hour < 12) return 'morning';
      if (hour < 17) return 'afternoon';
      return 'evening';
    } catch (e) {
      return 'morning';
    }
  }

  int _timeToMinutes(String time) {
    try {
      var parts = time.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    } catch (e) {
      return 540;
    }
  }

  List<AISuggestion> generateOptimizations(List<RhythmTask> tasks, BuildContext context) {
    List<AISuggestion> suggestions = [];

    try {
      var studyBlocks = tasks.where((t) => t.title.contains('Study')).toList();
      for (var block in studyBlocks) {
        if (block.duration > 120) {
          suggestions.add(AISuggestion(
            id: _uuid.v4(),
            title: '🎯 Split Long Study Block',
            description: 'Research shows 90-min blocks work best. Split into smaller chunks?',
            type: 'study',
            icon: Icons.timer,
            onApply: () {},
            color: const Color(0xFFB4A7F5),
          ));
          break;
        }
      }

      int breakCount = tasks.where((t) => t.title.contains('Break')).length;
      if (breakCount < 2) {
        suggestions.add(AISuggestion(
          id: _uuid.v4(),
          title: '🧠 Add More Breaks',
          description: 'Your brain needs breaks every 90 mins. Add 10-min breaks!',
          type: 'break',
          icon: Icons.coffee,
          onApply: () {},
          color: const Color(0xFFA3E4D7),
        ));
      }

      var sleep = tasks.firstWhere((t) => t.title == 'Sleep', orElse: () => RhythmTask(
        id: '',
        title: 'Sleep',
        time: '23:00',
        emoji: '😴',
        category: 'evening',
        duration: 420,
      ));
      
      if (sleep.duration < 480) {
        suggestions.add(AISuggestion(
          id: _uuid.v4(),
          title: '😴 Improve Sleep',
          description: 'For students, 8-9 hours sleep is recommended. Go to bed earlier?',
          type: 'sleep',
          icon: Icons.nightlight_round,
          onApply: () {},
          color: const Color(0xFF6C5CE7),
        ));
      }
    } catch (e) {
      print('Error generating suggestions: $e');
    }

    return suggestions;
  }
}