// lib/features/my_space/screens/rhythm_welcome_screen.dart (UPDATED)
import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/card_styles.dart';
import '../../../widgets/ultimate_emoji.dart';
import 'rhythm_input_screen.dart';

class RhythmWelcomeScreen extends StatelessWidget {
  final VoidCallback? onStart;

  const RhythmWelcomeScreen({super.key, this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Dreamy background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFFFFF9F0),
                  Color(0xFFF5F0FF),
                  Color(0xFFE8F0FE),
                ],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Robot character
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          colors: [Color(0xFFB4A7F5), Color(0xFF6C5CE7)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C5CE7).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '🤖',
                          style: TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Title with NEW badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '⏰ WELCOME TO ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3E50),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFB7B2), Color(0xFFFF8C42)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'SMART RHYTHM',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD93D).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '✨ NEW ✨',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF8C42),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Main card
                    CardStyles.wrapWithFrostedGlass(
                      tintColor: const Color(0xFFB4A7F5),
                      opacity: 0.2,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text(
                            '"Hi! I\'m your personal Rhythm Coach."',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3E50),
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          const Text(
                            'I\'ll help you create the perfect daily flow based on YOUR needs, not a fixed template.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2D3E50),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // How it works
                          _buildStep('1️⃣', 'Tell me about your day in your own words'),
                          const SizedBox(height: 12),
                          _buildStep('2️⃣', 'I\'ll understand and organize it'),
                          const SizedBox(height: 12),
                          _buildStep('3️⃣', 'I\'ll suggest optimizations'),
                          const SizedBox(height: 12),
                          _buildStep('4️⃣', 'You tweak until it\'s perfect'),
                          const SizedBox(height: 12),
                          _buildStep('5️⃣', 'We track your progress together!'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Start button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Use the provided callback or navigate directly
                          if (onStart != null) {
                            onStart!();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RhythmInputScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D3E50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '✨ LET\'S CREATE YOUR RHYTHM ✨',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Watch Demo',
                            style: TextStyle(color: Color(0xFF2D3E50)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Skip Tutorial',
                            style: TextStyle(color: Color(0xFF2D3E50)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(number, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF2D3E50),
            ),
          ),
        ),
      ],
    );
  }
}