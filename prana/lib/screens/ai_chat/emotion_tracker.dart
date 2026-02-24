import 'package:flutter/material.dart';
import 'package:prana/features/happy_thoughts/shell_collection/services/ai_emotional_analyzer.dart';

class EmotionTracker extends StatefulWidget {
  final Function(Map<String, dynamic>) onEmotionDetected;
  
  const EmotionTracker({
    Key? key,
    required this.onEmotionDetected,
  }) : super(key: key);
  
  @override
  _EmotionTrackerState createState() => _EmotionTrackerState();
}

class _EmotionTrackerState extends State<EmotionTracker> {
  final List<String> _conversationHistory = [];
  final List<Map<String, dynamic>> _emotionalPatterns = [];
  
  // Track user input
  void trackUserMessage(String message) {
    _conversationHistory.add("User: $message");
    
    // Analyze for emotional patterns
    final pattern = AIEmotionalAnalyzer.analyzeEmotionalPatterns(message);
    
    if (pattern['emotions'].isNotEmpty) {
      _emotionalPatterns.add(pattern);
      widget.onEmotionDetected(pattern);
      
      // Show subtle feedback if significant emotion detected
      if (pattern['intensity'][pattern['primaryEmotion']] > 2) {
        _showEmotionFeedback(pattern['primaryEmotion']);
      }
    }
    
    // Keep only last 10 messages for privacy
    if (_conversationHistory.length > 10) {
      _conversationHistory.removeAt(0);
    }
  }
  
  // Track AI response
  void trackAIResponse(String response) {
    _conversationHistory.add("AI: $response");
  }
  
  // Get current emotional state
  Map<String, dynamic> getCurrentEmotionalState() {
    if (_emotionalPatterns.isEmpty) {
      return {
        'primaryEmotion': 'neutral',
        'intensity': {},
        'topics': [],
        'recommendedShellCategory': 'WISDOM',
      };
    }
    
    // Average out recent patterns
    final recentPatterns = _emotionalPatterns.length > 3 
        ? _emotionalPatterns.sublist(_emotionalPatterns.length - 3)
        : _emotionalPatterns;
    
    final Map<String, int> averageIntensity = {};
    final Set<String> allTopics = {};
    String primaryEmotion = 'neutral';
    int maxIntensity = 0;
    
    for (var pattern in recentPatterns) {
      final intensities = Map<String, int>.from(pattern['intensity']);
      
      intensities.forEach((emotion, intensity) {
        averageIntensity.update(
          emotion,
          (value) => (value + intensity) ~/ 2,
          ifAbsent: () => intensity,
        );
        
        if (averageIntensity[emotion]! > maxIntensity) {
          maxIntensity = averageIntensity[emotion]!;
          primaryEmotion = emotion;
        }
      });
      
      allTopics.addAll(List<String>.from(pattern['topics']));
    }
    
    // Determine shell category
    final String recommendedShellCategory = _getShellCategoryForEmotion(primaryEmotion);
    
    return {
      'primaryEmotion': primaryEmotion,
      'intensity': averageIntensity,
      'topics': allTopics.toList(),
      'recommendedShellCategory': recommendedShellCategory,
      'patternsCount': _emotionalPatterns.length,
    };
  }
  
  String _getShellCategoryForEmotion(String emotion) {
    final Map<String, String> emotionToCategory = {
      'stress': 'PEACE',
      'exam': 'COURAGE',
      'sad': 'HOPE',
      'happy': 'JOY',
      'confused': 'WISDOM',
      'anger': 'PEACE',
      'friends': 'CONNECTION',
      'family': 'CONNECTION',
    };
    
    return emotionToCategory[emotion] ?? 'WISDOM';
  }
  
  void _showEmotionFeedback(String emotion) {
    // Show subtle snackbar with ocean-themed message
    final messages = {
      'stress': '🌊 The ocean feels your waves of stress...',
      'sad': '💧 The tide understands your sadness...',
      'happy': '✨ The beach celebrates your joy with you!',
      'confused': '🌀 The spiral holds answers for your confusion...',
    };
    
    final message = messages[emotion];
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.blue.withOpacity(0.8),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
  
  // Clear tracking (for privacy)
  void clearTracking() {
    setState(() {
      _conversationHistory.clear();
      _emotionalPatterns.clear();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final currentState = getCurrentEmotionalState();
    
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.blue, size: 18),
              SizedBox(width: 8),
              Text(
                'Ocean\'s Insight',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.refresh, size: 18),
                color: Colors.blue,
                onPressed: clearTracking,
                tooltip: 'Clear emotional tracking',
              ),
            ],
          ),
          
          SizedBox(height: 10),
          
          // Emotional summary
          if (currentState['patternsCount'] > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current emotional tide:',
                  style: TextStyle(
                    color: Colors.blue.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getEmotionColor(currentState['primaryEmotion']),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        currentState['primaryEmotion'].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '→ ${currentState['recommendedShellCategory']} Shell',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Text(
              'The ocean is listening... Share your thoughts.',
              style: TextStyle(
                color: Colors.blue.withOpacity(0.6),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
  
  Color _getEmotionColor(String emotion) {
    final colors = {
      'stress': Colors.orange,
      'exam': Colors.purple,
      'sad': Colors.blue,
      'happy': Colors.green,
      'confused': Colors.yellow.shade700,
      'anger': Colors.red,
      'friends': Colors.pink,
      'family': Colors.deepPurple,
    };
    
    return colors[emotion] ?? Colors.grey;
  }
}