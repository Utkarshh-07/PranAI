import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class OceanVoicePlayer extends StatefulWidget {
  final String text;
  final Color themeColor;
  
  const OceanVoicePlayer({
    Key? key,
    required this.text,
    this.themeColor = Colors.blue,
  }) : super(key: key);
  
  @override
  _OceanVoicePlayerState createState() => _OceanVoicePlayerState();
}

class _OceanVoicePlayerState extends State<OceanVoicePlayer> {
  final FlutterTts _tts = FlutterTts();
  bool _isPlaying = false;
  bool _isAvailable = true;
  
  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }
  
  Future<void> _initializeTTS() async {
    try {
      // Configure TTS
      await _tts.setLanguage("en-US");
      await _tts.setPitch(0.9); // Slightly lower for calming voice
      await _tts.setSpeechRate(0.4); // Slower for meditation-like reading
      await _tts.setVolume(1.0);
      
      // Set completion handler
      _tts.setCompletionHandler(() {
        setState(() {
          _isPlaying = false;
        });
      });
    } catch (e) {
      print('TTS initialization failed: $e');
      setState(() {
        _isAvailable = false;
      });
    }
  }
  
  Future<void> _playText() async {
    if (!_isAvailable) return;
    
    setState(() {
      _isPlaying = true;
    });
    
    await _tts.speak(widget.text);
  }
  
  Future<void> _stopText() async {
    await _tts.stop();
    setState(() {
      _isPlaying = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_isAvailable) {
      return Container(); // Hide if TTS not available
    }
    
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: widget.themeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Voice status
          Row(
            children: [
              Icon(
                Icons.volume_up,
                color: widget.themeColor,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'Ocean\'s Voice',
                style: TextStyle(
                  color: widget.themeColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          // Play/Pause button
          GestureDetector(
            onTap: () {
              if (_isPlaying) {
                _stopText();
              } else {
                _playText();
              }
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: widget.themeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.themeColor.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}