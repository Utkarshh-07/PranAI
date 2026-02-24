// lib/widgets/dashboard_widgets/mood_selector.dart - COMPLETE VERSION
import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String currentMood;
  final Function(String) onMoodSelected;
  
  const MoodSelector({
    super.key,
    required this.currentMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> moods = [
      {'emoji': '😊', 'label': 'Happy', 'color': Color(0xFFFFE8E8)},
      {'emoji': '😌', 'label': 'Calm', 'color': Color(0xFFE8F5E9)},
      {'emoji': '😐', 'label': 'Neutral', 'color': Color(0xFFE3F2FD)},
      {'emoji': '😰', 'label': 'Stressed', 'color': Color(0xFFFFF3E0)},
      {'emoji': '😥', 'label': 'Anxious', 'color': Color(0xFFFCE4EC)},
    ];

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
              Icon(Icons.mood, color: Color(0xFF4A6572)),
              SizedBox(width: 10),
              Text(
                'How are you feeling today?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A6572),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 15),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: moods.map((mood) {
              bool isSelected = currentMood == mood['label'];
              return GestureDetector(
                onTap: () => onMoodSelected(mood['label']),
                child: Column(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: isSelected ? mood['color'] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        border: isSelected
                            ? Border.all(color: const Color(0xFFF9AA33), width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          mood['emoji'],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mood['label'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? const Color(0xFF4A6572) : Colors.grey[600],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}