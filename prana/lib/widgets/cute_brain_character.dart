import 'package:flutter/material.dart';

class CuteBrainCharacter extends StatelessWidget {
  final bool isPasswordVisible;
  final bool isTyping;
  final bool isLoginSuccessful;

  const CuteBrainCharacter({
    super.key,
    required this.isPasswordVisible,
    required this.isTyping,
    required this.isLoginSuccessful,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF4A6572),
        borderRadius: BorderRadius.circular(75),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Brain outline
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          
          // Brain hemispheres
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left hemisphere
              Container(
                width: 40,
                height: 80,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: isTyping ? const Color(0xFFF9AA33) : const Color(0xFF4A6572),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              
              // Right hemisphere
              Container(
                width: 40,
                height: 80,
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: isPasswordVisible ? const Color(0xFFF9AA33) : const Color(0xFF4A6572),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          
          // Eyes
          Positioned(
            top: 40,
            child: Row(
              children: [
                // Left eye
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF4A6572), width: 2),
                  ),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isTyping ? 8 : 10,
                      height: isTyping ? 8 : 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A6572),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                
                // Right eye
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF4A6572), width: 2),
                  ),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isPasswordVisible ? 8 : 10,
                      height: isPasswordVisible ? 8 : 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A6572),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Mouth (smile)
          Positioned(
            bottom: 40,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isLoginSuccessful ? 40 : 30,
              height: isLoginSuccessful ? 15 : 8,
              decoration: BoxDecoration(
                color: isLoginSuccessful ? const Color(0xFFF9AA33) : const Color(0xFF4A6572),
                borderRadius: BorderRadius.circular(isLoginSuccessful ? 10 : 4),
              ),
            ),
          ),
          
          // Sparkle effect when typing
          if (isTyping)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9AA33),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF9AA33).withOpacity(0.8),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}