class ShellStory {
  final String id;
  final String shellId;
  final String title;
  final String story;
  final String personalizedFor; // User's situation
  final DateTime generatedAt;
  final List<String> themes; // ["exam_stress", "resilience", "hope"]
  final Map<String, dynamic> metadata;
  
  // Interactive elements
  final Map<String, String> tapReveals; // {"storm": "gentle thunder animation"}
  final List<String> voiceNarration; // For TTS
  final String callToAction;
  final String shareableQuote;
  
  ShellStory({
    required this.id,
    required this.shellId,
    required this.title,
    required this.story,
    required this.personalizedFor,
    required this.generatedAt,
    required this.themes,
    this.metadata = const {},
    this.tapReveals = const {},
    this.voiceNarration = const [],
    this.callToAction = "",
    this.shareableQuote = "",
  });
  
  // Format date for display
  String get formattedDate {
    return "${generatedAt.day}/${generatedAt.month}/${generatedAt.year}";
  }
  
  // Get first paragraph for preview
  String get preview {
    final paragraphs = story.split('\n\n');
    return paragraphs.isNotEmpty ? paragraphs.first : story.substring(0, 100);
  }
}