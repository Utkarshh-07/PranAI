// lib/features/my_space/widgets/quick_add_bar.dart (RESPONSIVE)
import 'package:flutter/material.dart';
import '../add_event_screen.dart';
import '../theme/card_styles.dart';
import '../../../widgets/ultimate_emoji.dart';

class QuickAddBar extends StatelessWidget {
  final DateTime selectedDay;
  final Function() onEventAdded;
  final bool isTablet;

  const QuickAddBar({
    super.key,
    required this.selectedDay,
    required this.onEventAdded,
    this.isTablet = false,
  });

  final List<Map<String, String>> quickEmojis = const [
    {'emoji': '📚', 'category': 'study', 'title': 'Study'},
    {'emoji': '📝', 'category': 'exam', 'title': 'Exam'},
    {'emoji': '🍿', 'category': 'fun', 'title': 'Movie'},
    {'emoji': '😌', 'category': 'self-care', 'title': 'Self Care'},
  ];

  final List<Map<String, String>> recentEmojis = const [
    {'emoji': '🎮', 'category': 'fun', 'title': 'Gaming'},
    {'emoji': '🌊', 'category': 'pranai', 'title': 'PranAI'},
    {'emoji': '😌', 'category': 'self-care', 'title': 'Self Care'},
    {'emoji': '💕', 'category': 'date', 'title': 'Date'},
    {'emoji': '⚽', 'category': 'sports', 'title': 'Sports'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flash_on,
              color: const Color(0xFF2D3E50),
              size: isTablet ? 24 : 20,
            ),
            const SizedBox(width: 8),
            Text(
              '⚡ QUICK ADD',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3E50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Quick add buttons - Responsive
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: quickEmojis.map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEventScreen(
                          initialDate: selectedDay,
                        ),
                      ),
                    );
                    if (result == true) {
                      onEventAdded();
                    }
                  },
                  style: CardStyles.secondaryButton.copyWith(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        horizontal: isTablet ? 20 : 16,
                        vertical: isTablet ? 14 : 10,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      UltimateEmoji(
                        emoji: item['emoji']!,
                        size: isTablet ? 18 : 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['title']!,
                        style: TextStyle(
                          color: const Color(0xFF2D3E50),
                          fontWeight: FontWeight.w500,
                          fontSize: isTablet ? 14 : 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Recently used
        Text(
          'Recently used:',
          style: TextStyle(
            fontSize: isTablet ? 13 : 12,
            color: const Color(0xFF2D3E50),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: recentEmojis.map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12 : 8,
                    vertical: isTablet ? 8 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D3E50).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF2D3E50).withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      UltimateEmoji(
                        emoji: item['emoji']!,
                        size: isTablet ? 16 : 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['title']!,
                        style: TextStyle(
                          fontSize: isTablet ? 13 : 11,
                          color: const Color(0xFF2D3E50).withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}