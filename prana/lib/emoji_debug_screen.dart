// lib/emoji_debug_screen.dart
import 'package:flutter/material.dart';
import 'dart:ui';

class EmojiDebugScreen extends StatelessWidget {
  const EmojiDebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Emoji Debug Test'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TEST 1: Plain Text',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('📚 🍿 💕 😉 🎮', style: TextStyle(fontSize: 40)),
            
            const SizedBox(height: 20),
            
            const Text(
              'TEST 2: Text with Color',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('📚 🍿 💕 😉 🎮', 
              style: TextStyle(fontSize: 40, color: Colors.red)),
            
            const SizedBox(height: 20),
            
            const Text(
              'TEST 3: With Opacity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Opacity(
              opacity: 0.5,
              child: const Text('📚 🍿 💕 😉 🎮', style: TextStyle(fontSize: 40)),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'TEST 4: With BackdropFilter (Blur)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.all(20),
                  child: const Text('📚 🍿 💕 😉 🎮', style: TextStyle(fontSize: 40)),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'TEST 5: With Blur + Colored Background',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: const Color(0xFFFFE5A3).withOpacity(0.2),
                  padding: const EdgeInsets.all(20),
                  child: const Text('📚 🍿 💕 😉 🎮', style: TextStyle(fontSize: 40)),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'TEST 6: Just Color, No Blur',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              color: const Color(0xFFFFE5A3).withOpacity(0.2),
              padding: const EdgeInsets.all(20),
              child: const Text('📚 🍿 💕 😉 🎮', style: TextStyle(fontSize: 40)),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'TEST 7: RichText with Fallback',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              color: const Color(0xFFFFE5A3).withOpacity(0.2),
              padding: const EdgeInsets.all(20),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '📚 ',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamilyFallback: ['Noto Color Emoji', 'Apple Color Emoji'],
                      ),
                    ),
                    TextSpan(
                      text: '🍿 ',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamilyFallback: ['Noto Color Emoji', 'Apple Color Emoji'],
                      ),
                    ),
                    TextSpan(
                      text: '💕 ',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamilyFallback: ['Noto Color Emoji', 'Apple Color Emoji'],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}