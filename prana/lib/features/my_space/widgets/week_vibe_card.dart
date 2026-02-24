// lib/features/my_space/widgets/week_vibe_card.dart (WITH ACTUAL EMOJIS)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../../../widgets/ultimate_emoji.dart';

class WeekVibeCard extends StatelessWidget {
  final List<EventModel> events;
  final bool isTablet;

  const WeekVibeCard({
    super.key,
    required this.events,
    this.isTablet = false,
  });

  String _getEmojiForDay(DateTime day) {
    final dayEvents = events.where((e) => 
      e.date.year == day.year &&
      e.date.month == day.month &&
      e.date.day == day.day
    ).toList();
    
    if (dayEvents.isEmpty) return '🌊';
    
    // Priority order
    if (dayEvents.any((e) => e.category == 'urgent')) return '⚠️';
    if (dayEvents.any((e) => e.category == 'exam')) return '📝';
    
    return dayEvents.first.emoji;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekDays = List.generate(7, (index) {
      return now.add(Duration(days: index - now.weekday + 1));
    });

    int studyCount = 0;
    for (var day in weekDays) {
      final dayEvents = events.where((e) => 
        e.date.year == day.year &&
        e.date.month == day.month &&
        e.date.day == day.day &&
        e.category == 'study'
      ).toList();
      if (dayEvents.isNotEmpty) studyCount++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  '📊 ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'THIS WEEK\'S VIBE',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3E50),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View',
                style: TextStyle(
                  color: const Color(0xFF2D3E50),
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 14 : 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Days grid - Responsive
        LayoutBuilder(
          builder: (context, constraints) {
            double cellSize = constraints.maxWidth / 8;
            if (cellSize > 60) cellSize = 60; // Max size for large screens
            
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: weekDays.map((day) {
                  final emoji = _getEmojiForDay(day);
                  final isToday = day.year == now.year &&
                                  day.month == now.month &&
                                  day.day == now.day;
                  
                  return Container(
                    width: cellSize,
                    margin: const EdgeInsets.only(right: 4),
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 12 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: isToday ? const Color(0xFF2D3E50).withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2D3E50).withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('E').format(day).substring(0, 1),
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3E50).withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // ACTUAL EMOJI
                        UltimateEmoji(
                          emoji: emoji,
                          size: isTablet ? 24 : 20,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: isTablet ? 12 : 11,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: const Color(0xFF2D3E50),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
        
        // Balance tip
        if (studyCount >= 4)
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: EdgeInsets.all(isTablet ? 16 : 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5A3).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE5A3).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: Color(0xFF8A6E2E), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$studyCount study days. Add 😌 self-care?',
                    style: TextStyle(
                      color: const Color(0xFF2D3E50),
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(40, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: const Color(0xFF2D3E50),
                      fontSize: isTablet ? 13 : 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}