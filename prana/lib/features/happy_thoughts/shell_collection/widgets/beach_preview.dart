import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prana/features/happy_thoughts/shell_collection/models/shell_model.dart';
import 'package:prana/features/happy_thoughts/shell_collection/animations/beach_transformation.dart';

class BeachPreview extends StatelessWidget {
  final List<Shell> shells;
  
  const BeachPreview({Key? key, required this.shells}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final beachColors = BeachTransformation.getBeachColorsForTime();
    
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: beachColors,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Wave animation
          Positioned.fill(
            child: BeachTransformation.createWaveAnimation(Size(300, 200)),
          ),
          
          // Shells placed on beach
          ..._placeShellsOnBeach(),
          
          // Beach information
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Beach',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${shells.length} treasures collected',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Level ${_calculateBeachLevel(shells.length)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Time-based message
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                BeachTransformation.getBeachMessageForTime(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<Widget> _placeShellsOnBeach() {
    final List<Widget> shellWidgets = [];
    final shellCount = shells.length;
    
    // Place shells at different positions
    for (int i = 0; i < min(shellCount, 8); i++) {
      final shell = shells[i];
      final position = _calculateShellPosition(i, shellCount);
      
      shellWidgets.add(
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Transform.rotate(
            angle: i * 0.3, // Slight rotation for natural look
            child: Container(
              width: 30 + (shell.size * 10),
              height: 30 + (shell.size * 10),
              decoration: BoxDecoration(
                color: shell.glowColor.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: shell.glowColor,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: shell.glowColor.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  shell.emoji,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return shellWidgets;
  }
  
  Offset _calculateShellPosition(int index, int total) {
    // Create natural looking positions
    final widthSpacing = 300.0 / (total + 1);
    final baseX = widthSpacing * (index + 1);
    final baseY = 120.0 + (index % 3) * 20.0; // Slight vertical variation
    
    // Add some randomness for natural look
    final randomX = (index * 17) % 20 - 10;
    final randomY = (index * 23) % 15 - 7;
    
    return Offset(baseX + randomX, baseY + randomY);
  }
  
  int _calculateBeachLevel(int shellCount) {
    if (shellCount <= 5) return 1;
    if (shellCount <= 15) return 2;
    if (shellCount <= 30) return 3;
    if (shellCount <= 50) return 4;
    return 5;
  }
}