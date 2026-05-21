// lib/services/friend_request_service.dart (COMPLETE)
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send friend request
  Future<void> sendFriendRequest({
    required String fromUserId,
    required String fromUserDocId,
    required String fromUserName,
    required String fromUserAvatar,
    required String toUserId,
    required String toUserDocId,
    required String toUserName,
    required String toUserAvatar,
  }) async {
    try {
      // Check if already friends
      final existingFriend = await _firestore
          .collection('users')
          .doc(fromUserDocId)
          .collection('friends')
          .doc(toUserDocId)
          .get();

      if (existingFriend.exists) {
        throw Exception('Already friends with this user');
      }

      // Check if request already sent
      final existingRequest = await _firestore
          .collection('friend_requests')
          .where('fromUserId', isEqualTo: fromUserId)
          .where('toUserId', isEqualTo: toUserId)
          .where('status', isEqualTo: 'pending')
          .get();

      if (existingRequest.docs.isNotEmpty) {
        throw Exception('Friend request already sent');
      }

      // Create friend request
      await _firestore.collection('friend_requests').add({
        'fromUserId': fromUserId,
        'fromUserDocId': fromUserDocId,
        'fromUserName': fromUserName,
        'fromUserAvatar': fromUserAvatar,
        'toUserId': toUserId,
        'toUserDocId': toUserDocId,
        'toUserName': toUserName,
        'toUserAvatar': toUserAvatar,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Add to user's pending requests
      await _firestore
          .collection('users')
          .doc(toUserDocId)
          .collection('pending_requests')
          .doc(fromUserDocId)
          .set({
        'fromUserId': fromUserId,
        'fromUserName': fromUserName,
        'fromUserAvatar': fromUserAvatar,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('✅ Friend request sent to $toUserName');
    } catch (e) {
      print('❌ Error sending friend request: $e');
      rethrow;
    }
  }

  // Accept friend request
  Future<void> acceptFriendRequest({
    required String requestId,
    required String fromUserDocId,
    required String toUserDocId,
    required String fromUserName,
    required String fromUserAvatar,
    required String toUserName,
    required String toUserAvatar,
    required String fromUserId,
    required String toUserId,
  }) async {
    try {
      // Update request status
      await _firestore.collection('friend_requests').doc(requestId).update({
        'status': 'accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      // Create chat document
      final chatId = 'chat_${fromUserDocId}_${toUserDocId}';
      await _firestore.collection('chats').doc(chatId).set({
        'participants': [fromUserId, toUserId],
        'participantNames': {
          fromUserId: fromUserName,
          toUserId: toUserName,
        },
        'participantAvatars': {
          fromUserId: fromUserAvatar,
          toUserId: toUserAvatar,
        },
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'type': 'private',
        'unreadCount': {
          fromUserId: 0,
          toUserId: 0,
        },
        'flow': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Add to sender's friends
      await _firestore
          .collection('users')
          .doc(fromUserDocId)
          .collection('friends')
          .doc(toUserDocId)
          .set({
        'friendId': toUserId,
        'friendDocId': toUserDocId,
        'friendName': toUserName,
        'friendAvatar': toUserAvatar,
        'status': 'accepted',
        'since': FieldValue.serverTimestamp(),
        'chatId': chatId,
        'flow': 0,
      });

      // Add to receiver's friends
      await _firestore
          .collection('users')
          .doc(toUserDocId)
          .collection('friends')
          .doc(fromUserDocId)
          .set({
        'friendId': fromUserId,
        'friendDocId': fromUserDocId,
        'friendName': fromUserName,
        'friendAvatar': fromUserAvatar,
        'status': 'accepted',
        'since': FieldValue.serverTimestamp(),
        'chatId': chatId,
        'flow': 0,
      });

      // Remove from pending requests
      await _firestore
          .collection('users')
          .doc(toUserDocId)
          .collection('pending_requests')
          .doc(fromUserDocId)
          .delete();

      print('✅ Friend request accepted!');
    } catch (e) {
      print('❌ Error accepting friend request: $e');
      rethrow;
    }
  }

  // Reject friend request
  Future<void> rejectFriendRequest({
    required String requestId,
    required String fromUserDocId,
    required String toUserDocId,
  }) async {
    try {
      // Update request status
      await _firestore.collection('friend_requests').doc(requestId).update({
        'status': 'rejected',
        'rejectedAt': FieldValue.serverTimestamp(),
      });

      // Remove from pending requests
      await _firestore
          .collection('users')
          .doc(toUserDocId)
          .collection('pending_requests')
          .doc(fromUserDocId)
          .delete();

      print('✅ Friend request rejected');
    } catch (e) {
      print('❌ Error rejecting friend request: $e');
      rethrow;
    }
  }

  // Get pending friend requests for a user
  Stream<List<Map<String, dynamic>>> getPendingRequests(String userDocId) {
    return _firestore
        .collection('friend_requests')
        .where('toUserDocId', isEqualTo: userDocId)
        .where('status', isEqualTo: 'pending')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Get friends list with real-time updates
  Stream<List<Map<String, dynamic>>> getFriends(String userDocId) {
    return _firestore
        .collection('users')
        .doc(userDocId)
        .collection('friends')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Remove friend
  Future<void> removeFriend({
    required String userDocId,
    required String friendDocId,
    required String chatId,
  }) async {
    try {
      // Remove from user's friends
      await _firestore
          .collection('users')
          .doc(userDocId)
          .collection('friends')
          .doc(friendDocId)
          .delete();

      // Remove from friend's friends
      await _firestore
          .collection('users')
          .doc(friendDocId)
          .collection('friends')
          .doc(userDocId)
          .delete();

      // Optionally delete or archive chat
      await _firestore.collection('chats').doc(chatId).update({
        'isArchived': true,
        'archivedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Friend removed');
    } catch (e) {
      print('❌ Error removing friend: $e');
      rethrow;
    }
  }

  // Get friend request count
  Stream<int> getPendingRequestCount(String userDocId) {
    return _firestore
        .collection('friend_requests')
        .where('toUserDocId', isEqualTo: userDocId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}