// lib/services/emotional_analysis_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Move enum outside the class
enum AlertTier {
  celebration,
  lowConcern,
  attention,
  support,
  urgent,
}

class EmotionalAnalysisService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Public methods for parent dashboard
  Map<String, dynamic> getExamStressNotification(String childName) {
    return _getExamStressNotification(childName);
  }

  Map<String, dynamic> getLonelinessNotification(String childName) {
    return _getLonelinessNotification(childName);
  }

  Map<String, dynamic> getAchievementNotification(String childName) {
    return _getAchievementNotification(childName);
  }

  Map<String, dynamic> getUrgentNotification(String childName) {
    return _getUrgentNotification(childName);
  }

  // Private methods (keep underscore)
  Map<String, dynamic> _getExamStressNotification(String childName) {
    return {
      'title': '🌊 PRANAI - Parent Insight',
      'body': '$childName seems to be under significant exam pressure.\n\nHe mentioned feeling scared about upcoming exams and worries about disappointing you.',
      'type': 'support',
      'actionStep': 'No lectures. No pressure. Just say:\n\n"I love you no matter what marks you get. And remember YOUR failure story?"\n\nSometimes knowing you\'ve been there too means more than any study tip.',
    };
  }

  Map<String, dynamic> _getLonelinessNotification(String childName) {
    return {
      'title': '🌊 PRANAI - Parent Insight',
      'body': '$childName has been showing signs of emotional withdrawal.\n\nHe mentioned feeling misunderstood and wanting to be alone.',
      'type': 'attention',
      'actionStep': 'Don\'t force a conversation. Just sit with him.\n\nWatch his favourite show together. Or cook something together.\n\nSometimes presence > words.\n\n"I\'m here if you want to talk. No pressure."',
    };
  }

  Map<String, dynamic> _getAchievementNotification(String childName) {
    return {
      'title': '🎉 PRANAI - Parent Joy',
      'body': '$childName achieved something today!\n\nHe finished his tasks and feels proud of himself!',
      'type': 'celebration',
      'actionStep': '"I heard you worked really hard today. I\'m proud of you. Let\'s celebrate your win!"\n\nA little recognition goes a long way.',
    };
  }

  Map<String, dynamic> _getUrgentNotification(String childName) {
    return {
      'title': '🚨 URGENT PARENT ALERT',
      'body': '$childName has expressed severe distress. Immediate attention needed.',
      'type': 'urgent',
      'actionSteps': [
        'Go to them NOW',
        'Say: "I\'m here. I love you. You\'re not alone."',
        'Listen without judgment',
        'Call helpline for guidance',
      ],
      'helplines': [
        {'name': 'iCall', 'number': '9152987821'},
        {'name': 'Aasra', 'number': '9820466726'},
        {'name': 'Sneha', 'number': '04424640050'},
      ],
    };
  }

  Map<String, dynamic> analyzeMessageDemo(String message, String childName) {
    final lowerMsg = message.toLowerCase();
    
    // Emergency keywords
    if (lowerMsg.contains('disappear') || 
        lowerMsg.contains('end it') || 
        lowerMsg.contains('no point') ||
        lowerMsg.contains('can\'t do this')) {
      return {
        'tier': AlertTier.urgent,
        'notification': _getUrgentNotification(childName),
        'shouldSend': true,
      };
    }
    
    // Exam stress
    if ((lowerMsg.contains('exam') || lowerMsg.contains('test')) && 
        (lowerMsg.contains('scared') || lowerMsg.contains('fail') || lowerMsg.contains('stress'))) {
      return {
        'tier': AlertTier.support,
        'notification': _getExamStressNotification(childName),
        'shouldSend': true,
      };
    }
    
    // Loneliness
    if (lowerMsg.contains('alone') || lowerMsg.contains('no friends') || lowerMsg.contains('don\'t get me')) {
      return {
        'tier': AlertTier.attention,
        'notification': _getLonelinessNotification(childName),
        'shouldSend': true,
      };
    }
    
    // Achievement
    if (lowerMsg.contains('proud') || lowerMsg.contains('finished') || lowerMsg.contains('did it')) {
      return {
        'tier': AlertTier.celebration,
        'notification': _getAchievementNotification(childName),
        'shouldSend': true,
      };
    }
    
    // Default
    return {
      'tier': AlertTier.lowConcern,
      'notification': null,
      'shouldSend': false,
    };
  }

  Future<void> sendDemoNotification(String parentId, Map<String, dynamic> notification) async {
    await _firestore.collection('notifications').add({
      'userId': parentId,
      'title': notification['title'],
      'body': notification['body'],
      'type': notification['type'],
      'actionStep': notification['actionStep'],
      'helplines': notification['helplines'],
      'actionSteps': notification['actionSteps'],
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }
}