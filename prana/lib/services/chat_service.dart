// lib/services/chat_service.dart (FIXED - Using whereNotIn)
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChats() {
    return _firestore.collection('chats').snapshots();
  }

  Future<String> getOrCreateChat(String userId1, String userId2) async {
    final snapshot = await _firestore.collection('chats').get();
    
    for (var doc in snapshot.docs) {
      final participants = List<String>.from(doc.data()['participants'] ?? []);
      if (participants.contains(userId1) && participants.contains(userId2)) {
        return doc.id;
      }
    }

    final newChat = await _firestore.collection('chats').add({
      'participants': [userId1, userId2],
      'lastMessageTime': FieldValue.serverTimestamp(),
      'type': 'private',
      'unreadCount': {userId1: 0, userId2: 0},
    });

    return newChat.id;
  }

  Future<void> updateLastMessage(String chatId, String message, String senderId) async {
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastSenderId': senderId,
    });
  }

  // ========== READ RECEIPTS EXTENSIONS ==========
  
  // Mark message as delivered
  Future<void> markAsDelivered(String chatId, String messageId, String userId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
        'deliveredTo': FieldValue.arrayUnion([userId]),
      });
      print('✅ Message marked as delivered for user: $userId');
    } catch (e) {
      print('❌ Error marking message as delivered: $e');
    }
  }

  // Mark message as read
  Future<void> markAsRead(String chatId, String messageId, String userId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
        'readBy': FieldValue.arrayUnion([userId]),
      });
      print('✅ Message marked as read for user: $userId');
    } catch (e) {
      print('❌ Error marking message as read: $e');
    }
  }

  // Mark all messages in chat as read
  Future<void> markAllAsRead(String chatId, String userId) async {
    try {
      // Get all messages where readBy does NOT contain userId
      final messages = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      final batch = _firestore.batch();
      for (var doc in messages.docs) {
        final data = doc.data();
        final readBy = List<String>.from(data['readBy'] ?? []);
        if (!readBy.contains(userId)) {
          batch.update(doc.reference, {
            'readBy': FieldValue.arrayUnion([userId]),
          });
        }
      }
      await batch.commit();

      // Update unread count
      await _firestore.collection('chats').doc(chatId).update({
        'unreadCount.$userId': 0,
      });
      
      print('✅ Marked messages as read for user: $userId');
    } catch (e) {
      print('❌ Error marking all messages as read: $e');
    }
  }

  // Get unread count for user
  Stream<int> getUnreadCount(String chatId, String userId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((doc) {
      final data = doc.data();
      if (data != null && data.containsKey('unreadCount')) {
        final unreadMap = data['unreadCount'] as Map<String, dynamic>;
        final count = unreadMap[userId];
        if (count is int) return count;
        if (count is num) return count.toInt();
        return 0;
      }
      return 0;
    });
  }

  // Get total unread count across all chats
  Stream<int> getTotalUnreadCount(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          int total = 0;
          for (var doc in snapshot.docs) {
            final data = doc.data();
            if (data.containsKey('unreadCount')) {
              final unreadMap = data['unreadCount'] as Map<String, dynamic>;
              final count = unreadMap[userId];
              if (count is int) {
                total += count;
              } else if (count is num) {
                total += count.toInt();
              }
            }
          }
          return total;
        });
  }

  // Send message with read receipt support
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String text,
    String type = 'text',
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Get chat data to find other participants
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();
      final chatData = chatDoc.data();
      if (chatData == null) throw Exception('Chat not found');
      
      final participants = List<String>.from(chatData['participants'] ?? []);
      final otherParticipants = participants.where((id) => id != senderId).toList();
      
      // Create message
      final messageRef = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': senderId,
        'senderName': senderName,
        'senderAvatar': senderAvatar,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'type': type,
        'readBy': [senderId], // Sender has read their own message
        'deliveredTo': [senderId],
        'metadata': metadata ?? {},
      });
      
      // Update chat document
      final updates = {
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastSenderId': senderId,
      };
      
      // Increment unread count for other participants
      for (var participant in otherParticipants) {
        updates['unreadCount.$participant'] = FieldValue.increment(1);
      }
      
      await _firestore.collection('chats').doc(chatId).update(updates);
      
      print('✅ Message sent successfully: ${messageRef.id}');
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
  }

  // Stream messages with read status
  Stream<List<Map<String, dynamic>>> getMessages(String chatId, String currentUserId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            
            // Add receipt status for current user
            final readBy = List<String>.from(data['readBy'] ?? []);
            final deliveredTo = List<String>.from(data['deliveredTo'] ?? []);
            
            data['isRead'] = readBy.contains(currentUserId);
            data['isDelivered'] = deliveredTo.contains(currentUserId);
            
            // For messages sent by others, mark as read automatically
            if (data['senderId'] != currentUserId && !data['isRead']) {
              // Don't await to avoid blocking
              markAsRead(chatId, doc.id, currentUserId);
            }
            
            return data;
          }).toList();
        });
  }
}