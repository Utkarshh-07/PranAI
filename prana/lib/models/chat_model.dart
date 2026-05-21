// lib/models/chat_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatType {
  private,
  group,
}

class ChatModel {
  final String id;
  final List<String> participants;
  final Map<String, String> participantNames;
  final Map<String, String> participantAvatars;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastSenderId;
  final ChatType type;
  final Map<String, int> unreadCount;
  final int flow;

  ChatModel({
    required this.id,
    required this.participants,
    required this.participantNames,
    required this.participantAvatars,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastSenderId,
    required this.type,
    required this.unreadCount,
    required this.flow,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      participantNames: Map<String, String>.from(data['participantNames'] ?? {}),
      participantAvatars: Map<String, String>.from(data['participantAvatars'] ?? {}),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastSenderId: data['lastSenderId'] ?? '',
      type: data['type'] == 'group' ? ChatType.group : ChatType.private,
      unreadCount: Map<String, int>.from(data['unreadCount'] ?? {}),
      flow: data['flow'] ?? 0,
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String text;
  final DateTime timestamp;
  final String type; // 'text', 'achievement', 'gift', 'cheer', 'file'
  final List<String> readBy;
  final Map<String, dynamic>? metadata;

  ChatMessage({
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

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      senderAvatar: data['senderAvatar'] ?? '👤',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: data['type'] ?? 'text',
      readBy: List<String>.from(data['readBy'] ?? []),
      metadata: data['metadata'],
    );
  }
}