// lib/services/ai_voice_service.dart
import 'package:flutter_tts/flutter_tts.dart';

class AIVoiceService {
  static final FlutterTts _tts = FlutterTts();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _tts.setLanguage("en-US");
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    
    _isInitialized = true;
  }

  static Future<void> speak({
    required String text,
    required String gender,
    required String voiceType,
    double speed = 0.6,
  }) async {
    await initialize();
    await _tts.stop();

    // Set pitch based on gender
    if (gender.toLowerCase() == 'female') {
      await _tts.setPitch(1.2);
    } else if (gender.toLowerCase() == 'male') {
      await _tts.setPitch(1.0);
    } else {
      await _tts.setPitch(1.1);
    }

    // Set speed based on voice type
    double speechRate = speed;
    if (voiceType == 'calm') {
      speechRate = 0.5;
    } else if (voiceType == 'energetic') {
      speechRate = 0.8;
    } else if (voiceType == 'wise') {
      speechRate = 0.4;
    } else if (voiceType == 'gentle') {
      speechRate = 0.45;
    }

    await _tts.setSpeechRate(speechRate);
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }

  static Future<List<String>> getVoices() async {
    return await _tts.getVoices;
  }
}