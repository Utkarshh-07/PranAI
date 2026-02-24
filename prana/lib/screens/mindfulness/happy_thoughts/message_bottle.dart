// lib/screens/mindfulness/happy_thoughts/message_bottle.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prana/screens/mindfulness/happy_thoughts/models/happy_thought.dart';

class MessageBottleScreen extends StatefulWidget {
  const MessageBottleScreen({super.key});

  @override
  _MessageBottleScreenState createState() => _MessageBottleScreenState();
}

class _MessageBottleScreenState extends State<MessageBottleScreen> {
  final TextEditingController _controller = TextEditingController();
  Color _selectedBottleColor = Color(0xFF4CC9F0);
  final List<Color> _bottleColors = [
    Color(0xFF4CC9F0), // Sky blue
    Color(0xFF06D6A0), // Sea teal
    Color(0xFFFFD166), // Golden
    Color(0xFFFF6B6B), // Coral
    Color(0xFF9D4EDD), // Purple
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2463),
      body: Stack(
        children: [
          // Ocean background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0A2463),
                    Color(0xFF1E3A8A),
                    Color(0xFF219EBC),
                  ],
                ),
              ),
            ),
          ),

          // Floating bottles in background
          _buildFloatingBottles(),

          SafeArea(
            child: Column(
              children: [
                // Header
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    'Message in a Bottle',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Bottle Selection
                        Text(
                          'Choose your bottle:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          children: _bottleColors.map((color) {
                            return GestureDetector(
                              onTap: () => setState(() => _selectedBottleColor = color),
                              child: Container(
                                width: 50,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _selectedBottleColor == color 
                                      ? Colors.white 
                                      : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.local_drink,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 30,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 30),

                        // Message Input
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: TextField(
                              controller: _controller,
                              maxLines: null,
                              style: TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                hintText: 'Write your message here...\n\nExamples:\n• Today\'s happy moment\n• Something you\'re grateful for\n• A hope for tomorrow\n• A beautiful memory',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Send Button
                        ElevatedButton(
                          onPressed: _sendMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedBottleColor,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.send, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Cast into Ocean',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottles() {
    return Stack(
      children: [
        // Animated floating bottles
        Positioned(
          left: 50,
          top: 100,
          child: _buildBottleAnimation(0),
        ),
        Positioned(
          right: 80,
          top: 200,
          child: _buildBottleAnimation(1),
        ),
        Positioned(
          left: 100,
          bottom: 150,
          child: _buildBottleAnimation(2),
        ),
      ],
    );
  }

  Widget _buildBottleAnimation(int delay) {
    return TweenAnimationBuilder(
      duration: Duration(seconds: 3),
      tween: Tween<double>(begin: 0, end: 20),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, sin(value + delay) * 10),
          child: Container(
            width: 40,
            height: 60,
            decoration: BoxDecoration(
              color: _bottleColors[delay].withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      // Save message
      final message = HappyThought(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ThoughtType.messageBottle,
        content: _controller.text,
        emotion: EmotionColor.skyBlue,
        timestamp: DateTime.now(),
        bottleColor: _selectedBottleColor.value.toRadixString(16),
      );

      // Show success animation
      _showSuccessAnimation();
      
      // Navigate back
      Navigator.pop(context, message);
    }
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                  duration: Duration(seconds: 2),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, -value * 100),
                      child: Opacity(
                        opacity: 1 - value,
                        child: Container(
                          width: 60,
                          height: 90,
                          decoration: BoxDecoration(
                            color: _selectedBottleColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.local_drink,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Message cast into ocean!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }
}