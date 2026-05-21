// lib/services/group_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get groups for a user
  Stream<List<Map<String, dynamic>>> getGroups(String userId) {
    return _firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  // Create a new group
  Future<String> createGroup({
    required String name,
    required String createdBy,
    required List<String> members,
    required Map<String, String> memberNames,
    required Map<String, String> memberAvatars,
  }) async {
    final groupRef = await _firestore.collection('groups').add({
      'name': name,
      'avatar': '👥',
      'createdBy': createdBy,
      'admins': [createdBy],
      'members': members,
      'memberNames': memberNames,
      'memberAvatars': memberAvatars,
      'flow': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastMessageTime': null,
      'lastSenderId': '',
    });

    return groupRef.id;
  }

  // Add member to group
  Future<void> addMemberToGroup(String groupId, String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final userData = userDoc.data() ?? {};

    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
      'memberNames.$userId': userData['username'] ?? 'User',
      'memberAvatars.$userId': userData['avatar'] ?? '👤',
    });
  }

  // Remove member from group
  Future<void> removeMemberFromGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayRemove([userId]),
    });
  }

  // Get group messages
  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Send message to group
  Future<void> sendGroupMessage({
    required String groupId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String text,
  }) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
      'readBy': [senderId],
    });

    // Update last message in group
    await _firestore.collection('groups').doc(groupId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastSenderId': senderId,
    });
  }
}