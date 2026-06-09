// lib/services/ai_service.dart (LOCAL AI - FIXED)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_character_model.dart';

class AIService extends ChangeNotifier {
  List<AICharacter> _friends = [];
  bool _isLoading = false;
  final Map<String, List<Map<String, String>>> _conversationHistory = {};

  AIService() {
    _initializeDefaultFriends();
    _loadFromPrefs();
    print('🤖 AIService Initialized - LOCAL AI MODE');
  }

  bool get isLoading => _isLoading;

  void _initializeDefaultFriends() {
    if (_friends.isEmpty) {
      _friends = [
        AICharacter(id: 'ai_1', name: 'Alex', gender: 'male', voiceType: 'calm', baseColor: '#7C9AFF', eyeColor: '#FFFFFF'),
        AICharacter(id: 'ai_2', name: 'Jordan', gender: 'neutral', voiceType: 'energetic', baseColor: '#FF69B4', eyeColor: '#FFFFFF'),
        AICharacter(id: 'ai_3', name: 'Taylor', gender: 'female', voiceType: 'wise', baseColor: '#A3E4D7', eyeColor: '#FFFFFF'),
        AICharacter(id: 'ai_4', name: 'Casey', gender: 'neutral', voiceType: 'gentle', baseColor: '#FFB7B2', eyeColor: '#FFFFFF'),
      ];
      notifyListeners();
    }
  }

  List<AICharacter> getFriends() => _friends;

  Future<void> addFriend(AICharacter friend) async {
    _friends.add(friend);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> deleteFriend(String id) async {
    _friends.removeWhere((f) => f.id == id);
    _conversationHistory.remove(id);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList = _friends.map((f) => f.toJson()).toList();
      await prefs.setString('ai_friends', jsonEncode(jsonList));
    } catch (e) {
      print('❌ Error saving: $e');
    }
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? saved = prefs.getString('ai_friends');
      if (saved != null && saved.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(saved);
        _friends = jsonList.map((j) => AICharacter.fromJson(j)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('❌ Error loading: $e');
    }
  }

  void _addToHistory(String characterId, String role, String content) {
    if (!_conversationHistory.containsKey(characterId)) {
      _conversationHistory[characterId] = [];
    }
    _conversationHistory[characterId]!.add({'role': role, 'content': content});
    if (_conversationHistory[characterId]!.length > 20) {
      _conversationHistory[characterId]!.removeAt(0);
    }
  }

  void clearHistory(String characterId) {
    _conversationHistory.remove(characterId);
    notifyListeners();
  }

  Future<String> getAIResponse(String userMessage, AICharacter character) async {
    print('🎯 getAIResponse: "$userMessage"');
    
    if (userMessage.trim().isEmpty) {
      return "Please say something...";
    }

    _isLoading = true;
    notifyListeners();

    _addToHistory(character.id, 'user', userMessage);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    final response = _generateSmartResponse(userMessage, character);
    
    _addToHistory(character.id, 'assistant', response);
    
    _isLoading = false;
    notifyListeners();
    
    return response;
  }

  String _generateSmartResponse(String message, AICharacter character) {
    final msg = message.toLowerCase().trim();
    final name = character.name;
    final history = _conversationHistory[character.id] ?? [];
    
    // Track conversation context safely
    bool talkedAboutStress = false;
    bool talkedAboutMath = false;
    bool talkedAboutChemistry = false;
    bool talkedAboutMarks = false;
    
    for (var h in history) {
      final content = h['content']?.toLowerCase() ?? '';
      if (content.contains('stress')) talkedAboutStress = true;
      if (content.contains('math') || content.contains('maths')) talkedAboutMath = true;
      if (content.contains('chemistry')) talkedAboutChemistry = true;
      if (content.contains('mark') || content.contains('grade')) talkedAboutMarks = true;
    }
    
    // Greetings
    if (msg == 'hi' || msg == 'hello' || msg == 'hey') {
      return "Hey there! I'm $name. How are you feeling today? 😊";
    }
    
    // How are you
    if (msg.contains('how are you')) {
      return "I'm doing great! Thanks for asking. What's on your mind today?";
    }
    
    // Stress + Marks
    if ((msg.contains('stress') || msg.contains('stressed')) && (msg.contains('mark') || msg.contains('grade') || msg.contains('exam'))) {
      if (talkedAboutMath) {
        return "I remember you mentioned maths before. Low marks don't define your ability. Want to try some practice problems together? 📐💗";
      }
      return "I hear you. Low grades can feel overwhelming, but they don't define you. What subject is bothering you the most? Let's work through it together. 🧘💗";
    }
    
    // Stress only
    if (msg.contains('stress') || msg.contains('stressed') || msg.contains('anxious') || msg.contains('worried')) {
      if (talkedAboutStress) {
        return "We've talked about stress before. Have you tried taking small breaks? Even 5 minutes of deep breathing can help. Want to try a quick breathing exercise? 🧘";
      }
      return "I'm sorry you're feeling stressed. Let's take a deep breath together. What's been overwhelming you lately? I'm here to listen and support you. 💗";
    }
    
    // Maths
    if (msg.contains('math') || msg.contains('trigonometry') || msg.contains('algebra') || msg.contains('calculus') || msg.contains('maths')) {
      if (msg.contains('trigonometry')) {
        return "Trigonometry can be tricky with sin, cos, and tan! The key is SOH CAH TOA. Want to go through some examples together? I can help you remember the formulas! 📐📚";
      }
      if (talkedAboutMath) {
        return "Let's keep working on maths! What specific concept is confusing you? Maybe I can explain it differently. YouTube tutorials and practice problems can also help a lot! 💪";
      }
      return "Maths can be challenging, but you can do this! What topic are you working on? Let's break it down step by step. Remember, practice makes progress, not perfection! 📐💪";
    }
    
    // Chemistry
    if (msg.contains('chemistry') || msg.contains('chemical') || msg.contains('periodic')) {
      if (talkedAboutChemistry) {
        return "Chemistry has a lot to memorize! The periodic table gets easier with practice. What specific topic is challenging you? I can help explain it! 🧪📚";
      }
      return "Chemistry can be interesting once you understand the basics! Are you struggling with the periodic table, chemical equations, or something else? Let's work on it together! 🧪💗";
    }
    
    // Name / Who are you
    if (msg.contains('your name') || msg.contains('who are you')) {
      return "I'm $name, your AI friend! I'm here to support you, listen to you, and chat about anything you want. What would you like to talk about today? 💗";
    }
    
    // Thank you
    if (msg.contains('thank')) {
      return "You're very welcome! I'm always here for you. What else is on your mind? 💗";
    }
    
    // Bye
    if (msg.contains('bye') || msg.contains('goodbye')) {
      return "Take care! Come back anytime you want to chat. I'll be here for you. Remember, you're not alone. 👋💗";
    }
    
    // Help
    if (msg.contains('help')) {
      return "Of course! I can help you with stress management, study tips, friendship advice, or just be someone to talk to. What would you like help with today? 😊";
    }
    
    // Default responses
    final defaultResponses = [
      "I'm really listening. Can you tell me more about that? I want to understand and help you through this. 💗",
      "That's interesting. How does that make you feel? I'm here to support you.",
      "Thanks for sharing that with me. What else is on your mind?",
      "I hear you. Would you like to talk more about this? I'm here for you.",
      "Tell me more about that. I'm really interested in what you have to say.",
    ];
    return defaultResponses[DateTime.now().millisecond % defaultResponses.length];
  }

  List<Map<String, String>> getConversationHistory(String characterId) {
    return _conversationHistory[characterId] ?? [];
  }
}