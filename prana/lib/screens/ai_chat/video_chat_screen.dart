import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class _VoiceManager {
  static final FlutterTts _tts = FlutterTts();
  
  static Future<void> initialize() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.8); // FAST SPEED
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }
  
  static Future<void> speak(String text, String voiceGender) async {
    try {
      await _tts.stop(); // Stop any current speech
      
      // Set gender pitch
      if (voiceGender.toLowerCase() == 'female') {
        await _tts.setPitch(1.2);
      } else {
        await _tts.setPitch(1.0);
      }
      
      // FAST SPEED - 0.8 is normal conversation speed
      await _tts.setSpeechRate(0.8);
      
      // Speak
      await _tts.speak(text);
    } catch (e) {
      print("TTS Error: $e");
    }
  }
  
  static Future<void> stop() async {
    await _tts.stop();
  }
}

class VideoChatScreen extends StatefulWidget {
  final Map<String, dynamic> character;
  final Map<String, dynamic>? parentData;

  const VideoChatScreen({
    super.key,
    required this.character,
    this.parentData,
  });

  @override
  State<VideoChatScreen> createState() => _VideoChatScreenState();
}

class _VideoChatScreenState extends State<VideoChatScreen> {
  late stt.SpeechToText speechToText;
  bool isListening = false;
  final TextEditingController _textController = TextEditingController();
  bool _isAIThinking = false;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  // Character properties
  Color get primaryColor => Color(widget.character['primaryColor'] ?? 0xFF4A6FA5);
  String get characterName => widget.character['name'] ?? 'AI Companion';
  String get characterImage => widget.character['imageAsset'] ?? '';
  String get voiceGender => widget.character['voiceGender'] ?? 'female';
  String get characterEmoji => widget.character['emoji'] ?? '👤';

  @override
  void initState() {
    super.initState();
    
    // Initialize voice with FAST speed
    _VoiceManager.initialize();
    
    // Initialize speech-to-text
    speechToText = stt.SpeechToText();
    _initializeSTT();
    
    // Auto-hide controls
    _startHideControlsTimer();
    
    // Welcome message with FAST voice
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _VoiceManager.stop();
    super.dispose();
  }

  Future<void> _initializeSTT() async {
    bool available = await speechToText.initialize();
    if (!available) {
      print("Speech to text not available");
    }
  }

  void _addWelcomeMessage() {
    // Speak immediately with FAST speed
    _VoiceManager.speak(
      "Hello! I'm $characterName. How can I help you today?",
      voiceGender,
    );
  }

  void _startHideControlsTimer() {
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    _startHideControlsTimer();
  }

  void _startListening() async {
    if (!isListening) {
      bool available = await speechToText.initialize();
      if (available) {
        setState(() => isListening = true);
        speechToText.listen(
          onResult: (result) {
            setState(() {
              _textController.text = result.recognizedWords;
            });
          },
        );
      }
    }
  }

  void _stopListening() {
    if (isListening) {
      speechToText.stop();
      setState(() => isListening = false);
    }
  }

  void _sendMessage() async {
    String message = _textController.text.trim();
    if (message.isEmpty) return;
    
    setState(() {
      _isAIThinking = true;
      _showControls = true;
      _textController.clear();
    });
    
    _stopListening();
    
    // Simulate AI thinking
    await Future.delayed(const Duration(milliseconds: 800));
    
    String aiResponse = _getAIResponse(message);
    
    setState(() {
      _isAIThinking = false;
    });
    
    // Speak response with FAST speed
    _VoiceManager.speak(aiResponse, voiceGender);
  }

  String _getAIResponse(String message) {
    final responses = [
      "I understand. Tell me more about how you're feeling.",
      "Thank you for sharing that. How can I support you?",
      "I hear you. Let's talk more about this.",
      "That sounds important. Want to discuss it further?",
      "Thanks for opening up. I'm here to listen.",
    ];
    
    final randomIndex = DateTime.now().millisecondsSinceEpoch % responses.length;
    return responses[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // ============ MAIN CHARACTER PHOTO ============
            _buildCharacterBackground(),
            
            // ============ TOP CONTROLS ============
            if (_showControls)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.6),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              characterName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // ============ BOTTOM CONTROLS ============
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showControls ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Text Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Type or speak your message...',
                                  hintStyle: TextStyle(color: Colors.white60),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                ),
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send, color: primaryColor),
                              onPressed: _sendMessage,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Control Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Voice Button
                          _buildControlButton(
                            icon: isListening ? Icons.mic_off : Icons.mic,
                            label: 'Voice',
                            color: isListening ? Colors.red : primaryColor,
                            onTap: () {
                              if (isListening) {
                                _stopListening();
                              } else {
                                _startListening();
                              }
                            },
                          ),
                          
                          // End Call Button
                          _buildControlButton(
                            icon: Icons.call_end,
                            label: 'End',
                            color: Colors.red,
                            onTap: () => Navigator.pop(context),
                            isLarge: true,
                          ),
                          
                          // Mood Button
                          _buildControlButton(
                            icon: Icons.emoji_emotions,
                            label: 'Mood',
                            color: Colors.blue,
                            onTap: () {
                              // Mood selector
                            },
                          ),
                        ],
                      ),
                      
                      // Voice Status
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              voiceGender == 'female' ? Icons.female : Icons.male,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${voiceGender == 'female' ? 'Female' : 'Male'} Voice • Normal Speed',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // ============ LISTENING INDICATOR ============
            if (isListening)
              Positioned(
                bottom: 200,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.mic, color: Colors.red, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Listening... Speak now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // ============ AI THINKING INDICATOR ============
            if (_isAIThinking)
              Positioned(
                bottom: 150,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'AI is thinking...',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // ============ TAP HINT ============
            if (!_showControls)
              Positioned(
                bottom: 150,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _toggleControls,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.touch_app,
                          color: Colors.white70,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tap to show controls',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterBackground() {
    try {
      // Try to load the character photo
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          characterImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Image load failed: $error");
            return _buildFallbackBackground();
          },
        ),
      );
    } catch (e) {
      print("Image asset error: $e");
      return _buildFallbackBackground();
    }
  }

  Widget _buildFallbackBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.8),
            const Color(0xFF0A2463),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Center(
                child: Text(
                  characterEmoji,
                  style: const TextStyle(fontSize: 60),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              characterName,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isLarge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: isLarge ? 70 : 60,
            height: isLarge ? 70 : 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: isLarge ? 32 : 28,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}