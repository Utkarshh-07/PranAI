// lib/screens/ai_chat/ai_video_interface.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/ai_character_model.dart';
import '../../widgets/animated_character.dart';

class AIVideoInterface extends StatefulWidget {
  final AICharacter character;

  const AIVideoInterface({super.key, required this.character});

  @override
  State<AIVideoInterface> createState() => _AIVideoInterfaceState();
}

class _AIVideoInterfaceState extends State<AIVideoInterface> {
  bool _isMuted = false;
  bool _isCameraOn = true;
  bool _isSpeakerOn = true;
  String _callDuration = "00:00";
  String _currentExpression = 'neutral';
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startCallTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _seconds++;
        final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
        final secs = (_seconds % 60).toString().padLeft(2, '0');
        setState(() {
          _callDuration = "$minutes:$secs";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video Background (simulated with gradient)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.character.baseColorObj.withOpacity(0.7),
                  Colors.black,
                ],
              ),
            ),
          ),
          
          // Animated Character Overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Character animation
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.character.baseColorObj.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: AnimatedCharacter(
                    character: widget.character,
                    expression: _currentExpression,
                    isSpeaking: true,
                    isListening: false,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Character name
                Text(
                  widget.character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Call duration
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _callDuration,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Top controls
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                
                // Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                
                // Flip camera (placeholder)
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 28),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Camera flip coming soon!')),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Bottom controls
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Expression selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildExpressionButton('neutral', '😐'),
                      _buildExpressionButton('happy', '😊'),
                      _buildExpressionButton('concerned', '😟'),
                      _buildExpressionButton('thinking', '🤔'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Call controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: _isMuted ? Icons.mic_off : Icons.mic,
                      label: _isMuted ? 'Unmute' : 'Mute',
                      color: _isMuted ? Colors.red : Colors.white,
                      onTap: () {
                        setState(() {
                          _isMuted = !_isMuted;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(_isMuted ? 'Microphone muted' : 'Microphone unmuted')),
                        );
                      },
                    ),
                    
                    _buildControlButton(
                      icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                      label: _isCameraOn ? 'Stop Video' : 'Start Video',
                      color: _isCameraOn ? Colors.blue : Colors.red,
                      onTap: () {
                        setState(() {
                          _isCameraOn = !_isCameraOn;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(_isCameraOn ? 'Video on' : 'Video off')),
                        );
                      },
                    ),
                    
                    _buildControlButton(
                      icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                      label: _isSpeakerOn ? 'Mute Speaker' : 'Unmute Speaker',
                      color: _isSpeakerOn ? Colors.white : Colors.red,
                      onTap: () {
                        setState(() {
                          _isSpeakerOn = !_isSpeakerOn;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(_isSpeakerOn ? 'Speaker on' : 'Speaker muted')),
                        );
                      },
                    ),
                    
                    // End call button
                    _buildControlButton(
                      icon: Icons.call_end,
                      label: 'End',
                      color: Colors.red,
                      isEndCall: true,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpressionButton(String expression, String emoji) {
    final isSelected = _currentExpression == expression;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentExpression = expression;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? widget.character.baseColorObj
              : Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    bool isEndCall = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isEndCall 
                  ? Colors.red 
                  : Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: isEndCall ? Colors.white : color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isEndCall ? Colors.red : Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}