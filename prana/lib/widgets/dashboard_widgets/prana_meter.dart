// lib/widgets/dashboard_widgets/prana_meter.dart
import 'package:flutter/material.dart';

class PranaMeter extends StatelessWidget {
  final double pranaLevel;
  final int stressLevel;
  
  const PranaMeter({
    super.key,
    required this.pranaLevel,
    required this.stressLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.favorite_border, color: Color(0xFF4A6572)),
              SizedBox(width: 10),
              Text(
                'Prana Level',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A6572),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Circular Progress (simulated)
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getPranaColor(pranaLevel),
                      width: 12,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${(pranaLevel * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getPranaStatus(pranaLevel),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Stress Level
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stress Level',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: List.generate(5, (index) {
                  return Container(
                    width: 30,
                    height: 8,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: index < stressLevel 
                          ? _getStressColor(index) 
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 5),
              Text(
                _getStressText(stressLevel),
                style: TextStyle(
                  fontSize: 12,
                  color: _getStressColor(stressLevel),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPranaColor(double level) {
    if (level >= 0.7) return Colors.green;
    if (level >= 0.4) return Colors.orange;
    return Colors.red;
  }

  String _getPranaStatus(double level) {
    if (level >= 0.7) return 'High Energy';
    if (level >= 0.4) return 'Moderate';
    return 'Low Energy';
  }

  Color _getStressColor(int level) {
    if (level >= 4) return Colors.red;
    if (level >= 3) return Colors.orange;
    return Colors.green;
  }

  String _getStressText(int level) {
    switch (level) {
      case 1: return 'Very Low Stress';
      case 2: return 'Low Stress';
      case 3: return 'Moderate Stress';
      case 4: return 'High Stress';
      case 5: return 'Very High Stress';
      default: return 'Unknown';
    }
  }
}