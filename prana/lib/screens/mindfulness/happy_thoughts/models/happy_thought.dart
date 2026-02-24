// lib/screens/mindfulness/happy_thoughts/models/happy_thought.dart

enum ThoughtType {
  messageBottle,
  sandWriting,
  shell,
  tidePool,
  beachArt,
  sunriseIntention,
  gratitude,
  twilightReflection
}

enum EmotionColor {
  sunsetOrange,    // #FF6B6B
  goldenYellow,    // #FFD166
  oceanTeal,       // #06D6A0
  skyBlue,         // #4CC9F0
  twilightPurple,  // #9D4EDD
  calmGreen,       // #2ECC71
  stormyGray,      // #95A5A6
}

enum ShellType {
  common,      // Daily entries
  rare,        // Weekly reflections
  golden,      // Milestones
  bioluminescent, // Special achievements
}

class HappyThought {
  final String id;
  final ThoughtType type;
  final String content;
  final EmotionColor emotion;
  final DateTime timestamp;
  final bool isFavorite;
  final List<String> tags;
  final ShellType? shellType; // For shell entries
  final String? bottleColor;  // For message bottles
  final double? tideLevel;    // For tide pool entries
  
  HappyThought({
    required this.id,
    required this.type,
    required this.content,
    required this.emotion,
    required this.timestamp,
    this.isFavorite = false,
    this.tags = const [],
    this.shellType,
    this.bottleColor,
    this.tideLevel,
  });
}