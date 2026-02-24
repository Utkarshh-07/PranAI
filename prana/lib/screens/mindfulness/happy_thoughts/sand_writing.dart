// lib/screens/mindfulness/happy_thoughts/sand_writing.dart

import 'dart:math';

import 'package:flutter/material.dart';

class SandWritingScreen extends StatefulWidget {
  const SandWritingScreen({super.key});

  @override
  _SandWritingScreenState createState() => _SandWritingScreenState();
}

class _SandWritingScreenState extends State<SandWritingScreen> {
  List<Offset> _points = [];
  final TextEditingController _textController = TextEditingController();
  bool _isTextMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4E4C1), // Sand color
      body: Stack(
        children: [
          // Beach background with waves
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFF8E7),
                    Color(0xFFF4E4C1),
                    Color(0xFFE8D8A0),
                  ],
                ),
              ),
            ),
          ),

          // Ocean at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF219EBC).withOpacity(0.3),
                    Color(0xFF0A2463),
                  ],
                ),
              ),
            ),
          ),

          // Interactive sand canvas
          GestureDetector(
            onPanUpdate: _isTextMode ? null : (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                _points = List.from(_points)
                  ..add(renderBox.globalToLocal(details.globalPosition));
              });
            },
            onPanEnd: _isTextMode ? null : (details) => _points.add(Offset.zero),
            child: CustomPaint(
              painter: SandPainter(points: _points),
              size: Size.infinite,
            ),
          ),

          // Text input overlay
          if (_isTextMode) _buildTextInput(),

          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.brown),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    'Write in Sand',
                    style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(_isTextMode ? Icons.draw : Icons.text_fields, 
                             color: Colors.brown),
                      onPressed: () => setState(() => _isTextMode = !_isTextMode),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.brown),
                      onPressed: _clearSand,
                    ),
                    IconButton(
                      icon: Icon(Icons.save, color: Colors.brown),
                      onPressed: _saveWriting,
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

  Widget _buildTextInput() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Container(
            width: 300,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Write your message',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _textController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Type here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => _isTextMode = false),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _addTextToSand,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text('Write in Sand'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addTextToSand() {
    // Convert text to drawing points
    setState(() {
      // Simple text-to-points conversion (simplified)
      // In real app, use more sophisticated text rendering
      _points.addAll(_generateTextPoints(_textController.text));
      _textController.clear();
      _isTextMode = false;
    });
  }

  List<Offset> _generateTextPoints(String text) {
    // Simplified: Create wave-like pattern for text
    List<Offset> points = [];
    for (int i = 0; i < text.length * 10; i++) {
      double x = i * 2.0;
      double y = sin(i * 0.3) * 20;
      points.add(Offset(x, y + 100));
    }
    return points;
  }

  void _clearSand() {
    setState(() => _points.clear());
  }

  void _saveWriting() {
    // Save the sand writing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save Sand Writing'),
        content: Text('This message will wash away in 24 hours. Save to journal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Let it wash away'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save to journal
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Save to Journal'),
          ),
        ],
      ),
    );
  }
}

class SandPainter extends CustomPainter {
  final List<Offset> points;

  SandPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}