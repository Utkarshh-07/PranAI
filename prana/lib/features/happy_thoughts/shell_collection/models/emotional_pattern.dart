class EmotionalPattern {
  final String patternId;
  final DateTime detectedAt;
  final List<String> emotions; // ["anxious", "hopeful", "overwhelmed"]
  final List<String> topics; // ["exams", "friends", "family"]
  final Map<String, int> intensity; // {"stress": 7, "hope": 4}
  final List<String> copingMechanisms; // ["journaling", "breathing", "talking"]
  
  // NEVER includes personal details or exact conversations
  EmotionalPattern({
    required this.patternId,
    required this.detectedAt,
    required this.emotions,
    required this.topics,
    required this.intensity,
    required this.copingMechanisms,
  });
  
  // Get primary emotion (highest intensity)
  String get primaryEmotion {
    if (intensity.isEmpty) return emotions.isNotEmpty ? emotions.first : "neutral";
    
    var highestKey = intensity.keys.first;
    var highestValue = intensity[highestKey] ?? 0;
    
    intensity.forEach((key, value) {
      if (value > highestValue) {
        highestValue = value;
        highestKey = key;
      }
    });
    
    return highestKey;
  }
  
  // Get primary topic
  String get primaryTopic {
    return topics.isNotEmpty ? topics.first : "general";
  }
  
  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'patternId': patternId,
      'detectedAt': detectedAt.toIso8601String(),
      'emotions': emotions,
      'topics': topics,
      'intensity': intensity,
      'copingMechanisms': copingMechanisms,
    };
  }
  
  // Create from map
  factory EmotionalPattern.fromMap(Map<String, dynamic> map) {
    return EmotionalPattern(
      patternId: map['patternId'],
      detectedAt: DateTime.parse(map['detectedAt']),
      emotions: List<String>.from(map['emotions']),
      topics: List<String>.from(map['topics']),
      intensity: Map<String, int>.from(map['intensity']),
      copingMechanisms: List<String>.from(map['copingMechanisms']),
    );
  }
}