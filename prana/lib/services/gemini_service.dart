// lib/services/gemini_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/ai_character_model.dart';
import '../constants/api_keys.dart';

class GeminiService extends ChangeNotifier {
  static const String _apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  
  // Track rate limiting
  final List<DateTime> _requestTimestamps = [];
  static const int _maxRequestsPerMinute = 60; // Gemini free tier limit

  bool _canMakeRequest() {
    final oneMinuteAgo = DateTime.now().subtract(const Duration(minutes: 1));
    _requestTimestamps.removeWhere((time) => time.isBefore(oneMinuteAgo));
    return _requestTimestamps.length < _maxRequestsPerMinute;
  }

  Future<String> getResponse(String userMessage, AICharacter character) async {
    // Check rate limiting
    if (!_canMakeRequest()) {
      return "⏳ Too many requests. Please wait a moment.";
    }

    try {
      print('📤 Sending to Gemini: $userMessage');
      
      // Create personality-specific prompt
      final String prompt = _getPersonalityPrompt(character, userMessage);
      
      final response = await http.post(
        Uri.parse('$_apiUrl?key=${ApiKeys.gemini}'),
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
      );

      // Add timestamp for rate limiting
      _requestTimestamps.add(DateTime.now());

      print('📥 Gemini Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Check if response has candidates
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final aiResponse = data['candidates'][0]['content']['parts'][0]['text'];
          print('✅ Gemini Response: $aiResponse');
          return aiResponse;
        } else {
          return _getFallbackResponse(userMessage, character);
        }
      } else {
        print('❌ Gemini Error: ${response.body}');
        return _getFallbackResponse(userMessage, character);
      }
    } catch (e) {
      print('❌ Exception in Gemini: $e');
      return _getFallbackResponse(userMessage, character);
    }
  }

  String _getPersonalityPrompt(AICharacter character, String userMessage) {
    String personality = '';
    switch (character.voiceType) {
      case 'calm':
        personality = 'You are a calm, supportive friend. Speak gently and empathetically.';
        break;
      case 'energetic':
        personality = 'You are an energetic, motivating friend. Be upbeat and encouraging. Use emojis occasionally.';
        break;
      case 'wise':
        personality = 'You are a wise, thoughtful friend. Give reflective advice and ask insightful questions.';
        break;
      case 'gentle':
        personality = 'You are a gentle, caring friend. Be warm and nurturing in your responses.';
        break;
      default:
        personality = 'You are a friendly AI companion.';
    }

    return '''
$personality
Keep your response under 2 sentences. Be natural and conversational.
The user's name is not specified, so just address them naturally.

User message: $userMessage
AI response:''';
  }

  String _getFallbackResponse(String message, AICharacter character) {
    final lowerMessage = message.toLowerCase();
    
    // Simple fallback responses
    if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return "Hey there! 👋 How's it going?";
    }
    if (lowerMessage.contains('how are you')) {
      return "I'm doing great! Thanks for asking. How about you?";
    }
    if (lowerMessage.contains('thank')) {
      return "You're welcome! 😊";
    }
    if (lowerMessage.contains('bye')) {
      return "Take care! Come back soon! 👋";
    }
    
    // Personality-based generic responses
    switch (character.voiceType) {
      case 'energetic':
        return "That's awesome! Tell me more! 🎉";
      case 'wise':
        return "That's an interesting perspective. What else is on your mind?";
      case 'gentle':
        return "I'm here listening. Please continue. 💗";
      default:
        return "I see. Tell me more about that.";
    }
  }

  // Test Gemini connection
  Future<bool> testConnection() async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl?key=${ApiKeys.gemini}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': 'Say "connected" if you can read this'}
              ]
            }
          ],
          'generationConfig': {
            'maxOutputTokens': 10,
          }
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}