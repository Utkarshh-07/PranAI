// lib/features/my_space/widgets/emoji_display.dart
import 'package:flutter/material.dart';

class EmojiDisplay extends StatelessWidget {
  final String emoji;
  final double size;
  final Color? color; // This won't affect emoji

  const EmojiDisplay({
    super.key,
    required this.emoji,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Use RichText with comprehensive font fallback for cross-platform support
    return RichText(
      text: TextSpan(
        text: emoji,
        style: TextStyle(
          fontSize: size,
          color: color ?? Colors.black, // This won't affect emoji colors
          fontFamilyFallback: const [
            // Windows
            'Segoe UI Emoji',
            'Segoe UI Symbol',
            // Android
            'Noto Color Emoji',
            'Noto Emoji',
            // iOS/macOS
            'Apple Color Emoji',
            // Linux
            'EmojiOne Color',
            'Twitter Color Emoji',
            'Facebook Color Emoji',
            // General fallbacks
            'JoyPixels',
            'EmojiSymbols',
            'Symbola',
            'Arial Unicode MS',
            // Last resort
            'Color Emoji',
          ],
        ),
      ),
    );
  }
}