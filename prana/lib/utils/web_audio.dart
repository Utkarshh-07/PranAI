// lib/utils/web_audio.dart
import 'dart:html' as html;

class WebAudio {
  static html.AudioElement? _backgroundAudio;
  static html.AudioElement? _effectAudio;
  
  static void playBackground(String url) {
    try {
      // Stop previous background audio
      if (_backgroundAudio != null) {
        _backgroundAudio?.pause();
        _backgroundAudio = null;
      }
      
      // Create new audio element
      _backgroundAudio = html.AudioElement(url)
        ..loop = true
        ..volume = 0.3
        ..autoplay = true;
      
      print('🎵 Background audio started: $url');
    } catch (e) {
      print('❌ Background audio error: $e');
    }
  }
  
  static void playEffect(String url) {
    try {
      // Create new audio element for effect (don't loop)
      final effect = html.AudioElement(url)
        ..volume = 0.8
        ..autoplay = true;
      
      print('🔔 Effect audio played: $url');
      
      // Auto-remove after playback
      effect.onEnded.listen((_) {
        effect.remove();
      });
    } catch (e) {
      print('❌ Effect audio error: $e');
    }
  }
  
  static void stopBackground() {
    if (_backgroundAudio != null) {
      _backgroundAudio?.pause();
      _backgroundAudio = null;
      print('⏹️ Background audio stopped');
    }
  }
  
  static void pauseBackground() {
    if (_backgroundAudio != null) {
      _backgroundAudio?.pause();
      print('⏸️ Background audio paused');
    }
  }
  
  static void resumeBackground() {
    if (_backgroundAudio != null) {
      _backgroundAudio?.play();
      print('▶️ Background audio resumed');
    }
  }
}