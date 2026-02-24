// lib/features/my_space/widgets/custom_emoji_picker.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/ultimate_emoji.dart';  // ← IMPORT ADDED

class CustomEmojiPicker extends StatefulWidget {
  final Function(String) onEmojiSelected;
  final List<String> initialRecentEmojis;

  const CustomEmojiPicker({
    super.key,
    required this.onEmojiSelected,
    this.initialRecentEmojis = const [],
  });

  @override
  State<CustomEmojiPicker> createState() => _CustomEmojiPickerState();
}

class _CustomEmojiPickerState extends State<CustomEmojiPicker> {
  String _searchQuery = '';
  String _selectedCategory = '😊 Smileys';
  List<String> _recentEmojis = [];
  final TextEditingController _customEmojiController = TextEditingController();

  final Map<String, List<String>> _emojiCategories = {
    '😊 Smileys': ['😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚', '😋', '😛', '😝', '😜', '🤪', '🤨', '🧐', '🤓', '😎', '🥸', '🤩', '🥳', '😏', '😒', '😞', '😔', '😟', '😕', '🙁', '☹️', '😣', '😖', '😫', '😩', '🥺', '😢', '😭', '😤', '😠', '😡', '🤬', '🤯', '😳', '🥵', '🥶', '😱', '😨', '😰', '😥', '😓', '🤗', '🤔', '🤭', '🤫', '🤥', '😶', '😐', '😑', '😬', '🙄', '😯', '😦', '😧', '😮', '😲', '🥱', '😴', '🤤', '😪', '😵', '🤐', '🥴', '🤢', '🤮', '🤧', '😷', '🤒', '🤕', '🤑', '🤠'],
    
    '👋 People': ['👋', '🤚', '🖐', '✋', '🖖', '👌', '🤌', '🤏', '✌️', '🤞', '🫰', '🤟', '🤘', '🤙', '👈', '👉', '👆', '🖕', '👇', '👍', '👎', '✊', '👊', '🤛', '🤜', '👏', '🙌', '👐', '🤲', '🤝', '🙏', '✍️', '💅', '🤳', '💪', '🦾', '🦵', '🦿', '🦶', '👣', '👀', '🫀', '🫁', '🧠', '🦷', '🦴', '👅', '👄'],
    
    '🐶 Animals': ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐻‍❄️', '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐙', '🦑', '🦐', '🦞', '🦀', '🐡', '🐠', '🐟', '🐬', '🐳', '🐋', '🦈', '🐊', '🐅', '🐆', '🦓', '🦍', '🦧', '🦣', '🐘', '🦛', '🦏', '🐪', '🐫', '🦒', '🦘', '🦬', '🐃', '🐂', '🐄', '🐎', '🐖', '🐏', '🐑', '🐐', '🦌', '🦙', '🦥', '🦦', '🦨', '🦡', '🐀', '🐁', '🐉', '🐲', '🦕', '🦖'],
    
    '🍎 Food': ['🍎', '🍐', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🫐', '🍈', '🍒', '🍑', '🥭', '🍍', '🥥', '🥝', '🍅', '🍆', '🥑', '🥦', '🥬', '🥒', '🌶', '🫑', '🌽', '🥕', '🧄', '🧅', '🥔', '🍠', '🥐', '🥯', '🍞', '🥖', '🥨', '🧀', '🥚', '🍳', '🧈', '🥞', '🧇', '🥓', '🥩', '🍗', '🍖', '🦴', '🌭', '🍔', '🍟', '🍕', '🫓', '🥪', '🥙', '🧆', '🌮', '🌯', '🫔', '🥗', '🥘', '🫕', '🥫', '🍝', '🍜', '🍲', '🍛', '🍣', '🍱', '🥟', '🦪', '🍤', '🍙', '🍚', '🍘', '🍥', '🥠', '🥮', '🍡', '🍧', '🍨', '🍦', '🥧', '🧁', '🍰', '🎂', '🍮', '🍭', '🍬', '🍫', '🍿', '🍩', '🍪', '🌰', '🥜', '🫘'],
    
    '⚽ Activities': ['⚽', '🏀', '🏈', '⚾', '🥎', '🎾', '🏐', '🏉', '🥏', '🎯', '🏓', '🏸', '🏒', '🏑', '🥍', '🏏', '🪃', '🥅', '⛳', '🎣', '🤿', '🎽', '🎿', '🛷', '🥌', '🎮', '🕹', '🎰', '🎲', '🧩', '♟', '🎴', '🃏', '🀄️', '🎭', '🖼', '🎨', '🧵', '🪡', '🧶', '🪢'],
    
    '📚 Study': ['📚', '📝', '📖', '📒', '📓', '📔', '📕', '📗', '📘', '📙', '📌', '📍', '✂️', '📏', '📐', '📎', '🖇', '📁', '📂', '🗂', '📅', '📆', '🗒', '🗓', '📇', '📈', '📉', '📊', '📋', '📑', '🗃', '🗄', '🔖', '🏷'],
    
    '😌 Self Care': ['😌', '🧘', '🛀', '💆', '💇', '🚿', '🪞', '💄', '💅', '🫧', '✨', '🌟', '⭐', '🌙', '☀️', '⛅', '🌈', '🌊', '💧', '🌿', '🍃', '🌱', '🌴', '🌸', '🌺', '🌻', '🌞', '🕊', '🧠', '💤'],
    
    '⚠️ Urgent': ['⚠️', '🔴', '🟠', '🟡', '🟢', '🔵', '🟣', '⚫', '⚪', '🟤', '🔔', '📢', '📣', '🚨', '🆘', '🚫', '❌', '⭕', '💢', '🔥', '💥', '💫', '💦', '💨', '🕐', '🕑', '🕒', '🕓', '🕔', '🕕', '🕖', '🕗', '🕘', '🕙', '🕚', '🕛'],
  };

  @override
  void initState() {
    super.initState();
    _loadRecentEmojis();
  }

  Future<void> _loadRecentEmojis() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentEmojis = prefs.getStringList('recent_emojis') ?? widget.initialRecentEmojis;
    });
  }

  Future<void> _saveRecentEmoji(String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recent = List.from(_recentEmojis);
    recent.remove(emoji);
    recent.insert(0, emoji);
    if (recent.length > 20) recent = recent.sublist(0, 20);
    await prefs.setStringList('recent_emojis', recent);
    setState(() => _recentEmojis = recent);
  }

  List<String> _getFilteredEmojis() {
    if (_searchQuery.isEmpty) {
      return _emojiCategories[_selectedCategory] ?? [];
    }
    
    final allEmojis = _emojiCategories.values.expand((list) => list).toList();
    return allEmojis.where((emoji) {
      return emoji.contains(_searchQuery);
    }).toList();
  }

  void _addCustomEmoji() {
    if (_customEmojiController.text.isNotEmpty) {
      final customEmoji = _customEmojiController.text;
      widget.onEmojiSelected(customEmoji);
      _saveRecentEmoji(customEmoji);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
          
          // Custom emoji input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customEmojiController,
                    decoration: InputDecoration(
                      hintText: 'Or paste any emoji...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCustomEmoji,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D3E50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          
          // Recent emojis
          if (_recentEmojis.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.history, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Recently used',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _recentEmojis.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      widget.onEmojiSelected(_recentEmojis[index]);
                      _saveRecentEmoji(_recentEmojis[index]);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: UltimateEmoji(  // ← UPDATED
                          emoji: _recentEmojis[index],
                          size: 30,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search emoji...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Category tabs
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _emojiCategories.keys.length,
              itemBuilder: (context, index) {
                final category = _emojiCategories.keys.elementAt(index);
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2D3E50)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category.split(' ')[0],
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.white : const Color(0xFF2D3E50),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Emoji grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _getFilteredEmojis().length,
              itemBuilder: (context, index) {
                final emoji = _getFilteredEmojis()[index];
                return GestureDetector(
                  onTap: () {
                    widget.onEmojiSelected(emoji);
                    _saveRecentEmoji(emoji);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: UltimateEmoji(  // ← UPDATED
                        emoji: emoji,
                        size: 30,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}