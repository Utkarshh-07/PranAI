// lib/features/my_space/models/event_model.dart
import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String emoji;
  final String category;
  final bool isCompleted;
  final String? notes;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    this.startTime,
    this.endTime,
    this.emoji = '📝',
    this.category = 'other',
    this.isCompleted = false,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date.toIso8601String(),
    'startTime': startTime != null 
        ? '${startTime!.hour}:${startTime!.minute}' 
        : null,
    'endTime': endTime != null 
        ? '${endTime!.hour}:${endTime!.minute}' 
        : null,
    'emoji': emoji,
    'category': category,
    'isCompleted': isCompleted,
    'notes': notes,
  };

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // Helper function to parse time string to TimeOfDay
    TimeOfDay? _parseTime(String? timeString) {
      if (timeString == null) return null;
      try {
        final parts = timeString.split(':');
        if (parts.length == 2) {
          return TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }
      } catch (e) {
        print('Error parsing time: $e');
      }
      return null;
    }

    return EventModel(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      startTime: _parseTime(json['startTime']),
      endTime: _parseTime(json['endTime']),
      emoji: json['emoji'] ?? '📝',
      category: json['category'] ?? 'other',
      isCompleted: json['isCompleted'] ?? false,
      notes: json['notes'],
    );
  }
}