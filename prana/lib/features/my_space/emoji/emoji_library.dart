// lib/features/my_space/emoji/emoji_library.dart
class EmojiLibrary {
  static const List<Map<String, String>> categories = [
    {
      'name': 'Study',
      'emojis': '📚,📝,✏️,📖,🔬,🧪,📊,💻,🧮,🌐',
    },
    {
      'name': 'Self Care',
      'emojis': '😌,🧘,🛀,💆,💪,🥗,💤,🧠,🌿,🕊️',
    },
    {
      'name': 'Fun',
      'emojis': '🎮,🎬,🎵,🎨,⚽,🏀,🎉,🍿,🎂,🎪',
    },
    {
      'name': 'Social',
      'emojis': '👪,🤝,💬,📱,🎭,🎤,👥,💕,🤗,🌊',
    },
    {
      'name': 'Ocean',
      'emojis': '🌊,🐚,🐠,🐬,🐳,🦀,🐙,🏝️,⛵,🌅',
    },
  ];

  static List<String> getAllEmojis() {
    List<String> all = [];
    for (var category in categories) {
      all.addAll(category['emojis']!.split(', '));
    }
    return all;
  }

  static List<String> getEmojisByCategory(String categoryName) {
    for (var category in categories) {
      if (category['name'] == categoryName) {
        return category['emojis']!.split(', ');
      }
    }
    return [];
  }
}