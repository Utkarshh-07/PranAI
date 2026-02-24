// lib/features/my_space/widgets/dreamy_background.dart (HIGH VISIBILITY)
import 'package:flutter/material.dart';

class DreamyBackground extends StatelessWidget {
  final Widget child;
  
  const DreamyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Stack(
      children: [
        // Highly visible gradient
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Color(0xFFFFE5B4), // Peach
                Color(0xFFE6D8FF), // Light purple
                Color(0xFFB8E2FF), // Light blue
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        
        // Big colorful bubbles
        for (int i = 0; i < 8; i++)
          Positioned(
            left: size.width * (0.1 + (i * 0.1) % 0.8),
            top: size.height * (0.1 + (i * 0.1) % 0.8),
            child: Opacity(
              opacity: 0.2,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: [
                    Colors.purple.shade100,
                    Colors.blue.shade100,
                    Colors.pink.shade100,
                    Colors.orange.shade100,
                  ][i % 4],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        
        // Sparkles
        for (int i = 0; i < 20; i++)
          Positioned(
            left: size.width * (0.05 + (i * 0.045) % 0.95),
            top: size.height * (0.05 + (i * 0.045) % 0.95),
            child: Opacity(
              opacity: 0.5,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        
        child,
      ],
    );
  }
}