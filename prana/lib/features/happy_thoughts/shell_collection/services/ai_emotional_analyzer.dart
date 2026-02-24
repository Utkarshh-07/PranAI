import 'package:intl/intl.dart';

class AIEmotionalAnalyzer {
  // Analyze text for emotional patterns (PRIVACY SAFE - no storage of actual text)
  static Map<String, dynamic> analyzeEmotionalPatterns(String text) {
    // Convert to lowercase for analysis
    final lowerText = text.toLowerCase();
    
    // Emotional keywords (simplified for demo - in real app, use ML/NLP)
    final emotionalKeywords = {
      'exam': ['exam', 'test', 'board', 'study', 'syllabus', 'marks', 'result'],
      'stress': ['stress', 'pressure', 'tension', 'anxious', 'worried', 'nervous'],
      'friends': ['friend', 'bestie', 'group', 'lonely', 'ignore', 'fight'],
      'family': ['mom', 'dad', 'parents', 'family', 'sibling', 'brother', 'sister'],
      'sad': ['sad', 'cry', 'tears', 'hurt', 'pain', 'depressed', 'unhappy'],
      'happy': ['happy', 'joy', 'excited', 'celebrate', 'good', 'great', 'amazing'],
      'confused': ['confuse', 'doubt', 'unsure', 'which', 'what', 'how', 'why'],
      'anger': ['angry', 'mad', 'hate', 'annoy', 'frustrated', 'irritated'],
    };
    
    // Detect which categories are present
    final List<String> detectedEmotions = [];
    final Map<String, int> intensity = {};
    final List<String> detectedTopics = [];
    
    emotionalKeywords.forEach((category, keywords) {
      int count = 0;
      for (var keyword in keywords) {
        if (lowerText.contains(keyword)) {
          count++;
        }
      }
      
      if (count > 0) {
        detectedEmotions.add(category);
        intensity[category] = count;
        
        // Some emotions are also topics
        if (['exam', 'friends', 'family'].contains(category)) {
          detectedTopics.add(category);
        }
      }
    });
    
    // Detect coping mechanisms mentioned
    final List<String> copingMechanisms = [];
    final copingKeywords = {
      'breathing': ['breathe', 'inhale', 'exhale', 'calm breath'],
      'meditation': ['meditate', 'mindful', 'focus', 'present'],
      'journaling': ['write', 'journal', 'diary', 'note'],
      'talking': ['talk', 'share', 'tell', 'discuss', 'vent'],
      'exercise': ['walk', 'run', 'exercise', 'yoga', 'stretch'],
    };
    
    copingKeywords.forEach((mechanism, keywords) {
      if (keywords.any((keyword) => lowerText.contains(keyword))) {
        copingMechanisms.add(mechanism);
      }
    });
    
    // Determine primary emotion
    String primaryEmotion = 'neutral';
    if (detectedEmotions.isNotEmpty) {
      // Find emotion with highest intensity
      var highestKey = detectedEmotions.first;
      var highestValue = intensity[highestKey] ?? 0;
      
      intensity.forEach((key, value) {
        if (value > highestValue) {
          highestValue = value;
          highestKey = key;
        }
      });
      
      primaryEmotion = highestKey;
    }
    
    // Determine recommended shell category
    final String recommendedShellCategory = _getRecommendedShellCategory(
      detectedEmotions,
      detectedTopics,
      primaryEmotion,
    );
    
    return {
      'patternId': 'pattern_${DateTime.now().millisecondsSinceEpoch}',
      'detectedAt': DateTime.now().toIso8601String(),
      'emotions': detectedEmotions,
      'topics': detectedTopics,
      'intensity': intensity,
      'copingMechanisms': copingMechanisms,
      'primaryEmotion': primaryEmotion,
      'primaryTopic': detectedTopics.isNotEmpty ? detectedTopics.first : 'general',
      'recommendedShellCategory': recommendedShellCategory,
      'currentChallenge': detectedTopics.isNotEmpty ? 
          '${detectedTopics.first}_challenge' : 'personal_growth',
    };
  }
  
  static String _getRecommendedShellCategory(
    List<String> emotions,
    List<String> topics,
    String primaryEmotion,
  ) {
    // Map emotions to shell categories
    final Map<String, String> emotionToShellCategory = {
      'exam': 'COURAGE',
      'stress': 'PEACE',
      'sad': 'HOPE',
      'happy': 'JOY',
      'confused': 'WISDOM',
      'anger': 'PEACE',
      'friends': 'CONNECTION',
      'family': 'CONNECTION',
    };
    
    // Try to get specific category
    for (var emotion in emotions) {
      if (emotionToShellCategory.containsKey(emotion)) {
        return emotionToShellCategory[emotion]!;
      }
    }
    
    // Default based on primary emotion
    if (emotionToShellCategory.containsKey(primaryEmotion)) {
      return emotionToShellCategory[primaryEmotion]!;
    }
    
    // Fallback
    return 'WISDOM';
  }
  
  // Get user strength based on coping mechanisms
  static String getUserStrength(List<String> copingMechanisms) {
    if (copingMechanisms.isEmpty) return 'resilience';
    
    final strengths = {
      'breathing': 'self-regulation',
      'meditation': 'mindfulness',
      'journaling': 'self-reflection',
      'talking': 'communication',
      'exercise': 'discipline',
    };
    
    // Return first matching strength
    for (var mechanism in copingMechanisms) {
      if (strengths.containsKey(mechanism)) {
        return strengths[mechanism]!;
      }
    }
    
    return 'resilience';
  }
}