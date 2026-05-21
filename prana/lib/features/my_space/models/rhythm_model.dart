// lib/features/my_space/models/rhythm_model.dart
import 'package:flutter/material.dart';
import 'dart:convert';

class RhythmTask {
  final String id;
  String title;
  String time;
  String emoji;
  bool isCompleted;
  String category; // morning, afternoon, evening
  int duration; // in minutes
  bool isOptimized;

  RhythmTask({
    required this.id,
    required this.title,
    required this.time,
    required this.emoji,
    this.isCompleted = false,
    required this.category,
    this.duration = 60,
    this.isOptimized = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'time': time,
    'emoji': emoji,
    'isCompleted': isCompleted,
    'category': category,
    'duration': duration,
    'isOptimized': isOptimized,
  };

  factory RhythmTask.fromJson(Map<String, dynamic> json) {
    return RhythmTask(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      emoji: json['emoji'],
      isCompleted: json['isCompleted'] ?? false,
      category: json['category'],
      duration: json['duration'] ?? 60,
      isOptimized: json['isOptimized'] ?? false,
    );
  }
}

class UserRhythm {
  final String id;
  final DateTime createdAt;
  List<RhythmTask> tasks;
  int streak;
  DateTime? lastCompletedDate;

  UserRhythm({
    required this.id,
    required this.createdAt,
    required this.tasks,
    this.streak = 0,
    this.lastCompletedDate,
  });

  int get completedCount => tasks.where((t) => t.isCompleted).length;
  int get totalCount => tasks.length;
  double get progress => totalCount > 0 ? completedCount / totalCount : 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'tasks': tasks.map((t) => t.toJson()).toList(),
    'streak': streak,
    'lastCompletedDate': lastCompletedDate?.toIso8601String(),
  };

  factory UserRhythm.fromJson(Map<String, dynamic> json) {
    return UserRhythm(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      tasks: (json['tasks'] as List).map((t) => RhythmTask.fromJson(t)).toList(),
      streak: json['streak'] ?? 0,
      lastCompletedDate: json['lastCompletedDate'] != null 
          ? DateTime.parse(json['lastCompletedDate']) 
          : null,
    );
  }

  // Convert to JSON string for storage
  String toJsonString() => jsonEncode(toJson());

  // Create from JSON string
  static UserRhythm? fromJsonString(String jsonString) {
    try {
      return UserRhythm.fromJson(jsonDecode(jsonString));
    } catch (e) {
      print('Error parsing rhythm: $e');
      return null;
    }
  }
}

class AISuggestion {
  final String id;
  final String title;
  final String description;
  final String type; // 'study', 'break', 'sleep', 'optimization'
  final IconData icon;
  final VoidCallback onApply;
  final Color color;

  AISuggestion({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
    required this.onApply,
    required this.color,
  });
}