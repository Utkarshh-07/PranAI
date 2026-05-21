// lib/models/group_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String avatar;
  final String createdBy;
  final List<String> admins;
  final List<String> members;
  final Map<String, String> memberNames;
  final Map<String, String> memberAvatars;
  final int flow;
  final DateTime createdAt;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? lastSenderId;

  GroupModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.createdBy,
    required this.admins,
    required this.members,
    required this.memberNames,
    required this.memberAvatars,
    required this.flow,
    required this.createdAt,
    this.lastMessage,
    this.lastMessageTime,
    this.lastSenderId,
  });

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GroupModel(
      id: doc.id,
      name: data['name'] ?? '',
      avatar: data['avatar'] ?? '👥',
      createdBy: data['createdBy'] ?? '',
      admins: List<String>.from(data['admins'] ?? []),
      members: List<String>.from(data['members'] ?? []),
      memberNames: Map<String, String>.from(data['memberNames'] ?? {}),
      memberAvatars: Map<String, String>.from(data['memberAvatars'] ?? {}),
      flow: data['flow'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessage: data['lastMessage'],
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate(),
      lastSenderId: data['lastSenderId'],
    );
  }
}