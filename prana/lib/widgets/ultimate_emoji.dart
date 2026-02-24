// lib/widgets/ultimate_emoji.dart
import 'package:flutter/material.dart';

class UltimateEmoji extends StatelessWidget {
  final String emoji;
  final double size;
  final Color? color;

  const UltimateEmoji({
    super.key,
    required this.emoji,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: TextStyle(
        fontSize: size,
        fontFamily: 'NotoColorEmoji',  // This matches the family name in pubspec.yaml
        color: color ?? Colors.black,
        height: 1.0,
      ),
    );
  }
}