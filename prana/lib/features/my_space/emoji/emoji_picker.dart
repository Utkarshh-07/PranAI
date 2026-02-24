// lib/features/my_space/emoji/emoji_picker.dart
import 'package:flutter/material.dart';
import 'emoji_library.dart';

class EmojiPicker extends StatefulWidget {
  final Function(String) onEmojiSelected;
  final String? initialEmoji;

  const EmojiPicker({
    super.key,
    required this.onEmojiSelected,
    this.initialEmoji,
  });

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
  String selectedCategory = 'Study';
  late String selectedEmoji;

  @override
  void initState() {
    super.initState();
    selectedEmoji = widget.initialEmoji ?? '📝';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Category tabs
        Container(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: EmojiLibrary.categories.length,
            itemBuilder: (context, index) {
              final category = EmojiLibrary.categories[index];
              final isSelected = selectedCategory == category['name'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category['name']!;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.teal : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category['name']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Emoji grid
        Container(
          height: 200,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 1,
            ),
            itemCount: EmojiLibrary.getEmojisByCategory(selectedCategory).length,
            itemBuilder: (context, index) {
              final emoji = EmojiLibrary.getEmojisByCategory(selectedCategory)[index];
              final isSelected = selectedEmoji == emoji;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmoji = emoji;
                  });
                  widget.onEmojiSelected(emoji);
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.teal.withOpacity(0.2) : null,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected ? Border.all(color: Colors.teal, width: 2) : null,
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}