// FILE: lib/services/voice_manager.dart
import 'package:flutter_tts/flutter_tts.dart';

class VoiceManager {
  static final FlutterTts _tts = FlutterTts();
  
  // Voice settings for different genders
  static final Map<String, Map<String, dynamic>> _voiceSettings = {
    'female': {
      'language': 'en-IN', // Indian English
      'pitch': 1.3, // Higher pitch for female
      'speechRate': 0.6, // Normal speed
      'volume': 1.0,
    },
    'male': {
      'language': 'en-IN',
      'pitch': 1.0, // Normal pitch for male
      'speechRate': 0.6,
      'volume': 1.0,
    },
  };

  static Future<void> initialize() async {
    await _tts.setLanguage("en-IN");
    await _tts.setSpeechRate(0.6);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  static Future<void> speak(String text, String voiceGender) async {
    try {
      // Set voice based on gender
      final settings = _voiceSettings[voiceGender] ?? _voiceSettings['female']!;
      
      await _tts.setLanguage(settings['language'] as String);
      await _tts.setPitch(settings['pitch'] as double);
      await _tts.setSpeechRate(settings['speechRate'] as double);
      await _tts.setVolume(settings['volume'] as double);
      
      // Speak the message
      await _tts.speak(text);
    } catch (e) {
      print("Error in TTS: $e");
    }
  }

  static Future<void> stop() async {
    await _tts.stop();
  }

  static Future<void> setVoiceSpeed(double speed) async {
    await _tts.setSpeechRate(speed);
  }

  static Future<void> setVoicePitch(double pitch) async {
    await _tts.setPitch(pitch);
  }
}