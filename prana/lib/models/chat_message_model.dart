// lib/models/chat_message_model.dart

class ChatMessage {
  final String id;
  final String role;        // 'user' or 'ai'
  final String content;
  final DateTime timestamp;
  final bool isError;       // If AI failed to respond

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.isError = false,
  });

  // For display in UI
  bool get isUser => role == 'user';
  bool get isAI => role == 'ai';

  // Create unique ID
  factory ChatMessage.create({
    required String role,
    required String content,
    bool isError = false,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: role,
      content: content,
      timestamp: DateTime.now(),
      isError: isError,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'isError': isError,
  };

  // Create from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'],
    role: json['role'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    isError: json['isError'] ?? false,
  );
}