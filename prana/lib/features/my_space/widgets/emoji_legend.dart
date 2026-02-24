// lib/features/my_space/widgets/emoji_legend.dart (RESPONSIVE)
import 'package:flutter/material.dart';
import '../theme/card_styles.dart';
import '../../../widgets/ultimate_emoji.dart';

class EmojiLegend extends StatefulWidget {
  final bool isTablet;

  const EmojiLegend({super.key, this.isTablet = false});

  @override
  State<EmojiLegend> createState() => _EmojiLegendState();
}

class _EmojiLegendState extends State<EmojiLegend> {
  bool _isExpanded = true;

  final List<Map<String, String>> _emojiCategories = const [
    {'emoji': '📚', 'name': 'Study'},
    {'emoji': '📝', 'name': 'Exam'},
    {'emoji': '📋', 'name': 'Assignment'},
    {'emoji': '🎉', 'name': 'Celebration'},
    {'emoji': '🍿', 'name': 'Movie'},
    {'emoji': '🎮', 'name': 'Gaming'},
    {'emoji': '👪', 'name': 'Family'},
    {'emoji': '😌', 'name': 'Self-care'},
    {'emoji': '🌊', 'name': 'PranAI'},
    {'emoji': '🫂', 'name': 'Therapy'},
    {'emoji': '💕', 'name': 'Date'},
    {'emoji': '🏥', 'name': 'Doctor'},
    {'emoji': '💪', 'name': 'Gym'},
    {'emoji': '😴', 'name': 'Rest'},
    {'emoji': '⚠️', 'name': 'Urgent'},
    {'emoji': '🔴', 'name': 'High Priority'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2D3E50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('📖', style: TextStyle(fontSize: 20)),
          ),
          title: Text(
            'EMOJI LEGEND',
            style: TextStyle(
              fontSize: widget.isTablet ? 18 : 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3E50),
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: const Color(0xFF2D3E50),
            ),
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
          ),
        ),
        
        // Expanded content
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Emoji grid - Responsive
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 800 ? 6 : 4;
                    
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _emojiCategories.length,
                      itemBuilder: (context, index) {
                        final item = _emojiCategories[index];
                        return GestureDetector(
                          onTap: () => _showEmojiInfo(context, item),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D3E50).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF2D3E50).withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UltimateEmoji(
                                  emoji: item['emoji']!,
                                  size: widget.isTablet ? 28 : 24,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['name']!,
                                  style: TextStyle(
                                    fontSize: widget.isTablet ? 12 : 10,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF2D3E50),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Custom emoji button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Custom emoji feature coming soon!'),
                          backgroundColor: Color(0xFFB4A7F5),
                        ),
                      );
                    },
                    style: CardStyles.secondaryButton,
                    child: Text(
                      '+ ADD CUSTOM EMOJI',
                      style: TextStyle(
                        fontSize: widget.isTablet ? 14 : 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showEmojiInfo(BuildContext context, Map<String, String> emoji) {
    String emojiChar = emoji['emoji'] ?? '📝';
    String emojiName = emoji['name'] ?? 'Event';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            UltimateEmoji(emoji: emojiChar, size: 32),
            const SizedBox(width: 12),
            Text(emojiName),
          ],
        ),
        content: Text('Used for $emojiName activities'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}