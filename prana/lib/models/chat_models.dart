// lib/models/chat_model.dart
import 'package:cloud_firestore/cloud_firestore.dart'; // ← ADD THIS IMPORT

class ChatModel {
  final String id;
  final List<String> participants;
  final Map<String, String> participantNames;
  final Map<String, String> participantAvatars;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastSenderId;
  final String type;
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

  factory ChatModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatModel(
      id: id,
      participants: List<String>.from(map['participants'] ?? []),
      participantNames: Map<String, String>.from(map['participantNames'] ?? {}),
      participantAvatars: Map<String, String>.from(map['participantAvatars'] ?? {}),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastSenderId: map['lastSenderId'] ?? '',
      type: map['type'] ?? 'private',
      unreadCount: Map<String, int>.from(map['unreadCount'] ?? {}),
      flow: map['flow'] ?? 0,
    );
  }
}