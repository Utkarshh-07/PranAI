import 'package:flutter/material.dart';

class BeachTransformation {
  static List<Color> getBeachColorsForTime() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 10) {
      // Morning colors
      return [
        Color(0xFFFFD166), // Light yellow
        Color(0xFF06D6A0), // Mint green
        Color(0xFF118AB2), // Ocean blue
      ];
    } else if (hour >= 10 && hour < 16) {
      // Day colors
      return [
        Color(0xFFFFFCF2), // Cream
        Color(0xFFCCC5B9), // Sand
        Color(0xFF403D39), // Dark sand
        Color(0xFF252422), // Darker sand
      ];
    } else if (hour >= 16 && hour < 19) {
      // Evening colors
      return [
        Color(0xFFFF9B85), // Coral
        Color(0xFFFF7F51), // Orange
        Color(0xFFCE4257), // Red
        Color(0xFF720026), // Deep red
      ];
    } else {
      // Night colors
      return [
        Color(0xFF001219), // Dark blue
        Color(0xFF005F73), // Deep teal
        Color(0xFF0A9396), // Teal
        Color(0xFF94D2BD), // Light teal
      ];
    }
  }
  
  static String getBeachMessageForTime() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 10) {
      return "Good morning! The beach is calm and peaceful.";
    } else if (hour >= 10 && hour < 16) {
      return "A beautiful day at the beach!";
    } else if (hour >= 16 && hour < 19) {
      return "Evening tide brings new treasures.";
    } else {
      return "The moonlit beach holds secrets.";
    }
  }
  
  static Widget createWaveAnimation(Size size) {
    return CustomPaint(
      size: size,
      painter: _WavePainter(),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    
    // Create wave pattern
    for (double i = 0; i < size.width; i += 20) {
      path.quadraticBezierTo(
        i + 10,
        size.height * 0.65,
        i + 20,
        size.height * 0.7,
      );
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}