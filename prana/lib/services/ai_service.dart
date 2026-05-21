// lib/services/ai_service.dart
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_character_model.dart';
import '../constants/api_keys.dart';

class AIService extends ChangeNotifier {
  List<AICharacter> _friends = [];
  
  // OpenAI API configuration
  static const String _openAIUrl = 'https://api.openai.com/v1/chat/completions';
  
  // Gemini API configuration
  static const String _geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  
  // Rate limiting for both APIs
  static const int _maxRequestsPerMinute = 20;
  final List<DateTime> _requestTimestamps = [];
  
  // Track conversation history for context (last 6 messages)
  final Map<String, List<Map<String, String>>> _conversationHistory = {};

  AIService() {
    _initializeDefaultFriends();
  }

  void _initializeDefaultFriends() {
    _friends = [
      AICharacter(
        id: 'ai_1',
        name: 'Alex',
        gender: 'male',
        voiceType: 'calm',
        baseColor: '#7C9AFF',
        eyeColor: '#FFFFFF',
      ),
      AICharacter(
        id: 'ai_2',
        name: 'Jordan',
        gender: 'male',
        voiceType: 'energetic',
        baseColor: '#FF69B4',
        eyeColor: '#FFFFFF',
      ),
      AICharacter(
        id: 'ai_3',
        name: 'Taylor',
        gender: 'female',
        voiceType: 'wise',
        baseColor: '#A3E4D7',
        eyeColor: '#FFFFFF',
      ),
      AICharacter(
        id: 'ai_4',
        name: 'Casey',
        gender: 'female',
        voiceType: 'gentle',
        baseColor: '#FFB7B2',
        eyeColor: '#FFFFFF',
      ),
    ];
  }

  // Check if we can make a request (rate limiting)
  bool _canMakeRequest() {
    final oneMinuteAgo = DateTime.now().subtract(const Duration(minutes: 1));
    _requestTimestamps.removeWhere((time) => time.isBefore(oneMinuteAgo));
    return _requestTimestamps.length < _maxRequestsPerMinute;
  }

  // Get all AI friends
  List<AICharacter> getFriends() => _friends;

  // Get AI friend by ID
  AICharacter? getFriend(String id) {
    try {
      return _friends.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new AI friend
  Future<void> addFriend(AICharacter friend) async {
    _friends.add(friend);
    await _saveToPrefs();
    notifyListeners();
  }

  // Update AI friend
  Future<void> updateFriend(AICharacter updatedFriend) async {
    final index = _friends.indexWhere((f) => f.id == updatedFriend.id);
    if (index != -1) {
      _friends[index] = updatedFriend;
      await _saveToPrefs();
      notifyListeners();
    }
  }

  // Delete AI friend
  Future<void> deleteFriend(String id) async {
    _friends.removeWhere((f) => f.id == id);
    _conversationHistory.remove(id);
    await _saveToPrefs();
    notifyListeners();
  }

  // Save to SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = 
        _friends.map((f) => f.toJson()).toList();
    await prefs.setString('ai_friends', jsonEncode(jsonList));
  }

  // Load from SharedPreferences
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString('ai_friends');
    
    if (saved != null && saved.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(saved);
        _friends = jsonList.map((j) => AICharacter.fromJson(j)).toList();
      } catch (e) {
        print('Error loading saved friends: $e');
      }
    }
    notifyListeners();
  }

  // Add message to conversation history
  void _addToHistory(String characterId, String role, String content) {
    if (!_conversationHistory.containsKey(characterId)) {
      _conversationHistory[characterId] = [];
    }
    
    _conversationHistory[characterId]!.add({
      'role': role,
      'content': content,
    });
    
    // Keep only last 6 messages for context
    if (_conversationHistory[characterId]!.length > 6) {
      _conversationHistory[characterId]!.removeAt(0);
    }
  }

  // Clear conversation history for a character
  void clearHistory(String characterId) {
    _conversationHistory.remove(characterId);
  }

  // ============ MAIN AI RESPONSE METHOD (AUTOMATICALLY CHOOSES API) ============
  Future<String> getAIResponse(String userMessage, AICharacter character) async {
    // Check rate limiting
    if (!_canMakeRequest()) {
      return _getRateLimitResponse(userMessage, character);
    }

    // Add timestamp for rate limiting
    _requestTimestamps.add(DateTime.now());
    
    // Add user message to history
    _addToHistory(character.id, 'user', userMessage);

    // Try Gemini first if flag is set (for testing without billing)
    if (ApiKeys.useGeminiForTesting && ApiKeys.gemini.isNotEmpty) {
      print('🤖 Attempting Gemini API first...');
      try {
        final response = await _getGeminiResponse(userMessage, character);
        if (!response.contains('API key') && !response.contains('Error')) {
          _addToHistory(character.id, 'assistant', response);
          return response;
        }
      } catch (e) {
        print('❌ Gemini failed: $e');
      }
    }

    // Try OpenAI if Gemini fails or flag is false
    if (ApiKeys.openAI.isNotEmpty && !ApiKeys.openAI.startsWith('sk-proj-')) {
      print('🤖 Attempting OpenAI API...');
      try {
        final response = await _getOpenAIResponse(userMessage, character);
        if (!response.contains('API key')) {
          _addToHistory(character.id, 'assistant', response);
          return response;
        }
      } catch (e) {
        print('❌ OpenAI failed: $e');
      }
    }

    // Fallback to enhanced mock responses
    print('📝 Using enhanced mock responses');
    final mockResponse = _getEnhancedMockResponse(userMessage, character);
    _addToHistory(character.id, 'assistant', mockResponse);
    return mockResponse;
  }

  // ============ GEMINI API IMPLEMENTATION ============
  Future<String> _getGeminiResponse(String userMessage, AICharacter character) async {
    try {
      final prompt = _getGeminiPrompt(character, userMessage);
      
      final response = await http.post(
        Uri.parse('$_geminiUrl?key=${ApiKeys.gemini}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'maxOutputTokens': 100,
            'temperature': 0.7,
            'topP': 0.95,
            'topK': 40,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            }
          ]
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Gemini timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'].trim();
        }
      } else {
        print('❌ Gemini Error: ${response.body}');
      }
      return _getFallbackResponse(userMessage, character);
    } catch (e) {
      print('❌ Gemini Exception: $e');
      return _getFallbackResponse(userMessage, character);
    }
  }

  String _getGeminiPrompt(AICharacter character, String userMessage) {
    String personality = '';
    switch (character.voiceType) {
      case 'calm':
        personality = 'You are Alex, a calm and supportive friend. Speak gently and empathetically. Keep responses under 2 sentences.';
        break;
      case 'energetic':
        personality = 'You are Jordan, an energetic and motivating friend. Be upbeat and encouraging. Use emojis occasionally. Keep responses under 2 sentences.';
        break;
      case 'wise':
        personality = 'You are Taylor, a wise and thoughtful friend. Give reflective advice. Keep responses under 2 sentences.';
        break;
      case 'gentle':
        personality = 'You are Casey, a gentle and caring friend. Be warm and nurturing. Keep responses under 2 sentences.';
        break;
      default:
        personality = 'You are a friendly AI companion. Keep responses under 2 sentences.';
    }

    // Add conversation history context
    String history = '';
    final recentHistory = _conversationHistory[character.id] ?? [];
    if (recentHistory.isNotEmpty) {
      history = '\nRecent conversation:\n';
      for (var msg in recentHistory.take(4)) {
        history += '${msg['role']}: ${msg['content']}\n';
      }
    }

    return '''
$personality
$history
Current user message: $userMessage
Respond naturally as ${character.name}:''';
  }

  // ============ OPENAI API IMPLEMENTATION ============
  Future<String> _getOpenAIResponse(String userMessage, AICharacter character) async {
    try {
      final systemPrompt = _getOpenAIPrompt(character);
      
      // Build messages array with history
      List<Map<String, String>> messages = [
        {'role': 'system', 'content': systemPrompt},
      ];
      
      // Add conversation history (last 4 exchanges to save tokens)
      final history = _conversationHistory[character.id] ?? [];
      final recentHistory = history.length > 4 ? history.sublist(history.length - 4) : history;
      for (var msg in recentHistory) {
        messages.add(msg);
      }
      
      final response = await http.post(
        Uri.parse(_openAIUrl),
        headers: {
          'Authorization': 'Bearer ${ApiKeys.openAI}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 100,
          'presence_penalty': 0.6,
          'frequency_penalty': 0.3,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('OpenAI timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('❌ OpenAI Error: ${response.body}');
        if (response.statusCode == 401) {
          return "🔑 API key is invalid.";
        } else if (response.statusCode == 429) {
          return "⏳ Rate limit reached.";
        }
        return _getFallbackResponse(userMessage, character);
      }
    } catch (e) {
      print('❌ OpenAI Exception: $e');
      return _getFallbackResponse(userMessage, character);
    }
  }

  String _getOpenAIPrompt(AICharacter character) {
    switch (character.id) {
      case 'ai_1':
        return 'You are Alex, a calm supportive friend. Be warm and understanding. Keep responses under 2 sentences.';
      case 'ai_2':
        return 'You are Jordan, an energetic motivating friend. Be upbeat and encouraging. Use emojis. Keep responses under 2 sentences.';
      case 'ai_3':
        return 'You are Taylor, a wise thoughtful friend. Give reflective advice. Keep responses under 2 sentences.';
      case 'ai_4':
        return 'You are Casey, a gentle caring friend. Be warm and nurturing. Keep responses under 2 sentences.';
      default:
        return 'You are a friendly AI companion. Keep responses short and natural.';
    }
  }

  // ============ ENHANCED MOCK RESPONSES (FALLBACK) ============
  String _getEnhancedMockResponse(String userMessage, AICharacter character) {
    final lowerMessage = userMessage.toLowerCase();
    
    // Greetings
    if (lowerMessage.contains('hello') || lowerMessage.contains('hi') || lowerMessage.contains('hey')) {
      return _getGreeting(character.voiceType);
    }
    
    // How are you
    if (lowerMessage.contains('how are you')) {
      return _getHowAreYou(character.voiceType);
    }
    
    // Thanks
    if (lowerMessage.contains('thank')) {
      return _getThankYou(character.voiceType);
    }
    
    // Goodbye
    if (lowerMessage.contains('bye') || lowerMessage.contains('goodbye')) {
      return _getGoodbye(character.voiceType);
    }
    
    // Help
    if (lowerMessage.contains('help')) {
      return _getHelpResponse(character.voiceType);
    }
    
    // Stress/Anxiety
    if (lowerMessage.contains('stress') || lowerMessage.contains('tension') || lowerMessage.contains('anxious')) {
      return _getStressResponse(character.voiceType);
    }
    
    // Sad/Upset
    if (lowerMessage.contains('sad') || lowerMessage.contains('upset') || lowerMessage.contains('depress')) {
      return _getSadResponse(character.voiceType);
    }
    
    // Happy/Good
    if (lowerMessage.contains('happy') || lowerMessage.contains('great') || lowerMessage.contains('good')) {
      return _getHappyResponse(character.voiceType);
    }
    
    // Study/School
    if (lowerMessage.contains('study') || lowerMessage.contains('exam') || lowerMessage.contains('school')) {
      return _getStudyResponse(character.voiceType);
    }
    
    // Friend/Relationship
    if (lowerMessage.contains('friend') || lowerMessage.contains('relationship')) {
      return _getFriendResponse(character.voiceType);
    }
    
    // Default personality-based responses
    return _getDefaultResponse(character.voiceType);
  }

  String _getGreeting(String voiceType) {
    switch(voiceType) {
      case 'energetic': return "Hey hey! So great to see you! 🎉 What's happening?";
      case 'wise': return "Ah, hello there. I was hoping you'd stop by.";
      case 'gentle': return "Hi, friend. I'm really glad you're here. 💗";
      default: return "Hello! How are you doing today?";
    }
  }

  String _getHowAreYou(String voiceType) {
    switch(voiceType) {
      case 'energetic': return "I'm absolutely fantastic! Thanks for asking! 🔥 How about you?";
      case 'wise': return "I'm quite well, thank you. More importantly, how are you?";
      case 'gentle': return "I'm doing well, thank you for asking. How's your heart today? 💗";
      default: return "I'm doing well, thanks! How are you?";
    }
  }

  String _getThankYou(String voiceType) {
    switch(voiceType) {
      case 'energetic': return "You're so welcome! That's what friends are for! 🎉";
      case 'wise': return "Gratitude is a beautiful thing. You're most welcome.";
      case 'gentle': return "Of course. I'm always here for you. 💗";
      default: return "You're welcome! Always happy to chat.";
    }
  }

  String _getGoodbye(String voiceType) {
    switch(voiceType) {
      case 'energetic': return "Can't wait to chat again! Take care! 🔥";
      case 'wise': return "Until next time. May your journey be meaningful.";
      case 'gentle': return "Goodbye for now. I'll be here when you need me. 🫂";
      default: return "Take care! Come back anytime.";
    }
  }

  String _getHelpResponse(String voiceType) {
    switch(voiceType) {
      case 'energetic': return "I'm here to help! What do you need? Let's figure this out together! 💪";
      case 'wise': return "Of course. What kind of support are you looking for today?";
      case 'gentle': return "I'm here for you. Tell me what's going on, and we'll work through it together. 🫂";
      default: return "I'm here to help. What's on your mind?";
    }
  }

  String _getStressResponse(String voiceType) {
    switch(voiceType) {
      case 'energetic': return "Take a deep breath! You've got this! Let's tackle this together! 💪";
      case 'wise': return "Stress is temporary. Let's break down what's overwhelming you.";
      case 'gentle': return "I'm sorry you're feeling stressed. Let's take a moment to breathe together. 🫂";
      default: return "That sounds stressful. Want to talk about what's bothering you?";
    }
  }

  String _getSadResponse(String voiceType) {
    switch(voiceType) {
      case 'energetic': return "Hey, it's okay to have down days. I'm here to lift you up! What's going on?";
      case 'wise': return "Sadness visits us all. It's a reminder that we care deeply about things.";
      case 'gentle': return "Oh, I'm here with you. You don't have to go through this alone. 💗";
      default: return "I'm sorry you're feeling sad. I'm here to listen.";
    }
  }

  String _getHappyResponse(String voiceType) {
    switch(voiceType) {
      case 'energetic': return "YES! That's amazing! Tell me everything! 🎉";
      case 'wise': return "Joy is a wonderful thing. What brought you this happiness?";
      case 'gentle': return "Your happiness makes me happy too! Share it with me! 💗";
      default: return "That's wonderful! Tell me more!";
    }
  }

  String _getStudyResponse(String voiceType) {
    switch(voiceType) {
      case 'energetic': return "You're going to crush those exams! What subject are we tackling? 📚";
      case 'wise': return "Learning is a journey. What's the most interesting thing you've discovered?";
      case 'gentle': return "Studies can be tough. Remember to take breaks and be kind to yourself. 📚";
      default: return "How's studying going? Need any help staying motivated?";
    }
  }

  String _getFriendResponse(String voiceType) {
    switch(voiceType) {
      case 'energetic': return "Friends! The best part of life! Tell me about your friends! 🎉";
      case 'wise': return "Friendship is a mirror to our souls. What have your friendships taught you?";
      case 'gentle': return "Friends are precious. I'm honored to be one of yours. 💗";
      default: return "Tell me more about your friends.";
    }
  }

  String _getDefaultResponse(String voiceType) {
    switch(voiceType) {
      case 'energetic': return "That's awesome! Tell me more! 🎉";
      case 'wise': return "That's interesting. What else is on your mind?";
      case 'gentle': return "I'm listening. Please continue. 💗";
      default: return "I see. Tell me more about that.";
    }
  }

  // Rate limit response
  String _getRateLimitResponse(String userMessage, AICharacter character) {
    switch(character.voiceType) {
      case 'energetic': return "Whoa! You're on fire! 🔥 Let's pause for 5 seconds and then keep going!";
      case 'wise': return "Sometimes patience is wisdom. Let's give the API a moment to breathe. 🌟";
      case 'gentle': return "We're chatting so fast! Let's slow down a tiny bit. I'm still here with you. 🫂";
      default: return "You're messaging quite fast! Let's wait a moment before continuing.";
    }
  }

  // Simple fallback for when everything fails
  String _getFallbackResponse(String message, AICharacter character) {
    return _getEnhancedMockResponse(message, character);
  }

  // Test all APIs
  Future<Map<String, bool>> testAPIs() async {
    final testCharacter = _friends.first;
    
    return {
      'gemini': await _testGemini(),
      'openai': await _testOpenAI(),
    };
  }

  Future<bool> _testGemini() async {
    if (ApiKeys.gemini.isEmpty) return false;
    try {
      final response = await _getGeminiResponse('Say "ok"', _friends.first);
      return !response.contains('API key') && !response.contains('Error');
    } catch (e) {
      return false;
    }
  }

  Future<bool> _testOpenAI() async {
    if (ApiKeys.openAI.isEmpty || ApiKeys.openAI.startsWith('sk-proj-')) return false;
    try {
      final response = await _getOpenAIResponse('Say "ok"', _friends.first);
      return !response.contains('API key') && !response.contains('Error');
    } catch (e) {
      return false;
    }
  }

  // Get conversation history
  List<Map<String, String>> getConversationHistory(String characterId) {
    return _conversationHistory[characterId] ?? [];
  }
}