import 'dart:math';
import 'package:flutter/material.dart';

class ShellDiscovery {
  // Track where shells can appear
  static final Map<String, double> _featureDiscoveryChances = {
    'message_bottle': 0.3,
    'sand_writing': 0.4,
    'tide_pool': 0.5,
    'beach_art': 0.3,
    'lighthouse': 0.2,
    'sunrise_intentions': 0.6,
    'star_map': 0.4,
    'breathing_exercise': 0.7,
    'power_nap': 0.7,
    'study_reset': 0.8, // High chance during study stress
    'evening_wind': 0.5,
  };
  
  // Emotional triggers for special shells
  static Map<String, List<String>> _emotionalTriggers = {
    'high_anxiety': ['ANCHOR_SHELL', 'CALM_WAVE_SHELL'],
    'recent_achievement': ['SUNRISE_SHELL', 'STARLIGHT_SHELL'],
    'loneliness': ['FRIEND_SHELL', 'COMMUNITY_SHELL'],
    'confusion': ['COMPASS_SHELL', 'LIGHTHOUSE_SHELL'],
    'celebration': ['RAINBOW_SHELL', 'GOLDEN_SHELL'],
  };
  
  // Check if a shell should appear
  static bool shouldDiscoverShell({
    required String feature,
    required List<String> recentEmotions,
    required DateTime lastDiscovery,
    required int userLevel,
  }) {
    final rand = Random();
    final baseChance = _featureDiscoveryChances[feature] ?? 0.1;
    
    // Increase chance based on emotions
    double emotionBonus = 0.0;
    for (var emotion in recentEmotions) {
      if (_emotionalTriggers.containsKey(emotion)) {
        emotionBonus += 0.2;
      }
    }
    
    // Decrease chance if discovered recently
    final hoursSinceLast = DateTime.now().difference(lastDiscovery).inHours;
    final cooldownPenalty = hoursSinceLast < 2 ? -0.3 : 0.0;
    
    // Level bonus
    final levelBonus = userLevel * 0.01;
    
    final totalChance = baseChance + emotionBonus + cooldownPenalty + levelBonus;
    
    return rand.nextDouble() < totalChance.clamp(0.0, 0.9);
  }
  
  // Get appropriate shell type for current situation
  static String getShellTypeForSituation({
    required List<String> emotions,
    required String currentActivity,
    required DateTime time,
  }) {
    // Check emotional triggers first
    for (var entry in _emotionalTriggers.entries) {
      if (emotions.any((e) => e.contains(entry.key))) {
        final shells = entry.value;
        return shells[Random().nextInt(shells.length)];
      }
    }
    
    // Time-based shells
    final hour = time.hour;
    if (hour >= 5 && hour < 10) return 'SUNRISE_SHELL';
    if (hour >= 18 && hour < 22) return 'SUNSET_SHELL';
    if (hour >= 22 || hour < 5) return 'MOONBEAM_SHELL';
    
    // Activity-based shells
    final activityShells = {
      'studying': 'FOCUS_SHELL',
      'journaling': 'REFLECTION_SHELL',
      'meditating': 'CALM_SHELL',
      'creating': 'INSPIRATION_SHELL',
      'social': 'CONNECTION_SHELL',
    };
    
    return activityShells[currentActivity] ?? 'WISDOM_SHELL';
  }
  
  // Get discovery message
  static String getDiscoveryMessage({
    required String shellType,
    required String feature,
    required DateTime time,
  }) {
    final timeOfDay = _getTimeOfDay(time);
    final messages = {
      'morning': [
        "The morning tide has brought you a gift... 🌅",
        "Sunlight glints off something in the sand... ✨",
        "The dawn whispers of treasures revealed...",
      ],
      'day': [
        "Something catches your eye by the shore... 👁️",
        "The ocean seems to be calling you... 🌊",
        "A gentle wave reveals a secret...",
      ],
      'evening': [
        "The setting sun illuminates a hidden treasure... 🌇",
        "Evening waves wash up a message...",
        "Twilight reveals what daylight hid...",
      ],
      'night': [
        "Moonlight reflects off something magical... 🌙",
        "The night sea has a story for you...",
        "Starlight guides you to a discovery... ⭐",
      ],
    };
    
    final timeMessages = messages[timeOfDay] ?? messages['day']!;
    return timeMessages[Random().nextInt(timeMessages.length)];
  }
  
  static String _getTimeOfDay(DateTime time) {
    final hour = time.hour;
    if (hour >= 5 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 17) return 'day';
    if (hour >= 17 && hour < 21) return 'evening';
    return 'night';
  }
}