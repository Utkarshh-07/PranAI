import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../models/notification_settings.dart';

class NotificationService {
  static const String _settingsKey = 'notification_settings';
  
  Future<void> saveSettings(NotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, settings.toJson().toString());
  }

  Future<NotificationSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? settingsStr = prefs.getString(_settingsKey);
    
    if (settingsStr == null) {
      return NotificationSettings();
    }
    
    return NotificationSettings();
  }

  Future<void> scheduleEventReminder(EventModel event) async {
    final settings = await loadSettings();
    
    if (!settings.allowNotifications || !settings.preEventReminders) {
      return;
    }

    if (event.startTime == null) return;

    final now = DateTime.now();
    final eventDateTime = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
      event.startTime!.hour,
      event.startTime!.minute,
    );

    final eventHour = eventDateTime.hour;
    final quietStart = settings.quietHourStart.hour;
    final quietEnd = settings.quietHourEnd.hour;
    
    if (eventHour >= quietStart || eventHour < quietEnd) {
      print('⏰ Event during quiet hours - no notification');
      return;
    }

    final reminderTime = eventDateTime.subtract(
      Duration(minutes: settings.defaultReminderMinutes),
    );

    if (reminderTime.isBefore(now)) {
      print('⏰ Reminder time already passed');
      return;
    }

    print('✅ Notification scheduled for ${event.title} at $reminderTime');
  }

  Future<void> checkStudyBalance(List<EventModel> events) async {
    final settings = await loadSettings();
    
    if (!settings.allowNotifications || !settings.balanceAlerts) return;

    int studyStreak = 0;
    final today = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      final day = today.subtract(Duration(days: i));
      final dayEvents = events.where((e) => 
        e.date.year == day.year &&
        e.date.month == day.month &&
        e.date.day == day.day &&
        e.category == 'study'
      ).toList();
      
      if (dayEvents.isNotEmpty) {
        studyStreak++;
      } else {
        break;
      }
    }

    if (studyStreak >= 5) {
      print('🌊 Balance alert: $studyStreak study days in a row');
    }
  }

  Future<void> sendMorningSummary(List<EventModel> events) async {
    final settings = await loadSettings();
    
    if (!settings.allowNotifications || !settings.dailyMorningSummary) return;

    final today = DateTime.now();
    final todayEvents = events.where((e) => 
      e.date.year == today.year &&
      e.date.month == today.month &&
      e.date.day == today.day
    ).toList();

    if (todayEvents.isEmpty) return;

    print('🌅 Good morning! You have ${todayEvents.length} events today');
    todayEvents.forEach((e) {
      print('  • ${e.emoji} ${e.title}');
    });
  }
}