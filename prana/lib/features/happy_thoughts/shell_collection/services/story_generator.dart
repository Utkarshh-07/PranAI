import 'package:intl/intl.dart';

class StoryGenerator {
  // Database of ocean metaphors mapped to situations
  static final Map<String, List<String>> _metaphorDatabase = {
    "exam_stress": [
      "navigating through exam fog",
      "riding waves of equations",
      "anchoring in stormy study sessions",
      "following the lighthouse of knowledge",
    ],
    "friendship_issues": [
      "tides of friendship ebb and flow",
      "coral reefs of connection",
      "schools of fish sticking together",
      "barnacles of loyalty on life's whale",
    ],
    "family_pressure": [
      "ocean floor supporting everything above",
      "currents pulling in different directions",
      "tsunami of expectations",
      "safe harbor in family storms",
    ],
    "self_doubt": [
      "shell doubting its own pattern",
      "wave unsure if it should crash or retreat",
      "starfish regrowing lost arms",
      "pearl forming from irritation",
    ],
  };
  
  static final List<String> _shellTemplates = [
    "The {adjective} {shell_type} Shell",
    "{shell_type} of {quality}",
    "The {time} {shell_type}",
    "{shell_type} from the {location}",
  ];
  
  static final Map<String, List<String>> _shellTypes = {
    "COURAGE": ["Anchor", "Lighthouse", "Storm", "Navigator"],
    "HOPE": ["Sunrise", "Rainbow", "Starlight", "Moonbeam"],
    "PEACE": ["Tide Pool", "Calm Wave", "Gentle Breeze", "Still Water"],
    "WISDOM": ["Ancient", "Spiral", "Oracle", "Compass"],
    "CONNECTION": ["Friend", "Family", "Community", "Twin"],
  };
  
  // Generate personalized shell story
  static Map<String, dynamic> generateStory({
    required List<String> emotionalThemes,
    required String currentChallenge,
    required String userStrength,
    required String shellCategory,
  }) {
    final storyId = 'story_${DateTime.now().millisecondsSinceEpoch}';
    final shellId = 'shell_${_generateShellId(shellCategory)}';
    
    // Get current time and date for personalization
    final now = DateTime.now();
    final timeOfDay = _getTimeOfDay(now);
    final season = _getSeason(now);
    final moonPhase = _getMoonPhase(now);
    
    // Generate story
    final title = _generateTitle(shellCategory);
    final story = _generateStoryContent(
      emotionalThemes: emotionalThemes,
      currentChallenge: currentChallenge,
      userStrength: userStrength,
      shellCategory: shellCategory,
      timeOfDay: timeOfDay,
      season: season,
      moonPhase: moonPhase,
    );
    
    // Create shareable quote (most powerful line)
    final shareableQuote = _extractShareableQuote(story);
    
    return {
      'id': storyId,
      'shellId': shellId,
      'title': title,
      'story': story,
      'personalizedFor': currentChallenge,
      'generatedAt': now.toIso8601String(),
      'themes': emotionalThemes,
      'metadata': {
        'time_of_day': timeOfDay,
        'season': season,
        'moon_phase': moonPhase,
        'shell_category': shellCategory,
      },
      'tapReveals': {
        'storm': 'gentle thunder animation',
        'wave': 'wave sound effect',
        'sun': 'screen brightens',
        'moon': 'moon glows',
      },
      'voiceNarration': _splitForNarration(story),
      'callToAction': _generateCallToAction(emotionalThemes.isNotEmpty ? emotionalThemes.first : "neutral"),
      'shareableQuote': shareableQuote,
    };
  }
  
  static String _generateTitle(String category) {
    final adjectives = ["Whispering", "Ancient", "Luminous", "Secret", "Guiding"];
    final shellType = _shellTypes[category]?.first ?? "Shell";
    final template = _shellTemplates[DateTime.now().second % _shellTemplates.length];
    
    return template
        .replaceAll('{adjective}', adjectives[DateTime.now().millisecond % adjectives.length])
        .replaceAll('{shell_type}', shellType)
        .replaceAll('{quality}', category.toLowerCase())
        .replaceAll('{time}', _getTimeOfDay(DateTime.now()))
        .replaceAll('{location}', ["Deep Sea", "Coral Reef", "Shoreline", "Tide Pool"][DateTime.now().minute % 4]);
  }
  
  static String _generateStoryContent({
    required List<String> emotionalThemes,
    required String currentChallenge,
    required String userStrength,
    required String shellCategory,
    required String timeOfDay,
    required String season,
    required String moonPhase,
  }) {
    final metaphors = _getMetaphorsForThemes(emotionalThemes);
    final openingLines = [
      "I was born during ${metaphors['origin']}. The ocean ${metaphors['action']}.",
      "For ${[100, 500, 1000, 10000][DateTime.now().second % 4]} years, I've ${metaphors['experience']}.",
      "My journey began when ${metaphors['beginning']}.",
    ];
    
    final middleLines = [
      "I see you facing ${currentChallenge}. ${metaphors['observation']}.",
      "Your situation reminds me of when ${metaphors['parallel']}.",
      "The ocean taught me: ${metaphors['wisdom']}.",
    ];
    
    final endingLines = [
      "Remember: ${metaphors['lesson']}.",
      "Next time you feel ${emotionalThemes.isNotEmpty ? emotionalThemes.first : "uncertain"}, ${metaphors['action_step']}.",
      "Carry this ${shellCategory.toLowerCase()} with you. ${metaphors['encouragement']}.",
    ];
    
    final signature = "\n\n- The Ocean, on this ${timeOfDay} ${season} night under a ${moonPhase} moon";
    
    return [
      openingLines[DateTime.now().millisecond % openingLines.length],
      middleLines[DateTime.now().millisecond % middleLines.length],
      endingLines[DateTime.now().millisecond % endingLines.length],
      signature,
    ].join('\n\n');
  }
  
  static Map<String, String> _getMetaphorsForThemes(List<String> themes) {
    final primaryTheme = themes.isNotEmpty ? themes.first : "growth";
    final allMetaphors = {
      'origin': "a great storm",
      'action': "shaped me with its relentless waves",
      'experience': "watched sailors find their way",
      'beginning': "the first wave kissed the shore",
      'observation': "Your courage reminds me of migrating whales",
      'parallel': "I was tossed in hurricanes but found calm",
      'wisdom': "Even the mightiest waves return to calm",
      'lesson': "Pressure creates pearls",
      'action_step': "listen to the tide within you",
      'encouragement': "You're stronger than you know",
    };
    
    // Customize based on theme
    if (primaryTheme.contains('exam')) {
      allMetaphors['origin'] = "the season of monsoons";
      allMetaphors['lesson'] = "Knowledge is the tide that lifts all boats";
    } else if (primaryTheme.contains('friend')) {
      allMetaphors['origin'] = "a coral reef community";
      allMetaphors['lesson'] = "True connections weather all storms";
    }
    
    return allMetaphors;
  }
  
  static String _extractShareableQuote(String story) {
    final sentences = story.split('.');
    if (sentences.length > 3) {
      // Return the most poetic sentence (usually contains metaphors)
      final poeticSentences = sentences.where((s) => 
          s.contains('ocean') || 
          s.contains('wave') || 
          s.contains('tide') || 
          s.contains('storm')).toList();
      
      if (poeticSentences.isNotEmpty) {
        return poeticSentences.first.trim() + '.';
      }
    }
    return "The ocean remembers your strength. 🌊";
  }
  
  static String _generateCallToAction(String emotion) {
    final actions = {
      'anxious': "Breathe with the waves. Inhale the calm, exhale the storm.",
      'sad': "Let the tide carry your tears to distant shores.",
      'angry': "Be the shore: firm, stable, unyielding to rage.",
      'happy': "Dance like sunlight on waves. Celebrate each ripple.",
      'confused': "Follow the spiral within. Each turn reveals answers.",
    };
    
    return actions[emotion] ?? "Listen to the ocean within you.";
  }
  
  // Helper methods
  static String _getTimeOfDay(DateTime time) {
    final hour = time.hour;
    if (hour < 6) return "predawn";
    if (hour < 12) return "morning";
    if (hour < 17) return "afternoon";
    if (hour < 21) return "evening";
    return "midnight";
  }
  
  static String _getSeason(DateTime time) {
    final month = time.month;
    if (month >= 3 && month <= 5) return "spring";
    if (month >= 6 && month <= 8) return "summer";
    if (month >= 9 && month <= 11) return "autumn";
    return "winter";
  }
  
  static String _getMoonPhase(DateTime time) {
    // Simplified moon phase calculation
    final daysInCycle = 29.53;
    final knownNewMoon = DateTime(2024, 1, 11);
    final daysSince = time.difference(knownNewMoon).inDays.toDouble();
    final cyclePosition = daysSince % daysInCycle;
    
    if (cyclePosition < 1) return "new moon";
    if (cyclePosition < 7.4) return "waxing crescent";
    if (cyclePosition < 14.8) return "first quarter";
    if (cyclePosition < 22.2) return "waxing gibbous";
    if (cyclePosition < 29.53) return "waning crescent";
    return "full moon";
  }
  
  static String _generateShellId(String category) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = (DateTime.now().microsecond % 1000).toString().padLeft(3, '0');
    return '${category.substring(0, 3).toLowerCase()}_$timestamp$random';
  }
  
  static List<String> _splitForNarration(String text) {
    return text.split(RegExp(r'[.!?]')).where((s) => s.trim().isNotEmpty).toList();
  }
}