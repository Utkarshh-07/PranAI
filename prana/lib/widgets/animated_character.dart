// lib/widgets/animated_character.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prana/models/ai_character_model.dart';

class AnimatedCharacter extends StatefulWidget {
  final AICharacter character;
  final String expression;
  final bool isSpeaking;
  final bool isListening;
  final double size;

  const AnimatedCharacter({
    Key? key,
    required this.character,
    required this.expression,
    required this.isSpeaking,
    required this.isListening,
    this.size = 120,
  }) : super(key: key);

  @override
  State<AnimatedCharacter> createState() => _AnimatedCharacterState();
}

class _AnimatedCharacterState extends State<AnimatedCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _masterController;
  late Animation<double> _blinkAnimation;
  late Animation<double> _talkAnimation;
  late Animation<double> _breatheAnimation;
  
  Timer? _blinkTimer;
  bool _manualBlink = false;

  @override
  void initState() {
    super.initState();
    
    // Single controller for all animations
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    
    // Derive animations from master
    _breatheAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: Curves.easeInOut,
      ),
    );
    
    _talkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
    
    _blinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.8, 0.9, curve: Curves.easeInOut),
      ),
    );

    // Blink every 3 seconds
    _blinkTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _manualBlink = true;
        });
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() {
              _manualBlink = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _masterController.dispose();
    super.dispose();
  }

  Color _getBaseColor() {
    return widget.character.baseColorObj;
  }

  Color _getEyeColor() {
    return widget.character.eyeColorObj;
  }

  bool get _isBlinking => _manualBlink || _blinkAnimation.value > 0.5;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _masterController,
      builder: (context, child) {
        return Transform.scale(
          scale: _breatheAnimation.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _CharacterPainter(
              gender: widget.character.gender,
              baseColor: _getBaseColor(),
              eyeColor: _getEyeColor(),
              expression: widget.expression,
              isSpeaking: widget.isSpeaking,
              isListening: widget.isListening,
              isBlinking: _isBlinking,
              talkValue: _talkAnimation.value,
            ),
          ),
        );
      },
    );
  }
}

class _CharacterPainter extends CustomPainter {
  final String gender;
  final Color baseColor;
  final Color eyeColor;
  final String expression;
  final bool isSpeaking;
  final bool isListening;
  final bool isBlinking;
  final double talkValue;

  _CharacterPainter({
    required this.gender,
    required this.baseColor,
    required this.eyeColor,
    required this.expression,
    required this.isSpeaking,
    required this.isListening,
    required this.isBlinking,
    required this.talkValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;
    
    // Draw face circle
    final facePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, facePaint);
    
    // Draw face highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - radius * 0.2, center.dy - radius * 0.2), radius * 0.3, highlightPaint);
    
    // Eyes
    final eyeSpacing = radius * 0.5;
    final eyeY = center.dy - radius * 0.2;
    final eyeSize = radius * 0.15;
    
    if (!isBlinking) {
      // Left eye
      canvas.drawCircle(Offset(center.dx - eyeSpacing, eyeY), eyeSize, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx - eyeSpacing, eyeY), eyeSize * 0.5, Paint()..color = eyeColor);
      
      // Right eye
      canvas.drawCircle(Offset(center.dx + eyeSpacing, eyeY), eyeSize, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx + eyeSpacing, eyeY), eyeSize * 0.5, Paint()..color = eyeColor);
    } else {
      // Blinking - draw lines instead of circles
      final blinkPaint = Paint()..color = Colors.white;
      canvas.drawLine(
        Offset(center.dx - eyeSpacing - eyeSize, eyeY),
        Offset(center.dx - eyeSpacing + eyeSize, eyeY),
        blinkPaint..strokeWidth = eyeSize * 0.5,
      );
      canvas.drawLine(
        Offset(center.dx + eyeSpacing - eyeSize, eyeY),
        Offset(center.dx + eyeSpacing + eyeSize, eyeY),
        blinkPaint..strokeWidth = eyeSize * 0.5,
      );
    }
    
    // Mouth
    final mouthY = center.dy + radius * 0.3;
    final mouthPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    if (isSpeaking) {
      // Speaking mouth (open, sized by talkValue)
      final mouthHeight = radius * 0.25 * (0.5 + talkValue * 0.5);
      final mouthRect = Rect.fromCenter(
        center: Offset(center.dx, mouthY),
        width: radius * 0.4,
        height: mouthHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(mouthRect, const Radius.circular(10)),
        mouthPaint,
      );
    } else if (expression == 'happy') {
      // Happy mouth (smile)
      final path = Path();
      path.moveTo(center.dx - radius * 0.3, mouthY);
      path.quadraticBezierTo(center.dx, mouthY + radius * 0.25, center.dx + radius * 0.3, mouthY);
      canvas.drawPath(path, mouthPaint..style = PaintingStyle.stroke..strokeWidth = radius * 0.08);
    } else if (expression == 'concerned') {
      // Concerned mouth (frown)
      final path = Path();
      path.moveTo(center.dx - radius * 0.3, mouthY + radius * 0.1);
      path.quadraticBezierTo(center.dx, mouthY - radius * 0.05, center.dx + radius * 0.3, mouthY + radius * 0.1);
      canvas.drawPath(path, mouthPaint..style = PaintingStyle.stroke..strokeWidth = radius * 0.08);
    } else if (expression == 'thinking') {
      // Thinking mouth (pursed lips)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(center.dx, mouthY), width: radius * 0.25, height: radius * 0.08),
          const Radius.circular(5),
        ),
        mouthPaint,
      );
    } else {
      // Neutral mouth (straight line)
      canvas.drawLine(
        Offset(center.dx - radius * 0.3, mouthY),
        Offset(center.dx + radius * 0.3, mouthY),
        mouthPaint..strokeWidth = radius * 0.06,
      );
    }
    
    // Listening indicator (ears)
    if (isListening) {
      final earPaint = Paint()..color = baseColor.withOpacity(0.7);
      canvas.drawCircle(Offset(center.dx - radius * 0.7, center.dy), radius * 0.2, earPaint);
      canvas.drawCircle(Offset(center.dx + radius * 0.7, center.dy), radius * 0.2, earPaint);
      
      // Inner ears
      final innerEarPaint = Paint()..color = Colors.white.withOpacity(0.3);
      canvas.drawCircle(Offset(center.dx - radius * 0.7, center.dy), radius * 0.1, innerEarPaint);
      canvas.drawCircle(Offset(center.dx + radius * 0.7, center.dy), radius * 0.1, innerEarPaint);
    }
    
    // Gender-specific accessories
    if (gender == 'male') {
      // Simple hair/brow
      final browPaint = Paint()..color = Colors.brown;
      canvas.drawLine(
        Offset(center.dx - radius * 0.4, center.dy - radius * 0.4),
        Offset(center.dx + radius * 0.4, center.dy - radius * 0.4),
        browPaint..strokeWidth = radius * 0.06,
      );
    } else if (gender == 'female') {
      // Eyelashes
      final lashPaint = Paint()..color = Colors.brown;
      for (var i = -1; i <= 1; i++) {
        canvas.drawLine(
          Offset(center.dx + i * radius * 0.3, center.dy - radius * 0.25),
          Offset(center.dx + i * radius * 0.35, center.dy - radius * 0.35),
          lashPaint..strokeWidth = radius * 0.04,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CharacterPainter oldDelegate) {
    return oldDelegate.gender != gender ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.eyeColor != eyeColor ||
        oldDelegate.expression != expression ||
        oldDelegate.isSpeaking != isSpeaking ||
        oldDelegate.isListening != isListening ||
        oldDelegate.isBlinking != isBlinking;
  }
}