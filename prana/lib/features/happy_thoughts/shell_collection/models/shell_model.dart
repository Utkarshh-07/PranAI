import 'dart:ui';
import 'package:flutter/material.dart';

enum ShellRarity {
  COMMON,    // 🌟 White glow
  RARE,      // ✨ Blue glow  
  EPIC,      // 💎 Purple glow
  LEGENDARY, // 👑 Golden glow
  MYTHICAL,  // 🌈 Rainbow glow (AI-generated stories)
}

enum ShellCategory {
  COURAGE,     // For facing fears
  HOPE,        // For difficult times
  PEACE,       // For anxiety/stress
  WISDOM,      // For decision making
  CONNECTION,  // For relationships
  GROWTH,      // For personal development
  RESILIENCE,  // For bouncing back
  JOY, SEASHELL, GRATITUDE,         // For celebration
}

class Shell {
  final String id;
  final String name;
  final String emoji;
  final ShellRarity rarity;
  final ShellCategory category;
  final Color glowColor;
  final String description;
  final DateTime discoveredAt;
  final String discoveredIn; // Which feature found it
  final String? storyId; // Link to personalized story
  
  // Visual properties
  final double size;
  final List<Color> gradientColors;
  final String? specialEffect; // "sparkle", "pulse", "float", etc.
  
  Shell({
    required this.id,
    required this.name,
    required this.emoji,
    required this.rarity,
    required this.category,
    required this.glowColor,
    required this.description,
    required this.discoveredAt,
    required this.discoveredIn,
    this.storyId,
    this.size = 1.0,
    this.gradientColors = const [],
    this.specialEffect,
  });
  
  // Helper methods
  String get rarityString => rarity.toString().split('.').last;
  String get categoryString => category.toString().split('.').last;
  
  Color get rarityColor {
    switch (rarity) {
      case ShellRarity.COMMON: return Colors.white;
      case ShellRarity.RARE: return Colors.blue;
      case ShellRarity.EPIC: return Colors.purple;
      case ShellRarity.LEGENDARY: return Colors.yellow;
      case ShellRarity.MYTHICAL: return const Color(0xFFFF00FF);
    }
  }
}