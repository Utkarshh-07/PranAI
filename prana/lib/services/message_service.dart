// lib/services/message_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String text,
  }) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
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
  }
}