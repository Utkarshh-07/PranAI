// lib/models/message_model.dart
import 'package:cloud_firestore/cloud_firestore.dart'; // ← ADD THIS IMPORT

class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String text;
  final DateTime timestamp;
  final String type;
  final List<String> readBy;
  final Map<String, dynamic>? metadata;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.text,
    required this.timestamp,
    required this.type,
    required this.readBy,
    this.metadata,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderAvatar: map['senderAvatar'] ?? '👤',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: map['type'] ?? 'text',
      readBy: List<String>.from(map['readBy'] ?? []),
      metadata: map['metadata'],
    );
  }

  bool isReadBy(String userId) {
    return readBy.contains(userId);
  }
}