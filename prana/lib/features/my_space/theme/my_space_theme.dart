// lib/features/my_space/theme/my_space_theme.dart
import 'package:flutter/material.dart';

class MySpaceTheme {
  // Primary Colors
  static const Color primaryLavender = Color(0xFFB4A7F5);
  static const Color softMint = Color(0xFFA3E4D7);
  static const Color peach = Color(0xFFFFB7B2);
  static const Color softYellow = Color(0xFFFFE5A3);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color white = Color(0xFFFFFFFF);
  
  // Background Gradient Colors
  static const Color creamCenter = Color(0xFFFFF9F0);  // warm cream
  static const Color lavenderMiddle = Color(0xFFF5F0FF); // soft lavender
  static const Color skyEdge = Color(0xFFE8F0FE); // light sky blue
  
  // Text Colors
  static const Color darkText = Color(0xFF2D3E50);
  static const Color mediumText = Color(0xFF6B7A8F);
  static const Color lightText = Color(0xFF8A9BB0);
  
  // Accent Colors
  static const Color urgentRed = Color(0xFFD14545);
  static const Color blueDot = Color(0xFF4A90E2);
  
  // Radial Gradient Background - FIXED: Added this property
  static const RadialGradient mainBackground = RadialGradient(
    center: Alignment.center,
    radius: 1.2,
    colors: [
      Color(0xFFFFF9F0), // warm cream
      Color(0xFFF5F0FF), // soft lavender
      Color(0xFFE8F0FE), // light sky blue
    ],
    stops: [0.0, 0.6, 1.0],
  );
  
  // Card Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 12,
      color: Colors.black.withOpacity(0.05),
      spreadRadius: 0,
    ),
  ];
  
  // Card Decorations
  static BoxDecoration calendarCard = BoxDecoration(
    color: white.withOpacity(0.95),
    borderRadius: BorderRadius.circular(20),
    boxShadow: cardShadow,
  );
  
  static BoxDecoration highlightsCard = BoxDecoration(
    color: white.withOpacity(0.95),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: peach, width: 2),
    boxShadow: cardShadow,
  );
  
  static BoxDecoration weekVibeCard = BoxDecoration(
    color: white.withOpacity(0.95),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: softMint, width: 2),
    boxShadow: cardShadow,
  );
  
  static BoxDecoration quickAddCard = BoxDecoration(
    color: lightGray.withOpacity(0.95),
    borderRadius: BorderRadius.circular(20),
    boxShadow: cardShadow,
  );
  
  static BoxDecoration legendCard = BoxDecoration(
    color: white.withOpacity(0.95),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: primaryLavender.withOpacity(0.3), width: 1),
    boxShadow: cardShadow,
  );
  
  // Text Styles
  static const TextStyle headerTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: darkText,
  );
  
  static const TextStyle headerSubtitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    color: mediumText,
  );
  
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: darkText,
  );
  
  static const TextStyle eventTime = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: mediumText,
  );
  
  static const TextStyle eventTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: darkText,
  );
  
  static const TextStyle eventDetails = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    color: lightText,
  );
  
  static const TextStyle urgentTag = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: urgentRed,
  );
}