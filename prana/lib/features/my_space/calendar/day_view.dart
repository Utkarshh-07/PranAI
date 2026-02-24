// lib/features/my_space/calendar/day_view.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../../../widgets/ultimate_emoji.dart';
import '../add_event_screen.dart';
import '../services/calendar_storage.dart';

class DayView extends StatefulWidget {
  final DateTime selectedDay;
  final List<EventModel> events;
  final Function(EventModel) onEventTap;
  final Function() onEventUpdated;

  const DayView({
    super.key,
    required this.selectedDay,
    required this.events,
    required this.onEventTap,
    required this.onEventUpdated,
  });

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  final CalendarStorage _storage = CalendarStorage();

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'study':
        return const Color(0xFFB4A7F5);
      case 'exam':
        return const Color(0xFFFFB7B2);
      case 'fun':
        return const Color(0xFFA3E4D7);
      case 'urgent':
        return const Color(0xFFD14545);
      default:
        return Colors.grey;
    }
  }

  Future<void> _editEvent(EventModel event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventScreen(eventToEdit: event),
      ),
    );
    if (result == true) {
      widget.onEventUpdated();
    }
  }

  Future<void> _deleteEvent(EventModel event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storage.deleteEvent(event.id);
      widget.onEventUpdated();
    }
  }

  Future<void> _showEmojiPicker(EventModel event) async {
    // Comprehensive emoji list for quick selection
    final List<String> emojis = [
      '📚', '📝', '📋', '🎉', '🍿', '🎮', '👪', '😌', '🌊', '🫂',
      '💕', '🏥', '💪', '😴', '⚠️', '🔴', '📖', '✏️', '🔬', '🧪',
      '🎬', '🎵', '🎨', '⚽', '🏀', '🎭', '🎤', '👥', '🤝', '💬',
      '🧘', '🛀', '💆', '🥗', '💤', '🧠', '🌿', '🕊️', '🐚', '🐠',
      '🐬', '🐳', '🦀', '🐙', '🏝️', '⛵', '🌅', '⭐', '✨', '🌟'
    ];

    final selectedEmoji = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose Emoji',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3E50),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF2D3E50)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Emoji Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: emojis.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pop(context, emojis[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: UltimateEmoji(
                          emoji: emojis[index],
                          size: 24,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedEmoji != null) {
      // Update event with new emoji
      final updatedEvent = EventModel(
        id: event.id,
        title: event.title,
        date: event.date,
        startTime: event.startTime,
        endTime: event.endTime,
        emoji: selectedEmoji,
        category: event.category,
        isCompleted: event.isCompleted,
        notes: event.notes,
      );
      await _storage.updateEvent(updatedEvent);
      widget.onEventUpdated();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedEvents = List<EventModel>.from(widget.events)
      ..sort((a, b) {
        if (a.startTime == null) return 1;
        if (b.startTime == null) return -1;
        return a.startTime!.hour.compareTo(b.startTime!.hour);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFB4A7F5).withOpacity(0.1), const Color(0xFFA3E4D7).withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                DateFormat('EEEE').format(widget.selectedDay),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3E50),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMM d, yyyy').format(widget.selectedDay),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2D3E50),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Events List
        if (widget.events.isEmpty)
          const Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                UltimateEmoji(emoji: '🌊', size: 60),
                SizedBox(height: 16),
                Text(
                  'No events for this day',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2D3E50),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap + to add an event',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2D3E50),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedEvents.length,
            itemBuilder: (context, index) {
              final event = sortedEvents[index];
              bool hasReminder = event.startTime != null;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: Colors.white.withOpacity(0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: _getCategoryColor(event.category).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Dismissible(
                  key: Key(event.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  confirmDismiss: (direction) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Event'),
                        content: Text('Delete "${event.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    return confirm ?? false;
                  },
                  onDismissed: (direction) async {
                    await _storage.deleteEvent(event.id);
                    widget.onEventUpdated();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${event.title} deleted'),
                          duration: const Duration(seconds: 1),
                          backgroundColor: const Color(0xFF2D3E50),
                        ),
                      );
                    }
                  },
                  child: ListTile(
                    leading: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => _showEmojiPicker(event),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _getCategoryColor(event.category).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: UltimateEmoji(
                                emoji: event.emoji,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        if (hasReminder)
                          const Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(Icons.circle, color: Colors.orange, size: 10),
                          ),
                      ],
                    ),
                    title: Text(
                      event.title,
                      style: TextStyle(
                        decoration: event.isCompleted ? TextDecoration.lineThrough : null,
                        color: event.isCompleted ? Colors.grey : const Color(0xFF2D3E50),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      event.startTime != null && event.endTime != null
                          ? '${event.startTime!.format(context)} - ${event.endTime!.format(context)}'
                          : event.startTime != null
                              ? 'Starts at ${event.startTime!.format(context)}'
                              : event.notes ?? 'No time set',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF6B7A8F)),
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Color(0xFF2D3E50)),
                      onSelected: (value) async {
                        if (value == 'edit') {
                          await _editEvent(event);
                        } else if (value == 'delete') {
                          await _deleteEvent(event);
                        } else if (value == 'emoji') {
                          await _showEmojiPicker(event);
                        } else if (value == 'complete') {
                          final updatedEvent = EventModel(
                            id: event.id,
                            title: event.title,
                            date: event.date,
                            startTime: event.startTime,
                            endTime: event.endTime,
                            emoji: event.emoji,
                            category: event.category,
                            isCompleted: !event.isCompleted,
                            notes: event.notes,
                          );
                          await _storage.updateEvent(updatedEvent);
                          widget.onEventUpdated();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18, color: Color(0xFF2D3E50)),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'emoji',
                          child: Row(
                            children: [
                              Icon(Icons.emoji_emotions, size: 18, color: Color(0xFF2D3E50)),
                              SizedBox(width: 8),
                              Text('Change Emoji'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'complete',
                          child: Row(
                            children: [
                              Icon(
                                event.isCompleted ? Icons.undo : Icons.check_circle,
                                size: 18,
                                color: event.isCompleted ? Colors.orange : Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(event.isCompleted ? 'Mark Incomplete' : 'Mark Complete'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () => widget.onEventTap(event),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}