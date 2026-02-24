import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Brain logo
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFF4A6572),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  "🧠",
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // App title
            const Text(
              "Prana",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A6572),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Tagline
            const Text(
              "Mental Fitness for Students",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Begin Journey button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Begin Journey",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9AA33),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Footer
            const Text(
              "Made by Utkarsh.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Made with ❤️ in India",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}