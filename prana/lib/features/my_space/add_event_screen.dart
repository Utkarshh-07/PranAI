// lib/features/my_space/add_event_screen.dart (COMPLETE)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'models/event_model.dart';
import 'services/calendar_storage.dart';
import 'services/notification_service.dart';
import 'theme/card_styles.dart';
import '../../widgets/ultimate_emoji.dart';
import 'widgets/celebration_overlay.dart';
import 'dart:ui';
import 'dart:math';

class AddEventScreen extends StatefulWidget {
  final DateTime? initialDate;
  final EventModel? eventToEdit;

  const AddEventScreen({
    super.key,
    this.initialDate,
    this.eventToEdit,
  });

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  
  late DateTime _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _selectedEmoji = '📚';
  String _selectedCategory = 'study';
  bool _isCompleted = false;
  bool _setReminder = true;
  String _reminderTime = '15 minutes before';
  
  bool _isSaving = false;

  // Animation controller for button
  late AnimationController _animationController;
  late Animation<double> _saveButtonScale;

  final CalendarStorage _storage = CalendarStorage();
  final NotificationService _notificationService = NotificationService();

  // Main categories with emojis
  final List<Map<String, dynamic>> _categories = [
    {'id': 'study', 'emoji': '📚', 'name': 'Study', 'color': const Color(0xFFB4A7F5)},
    {'id': 'self-care', 'emoji': '😌', 'name': 'Self', 'color': const Color(0xFFA3E4D7)},
    {'id': 'fun', 'emoji': '🎮', 'name': 'Fun', 'color': const Color(0xFFFFB7B2)},
    {'id': 'social', 'emoji': '👥', 'name': 'Social', 'color': const Color(0xFFFFE5A3)},
    {'id': 'ocean', 'emoji': '🌊', 'name': 'Ocean', 'color': const Color(0xFFA7D8FF)},
    {'id': 'more', 'emoji': '➕', 'name': 'More', 'color': const Color(0xFFD9D9D9)},
  ];

  // Reminder options
  final List<String> _reminderOptions = [
    '5 minutes before',
    '15 minutes before',
    '30 minutes before',
    '1 hour before',
    '2 hours before',
    '1 day before',
  ];

  // Complete emoji collection
  final List<Map<String, dynamic>> _allEmojiCategories = [
    {
      'name': 'Movie',
      'emojis': ['🎬', '🍿', '🎥', '📽️', '🎞️', '📺', '📻', '🎭', '🎪', '🎟️', '🎫', '🎦', '📀', '💿', '📼', '📹', '📷', '📸', '🎙️', '🎚️', '🎛️', '🎤', '🎧', '🎼', '🎵', '🎶', '🎸', '🎹', '🎺', '🎻']
    },
    {
      'name': 'Study',
      'emojis': ['📚', '📝', '📖', '📒', '📓', '📔', '📕', '📗', '📘', '📙', '📌', '📍', '✂️', '📏', '📐', '📎', '🖇️', '📁', '📂', '🗂️', '📅', '📆', '📇', '📈', '📉', '📊', '📋', '📑', '🗒️', '🗓️']
    },
    {
      'name': 'Work',
      'emojis': ['💼', '📊', '📈', '📉', '📋', '📁', '📂', '🗂️', '📅', '📆', '⌚', '💻', '🖥️', '🖨️', '📠', '☎️', '📞', '📟', '📱', '📲', '💽', '💾', '💿', '📀', '🎥', '📷', '📸', '📹', '📼', '🔍']
    },
    {
      'name': 'Health',
      'emojis': ['💪', '🏋️', '🚴', '🧘', '🤸', '⛹️', '🤾', '🏊', '🧎', '🧍', '🚶', '🏃', '🩼', '🩻', '🩺', '💊', '💉', '🩸', '🦷', '🦴', '🧠', '🫀', '🫁', '🫂', '🧪', '🔬', '🩹', '🩼', '🦯']
    },
    {
      'name': 'Food',
      'emojis': ['🍔', '🍕', '🌮', '🥗', '🍣', '🍜', '🍝', '🍛', '🍲', '🥘', '🍱', '🥟', '🍤', '🍚', '🍙', '🍘', '🍥', '🥠', '🥮', '🍡', '🍧', '🍨', '🍦', '🥧', '🧁', '🍰', '🎂', '🍮', '🍭', '🍬']
    },
    {
      'name': 'Nature',
      'emojis': ['🌲', '🌳', '🌴', '🌿', '🍃', '🍂', '🌸', '🌺', '🌻', '🌞', '🌙', '⭐', '🌟', '☁️', '🌈', '⛈️', '🌨️', '❄️', '💧', '☀️', '🌤️', '⛅', '🌥️', '🌦️', '🌧️', '🌩️', '🌪️', '🌫️', '🌬️']
    },
    {
      'name': 'Sports',
      'emojis': ['⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🏉', '🥏', '🎯', '🏓', '🏸', '🏒', '🏑', '🏏', '🪃', '🥅', '⛳', '🏹', '🎣', '🤿', '🥊', '🥋', '🎽', '🛹', '🛼', '🛷', '⛸️', '🥌', '🎿', '⛷️']
    },
    {
      'name': 'Music',
      'emojis': ['🎵', '🎶', '🎼', '🎤', '🎧', '🎸', '🎹', '🎺', '🎻', '🥁', '🪘', '📯', '🎙️', '🎚️', '🎛️', '📻', '🎷', '🎸', '🎹', '🎺', '🎻', '🪗', '🪕', '🎤', '🎧', '📻']
    },
    {
      'name': 'Travel',
      'emojis': ['✈️', '🚗', '🚕', '🚙', '🚌', '🚎', '🏎️', '🚓', '🚑', '🚒', '🚐', '🛻', '🚚', '🚛', '🚜', '🛵', '🏍️', '🛺', '🚲', '🛴', '🚏', '🛣️', '🛤️', '🚂', '🚝', '🚞', '✈️', '🛫', '🛬', '🛩️']
    },
    {
      'name': 'Celebration',
      'emojis': ['🎉', '🎊', '🥳', '🎂', '🍰', '🧁', '🍾', '🥂', '🍻', '🍷', '🥃', '🍸', '🍹', '🧉', '🍵', '☕', '🎈', '🎁', '🎀', '🎊', '🎉', '🎐', '🎏', '🎎', '🎍', '🎋', '🎑', '🎆', '🎇', '✨']
    },
    {
      'name': 'Art',
      'emojis': ['🎨', '🖼️', '🎭', '🎪', '🪄', '🎬', '📽️', '🎞️', '📷', '📸', '📹', '📼', '🔦', '💡', '🪔', '🕯️', '🎮', '🎲', '♟️', '🎴', '🃏', '🀄', '🎯', '🎱', '🎮', '🎰', '🎲']
    },
    {
      'name': 'Animals',
      'emojis': ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐙', '🦊', '🐻‍❄️', '🐵', '🐒', '🦍', '🦧', '🐩', '🐕', '🐈', '🐈⬛', '🐆', '🐅', '🐃', '🐂', '🐄']
    },
    {
      'name': 'Self Care',
      'emojis': ['😌', '🧘', '🛀', '💆', '💇', '🚿', '🪞', '💄', '💅', '🫧', '✨', '🌟', '⭐', '🌙', '☀️', '⛅', '🌈', '🌊', '💧', '🌿', '🍃', '🌱', '🌴', '🌸', '🌺', '🌻', '🌞', '🕊️', '🧠', '💤']
    },
    {
      'name': 'Social',
      'emojis': ['👥', '🤝', '👋', '🤚', '🖐️', '✋', '👌', '🤌', '🤏', '👍', '👎', '👊', '✊', '🤛', '🤜', '🙏', '🤝', '👏', '🙌', '👐', '🤲', '🤝', '💬', '🗣️', '👤', '👥', '🫂', '🤗', '🤔', '🤭']
    },
    {
      'name': 'Urgent',
      'emojis': ['⚠️', '🔴', '🟠', '🟡', '🟢', '🔵', '🟣', '⚫', '⚪', '🟤', '🔔', '📢', '📣', '🚨', '🆘', '🚫', '❌', '⭕', '💢', '🔥', '💥', '💫', '💦', '💨', '⚡', '💧', '❄️', '🌊', '🌪️', '☄️']
    },
    {
      'name': 'Ocean',
      'emojis': ['🌊', '🐚', '🐠', '🐟', '🐬', '🐳', '🐋', '🦈', '🐙', '🦑', '🦐', '🦞', '🐡', '🐠', '🐟', '🌊', '🏝️', '🏖️', '⛵', '🚤', '🛥️', '🛳️', '⚓', '🧭', '🗺️', '🌅', '🌄', '🏜️', '🏝️', '🏞️']
    },
  ];

  String _selectedEmojiCategory = 'Movie';

  @override
  void initState() {
    super.initState();
    
    // Animation controller for button
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _saveButtonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _titleFocusNode.addListener(() {
      setState(() {});
    });

    if (widget.eventToEdit != null) {
      _titleController.text = widget.eventToEdit!.title;
      _notesController.text = widget.eventToEdit!.notes ?? '';
      _selectedDate = widget.eventToEdit!.date;
      _startTime = widget.eventToEdit!.startTime;
      _endTime = widget.eventToEdit!.endTime;
      _selectedEmoji = widget.eventToEdit!.emoji;
      _selectedCategory = widget.eventToEdit!.category;
      _isCompleted = widget.eventToEdit!.isCompleted;
      _setReminder = widget.eventToEdit!.startTime != null;
    } else {
      _selectedDate = widget.initialDate ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _titleFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _getDuration() {
    if (_startTime == null || _endTime == null) return '';
    
    final start = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime!.hour,
      _startTime!.minute,
    );
    
    final end = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime!.hour,
      _endTime!.minute,
    );
    
    final difference = end.difference(start);
    
    if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ${difference.inMinutes % 60} minute${difference.inMinutes % 60 > 1 ? 's' : ''}';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2D3E50),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2D3E50),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2D3E50),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2D3E50),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _openFullEmojiPicker() async {
    String selectedCategory = 'Movie';
    
    final selectedEmoji = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
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
                        fontSize: 20,
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
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D3E50).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: UltimateEmoji(
                          emoji: _selectedEmoji,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Selected emoji',
                      style: TextStyle(
                        color: Color(0xFF2D3E50),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _allEmojiCategories.length,
                  itemBuilder: (context, index) {
                    final category = _allEmojiCategories[index]['name'] as String;
                    final isSelected = selectedCategory == category;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (category == 'Movie' 
                                  ? const Color(0xFFFFB7B2)
                                  : const Color(0xFF2D3E50))
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            if (category == 'Movie')
                              const Text('🎬 ', style: TextStyle(fontSize: 16)),
                            Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF2D3E50),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 8),
              
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: (_allEmojiCategories.firstWhere(
                    (cat) => cat['name'] == selectedCategory,
                    orElse: () => _allEmojiCategories.first,
                  )['emojis'] as List<String>).length,
                  itemBuilder: (context, index) {
                    final emojiList = _allEmojiCategories.firstWhere(
                      (cat) => cat['name'] == selectedCategory,
                      orElse: () => _allEmojiCategories.first,
                    )['emojis'] as List<String>;
                    
                    final emoji = emojiList[index];
                    final isSelected = _selectedEmoji == emoji;
                    
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, emoji),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2D3E50).withOpacity(0.1)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2D3E50)
                                : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: const Color(0xFF2D3E50).withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ] : null,
                        ),
                        child: Center(
                          child: UltimateEmoji(
                            emoji: emoji,
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
      ),
    );

    if (selectedEmoji != null) {
      setState(() {
        _selectedEmoji = selectedEmoji;
        _selectedCategory = 'more';
      });
    }
  }

  Future<void> _saveEvent({bool addAnother = false}) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });
      
      // Button press animation
      _animationController.forward();
      await Future.delayed(const Duration(milliseconds: 100));
      _animationController.reverse();

      final event = EventModel(
        id: widget.eventToEdit?.id ?? const Uuid().v4(),
        title: _titleController.text,
        date: _selectedDate,
        startTime: _startTime,
        endTime: _endTime,
        emoji: _selectedEmoji,
        category: _selectedCategory,
        isCompleted: _isCompleted,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (widget.eventToEdit != null) {
        await _storage.updateEvent(event);
      } else {
        await _storage.addEvent(event);
      }

      if (_setReminder && _startTime != null) {
        await _notificationService.scheduleEventReminder(event);
      }

      if (mounted) {
        if (addAnother) {
          _titleController.clear();
          _notesController.clear();
          _startTime = null;
          _endTime = null;
          _selectedEmoji = '📚';
          _selectedCategory = 'study';
          setState(() {
            _isSaving = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Event saved! Add another one')),
                ],
              ),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xFF2D3E50),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          );
        } else {
          setState(() {
            _isSaving = false;
          });

          // Get category color
          Color categoryColor = _categories.firstWhere(
            (cat) => cat['id'] == _selectedCategory,
            orElse: () => _categories.first,
          )['color'];

          // Show personalized celebration
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => CelebrationOverlay(
              eventTitle: _titleController.text,
              eventEmoji: _selectedEmoji,
              eventCategory: _selectedCategory,
              categoryColor: categoryColor,
              onComplete: () {
                Navigator.pop(context); // Close celebration
                Navigator.pop(context, true); // Go back
              },
            ),
          );
        }
      }
    }
  }

  Widget _buildLabel(String text, {Color? accentColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: accentColor ?? const Color(0xFFB4A7F5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF2D3E50),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    final isFocused = _titleFocusNode.hasFocus;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused
              ? const Color(0xFF2D3E50)
              : const Color(0xFF2D3E50).withOpacity(0.2),
          width: isFocused ? 2 : 1,
        ),
        boxShadow: isFocused ? [
          BoxShadow(
            color: const Color(0xFF2D3E50).withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        style: const TextStyle(color: Color(0xFF2D3E50), fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: const Color(0xFF2D3E50).withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: isFocused
              ? const Icon(Icons.edit, color: Color(0xFF2D3E50), size: 20)
              : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a title';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmojiSelector() {
    return GestureDetector(
      onTap: _openFullEmojiPicker,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2D3E50).withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2D3E50).withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: UltimateEmoji(
                  emoji: _selectedEmoji,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Tap to change emoji',
              style: TextStyle(
                color: Color(0xFF2D3E50),
                fontSize: 14,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF2D3E50),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickEmojiGrid() {
    final quickEmojis = _allEmojiCategories.firstWhere(
      (cat) => cat['name'] == 'Movie',
      orElse: () => _allEmojiCategories.first,
    )['emojis'].take(8).toList();

    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: quickEmojis.length,
        itemBuilder: (context, index) {
          final emoji = quickEmojis[index];
          final isSelected = _selectedEmoji == emoji;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedEmoji = emoji;
                _selectedCategory = 'more';
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFB7B2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFFB7B2)
                      : const Color(0xFF2D3E50).withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: const Color(0xFFFFB7B2).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ] : null,
              ),
              child: Center(
                child: UltimateEmoji(emoji: emoji, size: 24),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = _startTime != null && _endTime != null ? _getDuration() : null;

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
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
          
          // Loading overlay
          if (_isSaving)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2D3E50)),
                ),
              ),
            ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF2D3E50), size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          const Text(
                            '🎉 ',
                            style: TextStyle(fontSize: 28),
                          ),
                          const Text(
                            'ADD EVENT',
                            style: TextStyle(
                              color: Color(0xFF2D3E50),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                
                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Plan your perfect day',
                      style: TextStyle(
                        color: const Color(0xFF2D3E50).withOpacity(0.7),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Main Card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            border: Border.all(color: Colors.white.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // What are you doing?
                                  _buildLabel('What are you doing?', accentColor: const Color(0xFFB4A7F5)),
                                  _buildTextField('e.g., Study Session, Game, Meeting...'),
                                  
                                  // Helpful tip
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4, left: 8),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.lightbulb_outline, size: 12, color: Color(0xFF2D3E50)),
                                        const SizedBox(width: 4),
                                        Text(
                                          '✨ Be specific — it helps your AI friend',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: const Color(0xFF2D3E50).withOpacity(0.6),
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Emoji Selector
                                  _buildLabel('Choose Emoji', accentColor: const Color(0xFFFFB7B2)),
                                  _buildEmojiSelector(),
                                  
                                  const SizedBox(height: 12),
                                  
                                  // Quick emoji picks
                                  _buildQuickEmojiGrid(),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Date
                                  _buildLabel('Date', accentColor: const Color(0xFFFFB7B2)),
                                  GestureDetector(
                                    onTap: _selectDate,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: const Color(0xFF2D3E50).withOpacity(0.2)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today, color: Color(0xFF2D3E50), size: 18),
                                              const SizedBox(width: 8),
                                              Text(
                                                DateFormat('EEE, MMM d, yyyy').format(_selectedDate),
                                                style: const TextStyle(
                                                  color: Color(0xFF2D3E50),
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2D3E50).withOpacity(0.05),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Color(0xFF2D3E50),
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Time Row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildLabel('Start', accentColor: const Color(0xFFA3E4D7)),
                                            GestureDetector(
                                              onTap: () => _selectTime(true),
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(16),
                                                  border: Border.all(color: const Color(0xFF2D3E50).withOpacity(0.2)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.05),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.access_time, color: Color(0xFF2D3E50), size: 18),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          _startTime?.format(context) ?? 'Not set',
                                                          style: TextStyle(
                                                            color: _startTime != null 
                                                                ? const Color(0xFF2D3E50) 
                                                                : const Color(0xFF2D3E50).withOpacity(0.4),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Color(0xFF2D3E50),
                                                      size: 18,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Animated arrow
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: _startTime != null && _endTime != null
                                              ? const Color(0xFF2D3E50)
                                              : const Color(0xFF2D3E50).withOpacity(0.3),
                                          size: 20,
                                        ),
                                      ),
                                      
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildLabel('End', accentColor: const Color(0xFFA3E4D7)),
                                            GestureDetector(
                                              onTap: () => _selectTime(false),
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(16),
                                                  border: Border.all(color: const Color(0xFF2D3E50).withOpacity(0.2)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.05),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.access_time, color: Color(0xFF2D3E50), size: 18),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          _endTime?.format(context) ?? 'Not set',
                                                          style: TextStyle(
                                                            color: _endTime != null 
                                                                ? const Color(0xFF2D3E50) 
                                                                : const Color(0xFF2D3E50).withOpacity(0.4),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Color(0xFF2D3E50),
                                                      size: 18,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  // Duration
                                  if (duration != null)
                                    AnimatedOpacity(
                                      duration: const Duration(milliseconds: 300),
                                      opacity: 1.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8, left: 8),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.timer, size: 14, color: Color(0xFF2D3E50)),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Duration: $duration',
                                              style: TextStyle(
                                                color: const Color(0xFF2D3E50).withOpacity(0.7),
                                                fontSize: 13,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Reminder
                                  _buildLabel('Reminder', accentColor: const Color(0xFFFFE5A3)),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFF2D3E50).withOpacity(0.2)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: _setReminder
                                                    ? const Color(0xFFFFE5A3)
                                                    : const Color(0xFF2D3E50).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.notifications_active,
                                                  color: _setReminder
                                                      ? const Color(0xFF2D3E50)
                                                      : const Color(0xFF2D3E50).withOpacity(0.5),
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Expanded(
                                              child: Text(
                                                'Remind me',
                                                style: TextStyle(
                                                  color: Color(0xFF2D3E50),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Switch(
                                              value: _setReminder,
                                              onChanged: _startTime != null
                                                  ? (value) => setState(() => _setReminder = value)
                                                  : null,
                                              activeColor: const Color(0xFFFFE5A3),
                                              activeTrackColor: const Color(0xFFFFE5A3).withOpacity(0.3),
                                            ),
                                          ],
                                        ),
                                        if (_setReminder) ...[
                                          const SizedBox(height: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: DropdownButton<String>(
                                              value: _reminderTime,
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2D3E50)),
                                              onChanged: (String? newValue) {
                                                if (newValue != null) {
                                                  setState(() => _reminderTime = newValue);
                                                }
                                              },
                                              items: _reminderOptions.map((String option) {
                                                return DropdownMenuItem<String>(
                                                  value: option,
                                                  child: Text(
                                                    option,
                                                    style: const TextStyle(color: Color(0xFF2D3E50)),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.info_outline, size: 12, color: Color(0xFF2D3E50)),
                                              const SizedBox(width: 4),
                                              Text(
                                                '⏱️ We\'ll notify you before your event',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: const Color(0xFF2D3E50).withOpacity(0.6),
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Categories Row
                                  _buildLabel('Choose a category:', accentColor: const Color(0xFFB4A7F5)),
                                  const SizedBox(height: 12),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: _categories.map((category) {
                                        final isSelected = _selectedCategory == category['id'];
                                        final Color categoryColor = category['color'];
                                        
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 12),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (category['id'] == 'more') {
                                                _openFullEmojiPicker();
                                              } else {
                                                setState(() {
                                                  _selectedCategory = category['id'];
                                                  _selectedEmoji = category['emoji'];
                                                });
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                AnimatedContainer(
                                                  duration: const Duration(milliseconds: 200),
                                                  width: 56,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: isSelected
                                                        ? categoryColor
                                                        : Colors.white,
                                                    border: Border.all(
                                                      color: isSelected
                                                          ? categoryColor
                                                          : const Color(0xFF2D3E50).withOpacity(0.2),
                                                      width: isSelected ? 2 : 1,
                                                    ),
                                                    boxShadow: isSelected ? [
                                                      BoxShadow(
                                                        color: categoryColor.withOpacity(0.4),
                                                        blurRadius: 12,
                                                        spreadRadius: 2,
                                                      ),
                                                    ] : [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.05),
                                                        blurRadius: 8,
                                                        offset: const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: UltimateEmoji(
                                                      emoji: _selectedCategory == 'more' && isSelected 
                                                          ? _selectedEmoji 
                                                          : category['emoji'],
                                                      size: 28,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  category['name'],
                                                  style: TextStyle(
                                                    color: isSelected 
                                                        ? categoryColor 
                                                        : const Color(0xFF2D3E50).withOpacity(0.7),
                                                    fontSize: 11,
                                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Notes (optional)
                                  if (widget.eventToEdit != null) ...[
                                    _buildLabel('Notes (optional)', accentColor: const Color(0xFFB4A7F5)),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: const Color(0xFF2D3E50).withOpacity(0.2)),
                                      ),
                                      child: TextFormField(
                                        controller: _notesController,
                                        style: const TextStyle(color: Color(0xFF2D3E50)),
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          hintText: 'Add notes...',
                                          hintStyle: TextStyle(color: const Color(0xFF2D3E50).withOpacity(0.4)),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.all(16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                  
                                  // Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          style: TextButton.styleFrom(
                                            foregroundColor: const Color(0xFF2D3E50).withOpacity(0.7),
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ScaleTransition(
                                          scale: _saveButtonScale,
                                          child: ElevatedButton.icon(
                                            onPressed: _isSaving ? null : () => _saveEvent(addAnother: false),
                                            icon: _isSaving
                                                ? const SizedBox(
                                                    width: 18,
                                                    height: 18,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Color(0xFF2D3E50),
                                                    ),
                                                  )
                                                : const Icon(Icons.auto_awesome, size: 18),
                                            label: Text(
                                              _isSaving ? 'SAVING...' : 'SAVE',
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: const Color(0xFF2D3E50),
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              elevation: 4,
                                              shadowColor: Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 12),
                                  
                                  // Add Another button
                                  Center(
                                    child: TextButton.icon(
                                      onPressed: _isSaving ? null : () => _saveEvent(addAnother: true),
                                      icon: const Icon(Icons.add_circle_outline, size: 18),
                                      label: const Text(
                                        'Add Another Event',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFF2D3E50).withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}