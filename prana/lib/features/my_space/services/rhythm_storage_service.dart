// lib/features/my_space/services/rhythm_storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rhythm_model.dart';
import 'package:uuid/uuid.dart';

class RhythmStorageService {
  static const String _rhythmKey = 'user_rhythm';
  static const String _streakKey = 'rhythm_streak';
  final Uuid _uuid = const Uuid();

  // Save rhythm
  Future<void> saveRhythm(UserRhythm rhythm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rhythmKey, rhythm.toJsonString());
  }

  // Load rhythm
  Future<UserRhythm?> loadRhythm() async {
    final prefs = await SharedPreferences.getInstance();
    final String? rhythmString = prefs.getString(_rhythmKey);
    
    if (rhythmString != null) {
      return UserRhythm.fromJsonString(rhythmString);
    }
    return null;
  }

  // Create default rhythm (when none exists)
  UserRhythm createDefaultRhythm() {
    return UserRhythm(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      tasks: _getDefaultTasks(),
    );
  }

  List<RhythmTask> _getDefaultTasks() {
    return [
      // Morning
      RhythmTask(
        id: _uuid.v4(),
        title: 'Wake up',
        time: '07:00',
        emoji: '🌅',
        category: 'morning',
        duration: 15,
      ),
      RhythmTask(
        id: _uuid.v4(),
        title: 'Morning routine',
        time: '07:30',
        emoji: '🚿',
        category: 'morning',
        duration: 30,
      ),
      RhythmTask(
        id: _uuid.v4(),
        title: 'Breakfast',
        time: '08:00',
        emoji: '🍳',
        category: 'morning',
        duration: 30,
      ),
      RhythmTask(
        id: _uuid.v4(),
        title: 'Study Block 1',
        time: '09:00',
        emoji: '📚',
        category: 'morning',
        duration: 90,
      ),
      
      // Afternoon
      RhythmTask(
        id: _uuid.v4(),
        title: 'Lunch',
        time: '12:30',
        emoji: '🍲',
        category: 'afternoon',
        duration: 45,
      ),
      RhythmTask(
        id: _uuid.v4(),
        title: 'Study Block 2',
        time: '13:30',
        emoji: '📚',
        category: 'afternoon',
        duration: 90,
      ),
      RhythmTask(
        id: _uuid.v4(),
        title: 'Break',
        time: '15:00',
        emoji: '☕',
        category: 'afternoon',
        duration: 15,
      ),
      RhythmTask(
        id: _uuid.v4(),
        title: 'Study Block 3',
        time: '15:15',
        emoji: '📚',
        category: 'afternoon',
        duration: 90,
      ),
      
      // Evening
      RhythmTask(
        id: _uuid.v4(),
        title: 'Dinner',
        time: '19:00',
        emoji: '🍽️',
        category: 'evening',
        duration: 45,
      ),
      RhythmTask(
        id: _uuid.v4(),
        title: 'Relax',
        time: '20:00',
        emoji: '🎮',
        category: 'evening',
        duration: 60,
      ),
      RhythmTask(
        id: _uuid.v4(),
        title: 'Wind down',
        time: '21:30',
        emoji: '😌',
        category: 'evening',
        duration: 30,
      ),
      RhythmTask(
        id: _uuid.v4(),
        title: 'Sleep',
        time: '22:30',
        emoji: '😴',
        category: 'evening',
        duration: 510, // 8.5 hours
      ),
    ];
  }

  // Update task completion
  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    final rhythm = await loadRhythm();
    if (rhythm != null) {
      final task = rhythm.tasks.firstWhere((t) => t.id == taskId);
      task.isCompleted = isCompleted;
      await saveRhythm(rhythm);
      
      // Check if all tasks are completed
      if (rhythm.completedCount == rhythm.totalCount) {
        await _updateStreak();
      }
    }
  }

  // Update streak when all tasks completed
  Future<void> _updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final lastCompleted = prefs.getString('last_completed_date');
    
    int currentStreak = prefs.getInt(_streakKey) ?? 0;
    
    if (lastCompleted != null) {
      final lastDate = DateTime.parse(lastCompleted);
      final difference = now.difference(lastDate).inDays;
      
      if (difference == 1) {
        // Consecutive day
        currentStreak++;
      } else if (difference > 1) {
        // Streak broken
        currentStreak = 1;
      }
    } else {
      // First time
      currentStreak = 1;
    }
    
    await prefs.setInt(_streakKey, currentStreak);
    await prefs.setString('last_completed_date', now.toIso8601String());
  }

  // Get current streak
  Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  // Reset all tasks for new day
  Future<void> resetDailyTasks() async {
    final rhythm = await loadRhythm();
    if (rhythm != null) {
      for (var task in rhythm.tasks) {
        task.isCompleted = false;
      }
      await saveRhythm(rhythm);
    }
  }
}