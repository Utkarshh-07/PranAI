// lib/screens/chat/friend_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/chat_service.dart';

class FriendChatScreen extends StatefulWidget {
  final String chatId;
  final String friendName;
  final String friendAvatar;
  final String friendUid;

  const FriendChatScreen({
    super.key,
    required this.chatId,
    required this.friendName,
    required this.friendAvatar,
    required this.friendUid,
  });

  @override
  State<FriendChatScreen> createState() => _FriendChatScreenState();
}

class _FriendChatScreenState extends State<FriendChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final String currentUserId = "user1";
  final String currentUserName = "Utkarsh";
  final String currentUserAvatar = "💗";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _markAllMessagesAsRead();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _markAllMessagesAsRead() async {
    await _chatService.markAllAsRead(widget.chatId, currentUserId);
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    await _chatService.sendMessage(
      chatId: widget.chatId,
      senderId: currentUserId,
      senderName: currentUserName,
      senderAvatar: currentUserAvatar,
      text: messageText,
    );

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isMe) {
    final timestamp = (message['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    final timeString = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    
    // Get read receipt status
    final readBy = List<String>.from(message['readBy'] ?? []);
    final deliveredTo = List<String>.from(message['deliveredTo'] ?? []);
    final isRead = readBy.contains(widget.friendUid);
    final isDelivered = deliveredTo.contains(widget.friendUid);
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender name (only for non-me messages)
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  widget.friendName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            
            // Message bubble
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: isMe
                    ? const LinearGradient(
                        colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFF1A1F2F), Color(0xFF1A1F2F)],
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message['text'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeString,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        // Single tick (sent)
                        if (!isDelivered && !isRead)
                          Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        // Double tick (delivered)
                        if (isDelivered && !isRead)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ],
                          ),
                        // Blue double tick (read)
                        if (isRead)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                size: 12,
                                color: const Color(0xFF4A80F0),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.check,
                                size: 12,
                                color: const Color(0xFF4A80F0),
                              ),
                            ],
                          ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.friendAvatar,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friendName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Online status
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.friendUid == 'user2' ? 'user_hardik' : 'user_arya')
                      .snapshots(),
                  builder: (context, snapshot) {
                    bool isOnline = false;
                    if (snapshot.hasData && snapshot.data!.exists) {
                      final data = snapshot.data!.data() as Map<String, dynamic>;
                      isOnline = data['isOnline'] ?? false;
                    }
                    return Text(
                      isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 12,
                        color: isOnline ? const Color(0xFF4CAF50) : Colors.white.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFF69B4),
                Color(0xFF7B68EE),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF1A1F2F),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person, color: Colors.white),
                          title: const Text('View Profile', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.pop(context);
                            // Navigate to profile
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.block, color: Colors.red),
                          title: const Text('Block User', style: TextStyle(color: Colors.red)),
                          onTap: () {
                            Navigator.pop(context);
                            _showBlockDialog();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text('Delete Chat', style: TextStyle(color: Colors.red)),
                          onTap: () {
                            Navigator.pop(context);
                            _showDeleteDialog();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatService.getMessages(widget.chatId, currentUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.friendAvatar,
                          style: const TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Say hello to ${widget.friendName}!',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == currentUserId;
                    return _buildMessageBubble(message, isMe);
                  },
                );
              },
            ),
          ),
          
          // Typing indicator (optional)
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(widget.chatId)
                .collection('typing')
                .where('userId', isEqualTo: widget.friendUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '${widget.friendName} is typing...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Message Input
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F2F),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions, color: Colors.white70),
                    onPressed: () {
                      // Show emoji picker
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Message ${widget.friendName}...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                    onPressed: _sendMessage,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2F),
        title: const Text('Block User?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to block ${widget.friendName}? You won\'t receive messages from them.',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement block functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User blocked')),
              );
              Navigator.pop(context); // Go back to chat hub
            },
            child: const Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2F),
        title: const Text('Delete Chat?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete this conversation? This action cannot be undone.',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Delete chat messages
              final messages = await FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .get();
              
              final batch = FirebaseFirestore.instance.batch();
              for (var doc in messages.docs) {
                batch.delete(doc.reference);
              }
              await batch.commit();
              
              // Reset chat document
              await FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
                'lastMessage': '',
                'unreadCount.${widget.friendUid}': 0,
                'unreadCount.$currentUserId': 0,
              });
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat deleted')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}