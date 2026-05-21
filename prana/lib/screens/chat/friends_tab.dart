// lib/screens/chat/friends_tab.dart (COMPLETE)
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_friend_screen.dart';
import 'friend_profile_screen.dart';
import 'friend_chat_screen.dart';
import '../../services/friend_request_service.dart';

class FriendsTab extends StatefulWidget {
  final String currentUserId;
  final String currentUserDocId;

  const FriendsTab({
    super.key,
    required this.currentUserId,
    required this.currentUserDocId,
  });

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  final FriendRequestService _friendService = FriendRequestService();
  int _pendingCount = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A0F1E),
      child: Column(
        children: [
          // Header Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddFriendScreen(),
                        ),
                      );
                      if (result == true && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Friend request sent!')),
                        );
                      }
                    },
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('ADD FRIEND'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A80F0),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Pending Requests Badge
                StreamBuilder<int>(
                  stream: _friendService.getPendingRequestCount(widget.currentUserDocId),
                  builder: (context, snapshot) {
                    _pendingCount = snapshot.data ?? 0;
                    return Stack(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showPendingRequests(context),
                          icon: const Icon(Icons.notifications_none, size: 18),
                          label: const Text('REQUESTS'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1F2F),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(100, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        if (_pendingCount > 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                '$_pendingCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // Friends List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _friendService.getFriends(widget.currentUserDocId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final friends = snapshot.data ?? [];

                if (friends.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '👥',
                          style: TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No friends yet',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddFriendScreen(),
                              ),
                            );
                          },
                          child: const Text('Add your first friend'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return _buildFriendItem(context, friend);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendItem(BuildContext context, Map<String, dynamic> friend) {
    // Get online status from Firestore
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(friend['friendDocId'])
          .snapshots(),
      builder: (context, userSnapshot) {
        bool isOnline = false;
        String lastActive = 'Offline';
        
        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
          isOnline = userData['isOnline'] ?? false;
          final lastActiveTime = userData['lastActive']?.toDate();
          if (lastActiveTime != null && !isOnline) {
            final diff = DateTime.now().difference(lastActiveTime);
            if (diff.inMinutes < 60) {
              lastActive = '${diff.inMinutes}m ago';
            } else if (diff.inHours < 24) {
              lastActive = '${diff.inHours}h ago';
            } else {
              lastActive = '${diff.inDays}d ago';
            }
          }
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendChatScreen(
                    chatId: friend['chatId'],
                    friendName: friend['friendName'],
                    friendAvatar: friend['friendAvatar'],
                    friendUid: friend['friendId'],
                  ),
                ),
              );
            },
            onLongPress: () => _showFriendOptions(context, friend),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F2F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Avatar with online indicator
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Color(0xFFFF69B4),
                                Color(0xFF7B68EE),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              friend['friendAvatar'] ?? '👤',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isOnline ? const Color(0xFF4CAF50) : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF1A1F2F), width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          friend['friendName'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isOnline ? 'Online' : lastActive,
                          style: TextStyle(
                            fontSize: 13,
                            color: isOnline 
                                ? const Color(0xFF4CAF50) 
                                : Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Streak & Actions
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Flow streak
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFF69B4).withOpacity(0.2),
                                const Color(0xFF7B68EE).withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '⚡',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${friend['flow'] ?? 0}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF69B4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Chat button
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A80F0).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.chat_bubble_outline, size: 18),
                            color: const Color(0xFF4A80F0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FriendChatScreen(
                                    chatId: friend['chatId'],
                                    friendName: friend['friendName'],
                                    friendAvatar: friend['friendAvatar'],
                                    friendUid: friend['friendId'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPendingRequests(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F2F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Friend Requests',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(color: Colors.white24),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _friendService.getPendingRequests(widget.currentUserDocId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final requests = snapshot.data ?? [];

                      if (requests.isEmpty) {
                        return const Center(
                          child: Text(
                            'No pending requests',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final request = requests[index];
                          return _buildRequestItem(context, request);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRequestItem(BuildContext context, Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                request['fromUserAvatar'] ?? '👤',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['fromUserName'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'wants to be your friend',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                onPressed: () async {
                  await _friendService.acceptFriendRequest(
                    requestId: request['id'],
                    fromUserDocId: request['fromUserDocId'],
                    toUserDocId: widget.currentUserDocId,
                    fromUserName: request['fromUserName'],
                    fromUserAvatar: request['fromUserAvatar'],
                    toUserName: 'Me', // Get from auth
                    toUserAvatar: '💗', // Get from auth
                    fromUserId: request['fromUserId'],
                    toUserId: widget.currentUserId,
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Friend added!')),
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () async {
                  await _friendService.rejectFriendRequest(
                    requestId: request['id'],
                    fromUserDocId: request['fromUserDocId'],
                    toUserDocId: widget.currentUserDocId,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request rejected')),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFriendOptions(BuildContext context, Map<String, dynamic> friend) {
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
                leading: const Icon(Icons.person_outline, color: Colors.white),
                title: const Text('View Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendProfileScreen(
                        friendName: friend['friendName'],
                        friendAvatar: friend['friendAvatar'],
                        streak: friend['flow'] ?? 0,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Remove Friend', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context);
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1A1F2F),
                      title: const Text('Remove Friend?', style: TextStyle(color: Colors.white)),
                      content: Text(
                        'Are you sure you want to remove ${friend['friendName']} from your friends?',
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Remove', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirmed == true) {
                    await _friendService.removeFriend(
                      userDocId: widget.currentUserDocId,
                      friendDocId: friend['friendDocId'],
                      chatId: friend['chatId'],
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${friend['friendName']} removed')),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}