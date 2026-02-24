// lib/services/audio_service.dart
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class AudioService {
  late AudioPlayer _backgroundPlayer;
  bool _isInitialized = false;

  AudioService() {
    _initAudio();
  }

  void _initAudio() async {
    try {
      _backgroundPlayer = AudioPlayer();
      _isInitialized = true;
      print('✅ AudioService initialized');
    } catch (e) {
      print('❌ AudioService init error: $e');
    }
  }

  Future<void> playBackgroundSound({
    required String name,
    String? assetPath,
    String? networkUrl,
  }) async {
    if (!_isInitialized) {
      print('⚠️ AudioService not initialized yet');
      return;
    }
    
    try {
      print('🎵 Playing background: $name');
      
      await _backgroundPlayer.stop();
      await _backgroundPlayer.setVolume(0.3);
      await _backgroundPlayer.setLoopMode(LoopMode.all);
      
      if (networkUrl != null && networkUrl.isNotEmpty) {
        print('🌐 Loading URL: $networkUrl');
        await _backgroundPlayer.setUrl(networkUrl);
      } else if (assetPath != null && assetPath.isNotEmpty) {
        print('📁 Loading asset: $assetPath');
        await _backgroundPlayer.setAsset(assetPath);
      } else {
        print('⚠️ No audio source provided');
        return;
      }
      
      await _backgroundPlayer.play();
      print('✅ Background audio started');
      
    } catch (e) {
      print('❌ Background audio error: $e');
      // Don't rethrow - allow silent fallback
    }
  }

  Future<void> pause() async {
    if (!_isInitialized) return;
    try {
      await _backgroundPlayer.pause();
      print('⏸️ Audio paused');
    } catch (e) {
      print('Pause error: $e');
    }
  }

  Future<void> resume() async {
    if (!_isInitialized) return;
    try {
      await _backgroundPlayer.play();
      print('▶️ Audio resumed');
    } catch (e) {
      print('Resume error: $e');
    }
  }

  Future<void> stop() async {
    if (!_isInitialized) return;
    try {
      await _backgroundPlayer.stop();
      print('⏹️ Audio stopped');
    } catch (e) {
      print('Stop error: $e');
    }
  }

  // Safe dispose for web
  void dispose() {
    print('🗑️ Disposing AudioService');
    if (_isInitialized) {
      try {
        // For web, just stop, don't dispose (bug workaround)
        _backgroundPlayer.stop();
        // _backgroundPlayer.dispose(); // Comment out for web
      } catch (e) {
        print('Dispose error (ignored): $e');
      }
      _isInitialized = false;
    }
  }
}