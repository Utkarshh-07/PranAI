// lib/screens/test_firebase_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestFirebaseScreen extends StatefulWidget {
  const TestFirebaseScreen({super.key});

  @override
  State<TestFirebaseScreen> createState() => _TestFirebaseScreenState();
}

class _TestFirebaseScreenState extends State<TestFirebaseScreen> {
  bool _isLoading = false;
  String _testResult = '';
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _friends = [];

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Testing Firebase connection...';
    });

    try {
      // Test 1: Check if Firestore is accessible
      await FirebaseFirestore.instance.collection('test').doc('test').get();
      
      // Test 2: Fetch all users
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      _users = usersSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // Test 3: Fetch all chats
      final chatsSnapshot = await FirebaseFirestore.instance.collection('chats').get();
      _chats = chatsSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // Test 4: Fetch messages from first chat (if exists)
      if (_chats.isNotEmpty) {
        final messagesSnapshot = await FirebaseFirestore.instance
            .collection('chats')
            .doc(_chats.first['id'])
            .collection('messages')
            .limit(5)
            .get();
        _messages = messagesSnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      }

      // Test 5: Check friends subcollection for user1
      final friendsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('user_utkarsh')
          .collection('friends')
          .get();
      _friends = friendsSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      setState(() {
        _isLoading = false;
        _testResult = '✅ Firebase connected successfully!\n'
            'Found ${_users.length} users, ${_chats.length} chats, '
            '${_messages.length} messages, ${_friends.length} friends.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _testResult = '❌ Firebase connection failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E17),
      appBar: AppBar(
        title: const Text(
          'Firebase Test',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _testConnection,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Testing Firebase connection...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connection Status
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1F2F),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _testResult.contains('✅')
                            ? Colors.green.withOpacity(0.3)
                            : Colors.red.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _testResult,
                      style: TextStyle(
                        color: _testResult.contains('✅')
                            ? Colors.green
                            : Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Users Section
                  _buildSectionTitle('USERS (${_users.length})'),
                  const SizedBox(height: 8),
                  ..._users.map((user) => _buildUserCard(user)).toList(),
                  
                  const SizedBox(height: 20),
                  
                  // Chats Section
                  _buildSectionTitle('CHATS (${_chats.length})'),
                  const SizedBox(height: 8),
                  ..._chats.map((chat) => _buildChatCard(chat)).toList(),
                  
                  const SizedBox(height: 20),
                  
                  // Messages Section
                  if (_messages.isNotEmpty) ...[
                    _buildSectionTitle('MESSAGES (${_messages.length})'),
                    const SizedBox(height: 8),
                    ..._messages.map((msg) => _buildMessageCard(msg)).toList(),
                  ],
                  
                  const SizedBox(height: 20),
                  
                  // Friends Section
                  if (_friends.isNotEmpty) ...[
                    _buildSectionTitle('FRIENDS (${_friends.length})'),
                    const SizedBox(height: 8),
                    ..._friends.map((friend) => _buildFriendCard(friend)).toList(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF7C9AFF),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user['avatar'] ?? '👤',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['username'] ?? 'No name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ID: ${user['uid']}',
                      style: const TextStyle(
                        color: Color(0xFF9AA8C7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF7C9AFF).withOpacity(0.2),
                      const Color(0xFF6C5CE7).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 12, color: Color(0xFF7C9AFF))),
                    const SizedBox(width: 2),
                    Text(
                      '${user['flow'] ?? 0}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7C9AFF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (user['email'] != null) ...[
            const SizedBox(height: 8),
            Text(
              '📧 ${user['email']}',
              style: const TextStyle(color: Color(0xFF9AA8C7), fontSize: 12),
            ),
          ],
          Text(
            '📱 ${user['isOnline'] == true ? 'Online' : 'Offline'}',
            style: TextStyle(
              color: user['isOnline'] == true ? const Color(0xFF7C9AFF) : const Color(0xFF9AA8C7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatCard(Map<String, dynamic> chat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chat ID: ${chat['id']}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Type: ${chat['type'] ?? 'private'}',
            style: const TextStyle(color: Color(0xFF9AA8C7), fontSize: 12),
          ),
          Text(
            'Participants: ${(chat['participants'] as List?)?.join(', ') ?? 'none'}',
            style: const TextStyle(color: Color(0xFF9AA8C7), fontSize: 12),
          ),
          if (chat['lastMessage'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Last: ${chat['lastMessage']}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF7C9AFF).withOpacity(0.2),
                      const Color(0xFF6C5CE7).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 10, color: Color(0xFF7C9AFF))),
                    const SizedBox(width: 2),
                    Text(
                      '${chat['flow'] ?? 0}',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF7C9AFF)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    msg['senderAvatar'] ?? '👤',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      msg['senderName'] ?? 'Unknown',
                      style: const TextStyle(
                        color: Color(0xFF7C9AFF),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      msg['text'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                _formatTime(msg['timestamp']),
                style: const TextStyle(color: Color(0xFF9AA8C7), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFriendCard(Map<String, dynamic> friend) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                friend['friendAvatar'] ?? '👤',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend['friendName'] ?? 'Unknown',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Status: ${friend['status']}',
                  style: const TextStyle(color: Color(0xFF9AA8C7), fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(friend['since']),
            style: const TextStyle(color: Color(0xFF9AA8C7), fontSize: 10),
          ),
        ],
      ),
    );
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      final date = (timestamp as Timestamp).toDate();
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      final date = (timestamp as Timestamp).toDate();
      return '${date.day}/${date.month}';
    } catch (e) {
      return '';
    }
  }
}