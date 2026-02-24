// lib/features/my_space/theme/card_styles.dart
import 'package:flutter/material.dart';
import 'dart:ui';

class CardStyles {
  // Frosted Glass Base
  static BoxDecoration frostedGlass({
    required Color tintColor,
    double opacity = 0.15,
    double blur = 10,
    double borderRadius = 24,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: tintColor.withOpacity(opacity),
      border: Border.all(
        color: Colors.white.withOpacity(0.15),
        width: 1,
      ),
    );
  }

  // Frosted Glass with BackdropFilter
  static Widget wrapWithFrostedGlass({
    required Widget child,
    required Color tintColor,
    double opacity = 0.15,
    double blur = 10,
    double borderRadius = 24,
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: tintColor.withOpacity(opacity),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }

  // Solid White Card (for event items)
  static BoxDecoration solidCard = BoxDecoration(
    color: Colors.white.withOpacity(0.95),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Event Card with colored left border
  static BoxDecoration eventCard(String category) {
    Color borderColor;
    switch (category) {
      case 'study':
        borderColor = const Color(0xFFB4A7F5);
        break;
      case 'exam':
        borderColor = const Color(0xFFFFB7B2);
        break;
      case 'fun':
        borderColor = const Color(0xFFA3E4D7);
        break;
      case 'urgent':
        borderColor = const Color(0xFFD14545);
        break;
      default:
        borderColor = Colors.grey;
    }
    
    return BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(16),
      border: Border(
        left: BorderSide(color: borderColor, width: 4),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Primary Button Style
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2D3E50), // Dark background
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    elevation: 2,
  );

  // Secondary Button Style (for quick add)
  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.white.withOpacity(0.9), // Light background
    foregroundColor: const Color(0xFF2D3E50), // Dark text
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    side: BorderSide(color: Colors.grey.withOpacity(0.3)),
    elevation: 0,
  );

  // Text Button Style
  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: const Color(0xFF2D3E50), // Dark text
  );
}