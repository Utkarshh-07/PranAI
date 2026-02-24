// lib/widgets/ocean/wave_animation.dart
import 'dart:math';

import 'package:flutter/material.dart';

class WaveAnimation extends StatefulWidget {
  final double amplitude;
  final Color waveColor;
  
  const WaveAnimation({
    super.key,
    this.amplitude = 10.0,
    this.waveColor = const Color(0xFF219EBC),
  });

  @override
  _WaveAnimationState createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WavePainter(
            animationValue: _controller.value,
            amplitude: widget.amplitude,
            waveColor: widget.waveColor,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final double amplitude;
  final Color waveColor;

  WavePainter({
    required this.animationValue,
    required this.amplitude,
    required this.waveColor,
  });
  
  get math => null;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = amplitude * 
                sin((x * 0.02) + (animationValue * 2 * pi)) + 
                size.height * 0.7;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  double sin(double x) => (math.sin(x) + 1) / 2;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}