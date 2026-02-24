import 'package:flutter/material.dart';

class NotificationSettings {
  bool allowNotifications;
  bool preEventReminders;
  bool dailyMorningSummary;
  bool weeklyPreview;
  bool balanceAlerts;
  bool postEventCheckins;
  
  TimeOfDay quietHourStart;
  TimeOfDay quietHourEnd;
  
  int defaultReminderMinutes;
  
  String sound;

  NotificationSettings({
    this.allowNotifications = true,
    this.preEventReminders = true,
    this.dailyMorningSummary = true,
    this.weeklyPreview = true,
    this.balanceAlerts = true,
    this.postEventCheckins = true,
    this.quietHourStart = const TimeOfDay(hour: 22, minute: 0),
    this.quietHourEnd = const TimeOfDay(hour: 8, minute: 0),
    this.defaultReminderMinutes = 15,
    this.sound = 'gentle',
  });

  Map<String, dynamic> toJson() => {
    'allowNotifications': allowNotifications,
    'preEventReminders': preEventReminders,
    'dailyMorningSummary': dailyMorningSummary,
    'weeklyPreview': weeklyPreview,
    'balanceAlerts': balanceAlerts,
    'postEventCheckins': postEventCheckins,
    'quietHourStart': '${quietHourStart.hour}:${quietHourStart.minute}',
    'quietHourEnd': '${quietHourEnd.hour}:${quietHourEnd.minute}',
    'defaultReminderMinutes': defaultReminderMinutes,
    'sound': sound,
  };

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    TimeOfDay _parseTime(String timeString) {
      final parts = timeString.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return NotificationSettings(
      allowNotifications: json['allowNotifications'] ?? true,
      preEventReminders: json['preEventReminders'] ?? true,
      dailyMorningSummary: json['dailyMorningSummary'] ?? true,
      weeklyPreview: json['weeklyPreview'] ?? true,
      balanceAlerts: json['balanceAlerts'] ?? true,
      postEventCheckins: json['postEventCheckins'] ?? true,
      quietHourStart: _parseTime(json['quietHourStart'] ?? '22:0'),
      quietHourEnd: _parseTime(json['quietHourEnd'] ?? '8:0'),
      defaultReminderMinutes: json['defaultReminderMinutes'] ?? 15,
      sound: json['sound'] ?? 'gentle',
    );
  }
}