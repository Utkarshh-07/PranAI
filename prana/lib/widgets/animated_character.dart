// lib/widgets/animated_character.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prana/models/ai_character_model.dart';

class AnimatedCharacter extends StatefulWidget {
  final String gender;
  final String baseColor;
  final String eyeColor;
  final String expression;
  final bool isSpeaking;
  final bool isListening;
  final double size;

  const AnimatedCharacter({
    Key? key,
    required this.gender,
    required this.baseColor,
    required this.eyeColor,
    required this.expression,
    required this.isSpeaking,
    required this.isListening,
    this.size = 300, required AICharacter character,
  }) : super(key: key);

  @override
  State<AnimatedCharacter> createState() => _AnimatedCharacterState();
}

class _AnimatedCharacterState extends State<AnimatedCharacter>
    with SingleTickerProviderStateMixin {
  // Use ONE master controller and derive animations from it
  late AnimationController _masterController;
  late Animation<double> _blinkAnimation;
  late Animation<double> _talkAnimation;
  late Animation<double> _breatheAnimation;
  
  Timer? _blinkTimer;

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

    // Blink every 3 seconds using timer (not animation controller)
    _blinkTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {}); // Just trigger rebuild
      }
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _masterController.dispose(); // Dispose the SINGLE controller
    super.dispose();
  }

  Color _getBaseColor() {
    return Color(int.parse(widget.baseColor.replaceFirst('#', '0xFF')));
  }

  Color _getEyeColor() {
    return Color(int.parse(widget.eyeColor.replaceFirst('#', '0xFF')));
  }

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
              gender: widget.gender,
              baseColor: _getBaseColor(),
              eyeColor: _getEyeColor(),
              expression: widget.expression,
              isSpeaking: widget.isSpeaking,
              isListening: widget.isListening,
              blinkValue: _blinkAnimation.value,
              talkValue: _talkAnimation.value,
            ),
          ),
        );
      },
    );
  }
}

extension on _AnimatedCharacterState {
  
   _CharacterPainter({required String gender, required Color baseColor, required Color eyeColor, required String expression, required bool isSpeaking, required bool isListening, required double blinkValue, required double talkValue}) {}
}

// Rest of _CharacterPainter class remains the same...