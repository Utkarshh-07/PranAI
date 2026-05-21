// lib/models/ai_friend_model.dart

class AIFriend {
  final String id;
  final String name;           // Default name (Alex, Jordan, etc.)
  String customName;            // User can rename
  final String systemPrompt;    // Personality instructions
  final String description;     // Short description
  final String avatarColor;     // Color for UI
  bool isSelected;              // Currently selected friend

  AIFriend({
    required this.id,
    required this.name,
    this.customName = '',
    required this.systemPrompt,
    required this.description,
    required this.avatarColor,
    this.isSelected = false,
  });

  // Get display name (custom name if set, otherwise default)
  String get displayName => customName.isNotEmpty ? customName : name;

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'customName': customName,
    'systemPrompt': systemPrompt,
    'description': description,
    'avatarColor': avatarColor,
    'isSelected': isSelected,
  };

  // Create from JSON
  factory AIFriend.fromJson(Map<String, dynamic> json) => AIFriend(
    id: json['id'],
    name: json['name'],
    customName: json['customName'] ?? '',
    systemPrompt: json['systemPrompt'],
    description: json['description'],
    avatarColor: json['avatarColor'],
    isSelected: json['isSelected'] ?? false,
  );

  // Copy with modifications
  AIFriend copyWith({
    String? customName,
    bool? isSelected,
  }) {
    return AIFriend(
      id: id,
      name: name,
      customName: customName ?? this.customName,
      systemPrompt: systemPrompt,
      description: description,
      avatarColor: avatarColor,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}