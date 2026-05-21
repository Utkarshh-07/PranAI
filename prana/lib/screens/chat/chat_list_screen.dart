// lib/screens/chat/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'friend_chat_screen.dart';
import 'group_chat_screen.dart';
import 'add_friend_screen.dart';
import 'create_group_screen.dart';
import 'ai_tab.dart'; // ✅ Fixed: Added semicolon

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final String currentUserUid = "user1";
  final String currentUserDocId = "user_utkarsh";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E17),
      appBar: AppBar(
        title: const Text('💬 CHATS', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'CHATS'),
            Tab(text: 'FRIENDS'),
            Tab(text: 'GROUPS'),
            Tab(text: 'AI'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFriendScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.group_add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatsTab(),
          _buildFriendsTab(),
          _buildGroupsTab(),
          AiTab(currentUserId: currentUserUid), // ✅ Fixed: Using AiTab (capital A, lowercase i)
        ],
      ),
    );
  }

  Widget _buildChatsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chats').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
          );
        }

        final allChats = snapshot.data?.docs ?? [];
        
        final myChats = allChats.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final participants = List<String>.from(data['participants'] ?? []);
          return participants.contains(currentUserUid);
        }).toList();

        if (myChats.isEmpty) {
          return const Center(
            child: Text(
              'No chats yet',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: myChats.length,
          itemBuilder: (context, index) {
            final chatData = myChats[index].data() as Map<String, dynamic>;
            final chatId = myChats[index].id;
            final participants = List<String>.from(chatData['participants'] ?? []);
            
            final otherUserUid = participants.firstWhere(
              (id) => id != currentUserUid,
              orElse: () => '',
            );

            if (otherUserUid.isEmpty) return const SizedBox.shrink();

            String otherUserDocId;
            if (otherUserUid == 'user2') otherUserDocId = 'user_hardik';
            else if (otherUserUid == 'user3') otherUserDocId = 'user_arya';
            else otherUserDocId = otherUserUid;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(otherUserDocId)
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return const SizedBox.shrink();
                }

                final userData = userSnapshot.data!.data() as Map<String, dynamic>;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(
                      userData['avatar'] ?? '👤',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  title: Text(
                    userData['username'] ?? 'User',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    chatData['lastMessage'] ?? 'Tap to chat',
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                  trailing: Container(
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('⚡', style: TextStyle(fontSize: 12, color: Color(0xFF7C9AFF))),
                        const SizedBox(width: 2),
                        Text(
                          '${userData['flow'] ?? 0}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF7C9AFF), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendChatScreen(
                          chatId: chatId,
                          friendName: userData['username'] ?? 'User',
                          friendAvatar: userData['avatar'] ?? '👤',
                          friendUid: otherUserUid,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFriendsTab() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserDocId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final allUsers = userSnapshot.data?.docs ?? [];
            final otherUsers = allUsers.where((doc) => doc.id != currentUserDocId).toList();

            if (otherUsers.isEmpty) {
              return const Center(
                child: Text(
                  'No other users found',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: otherUsers.length,
              itemBuilder: (context, index) {
                final userDoc = otherUsers[index];
                final userData = userDoc.data() as Map<String, dynamic>;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(
                      userData['avatar'] ?? '👤',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  title: Text(
                    userData['username'] ?? 'User',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    userData['isOnline'] == true ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: userData['isOnline'] == true ? Colors.green : Colors.white.withOpacity(0.5),
                    ),
                  ),
                  trailing: Container(
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('⚡', style: TextStyle(fontSize: 12, color: Color(0xFF7C9AFF))),
                        const SizedBox(width: 2),
                        Text(
                          '${userData['flow'] ?? 0}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF7C9AFF), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    // Check if chat exists
                    final chatQuery = await FirebaseFirestore.instance
                        .collection('chats')
                        .where('participants', arrayContains: currentUserUid)
                        .get();
                    
                    String? chatId;
                    for (var doc in chatQuery.docs) {
                      final data = doc.data();
                      final participants = List<String>.from(data['participants'] ?? []);
                      final otherUid = userData['uid'] ?? 'user2';
                      if (participants.contains(otherUid) && participants.length == 2) {
                        chatId = doc.id;
                        break;
                      }
                    }

                    if (chatId == null) {
                      final newChat = await FirebaseFirestore.instance.collection('chats').add({
                        'participants': [currentUserUid, userData['uid'] ?? 'user2'],
                        'lastMessageTime': FieldValue.serverTimestamp(),
                        'type': 'private',
                      });
                      chatId = newChat.id;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendChatScreen(
                          chatId: chatId!,
                          friendName: userData['username'] ?? 'User',
                          friendAvatar: userData['avatar'] ?? '👤',
                          friendUid: userData['uid'] ?? 'user2',
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGroupsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .where('members', arrayContains: currentUserDocId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
          );
        }

        final groups = snapshot.data?.docs ?? [];

        if (groups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No groups yet',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
                    );
                  },
                  child: const Text('Create Group'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            final groupData = group.data() as Map<String, dynamic>;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  groupData['avatar'] ?? '👥',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              title: Text(
                groupData['name'] ?? 'Group',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${(groupData['members'] as List?)?.length ?? 0} members',
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              trailing: Container(
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 12, color: Color(0xFF7C9AFF))),
                    const SizedBox(width: 2),
                    Text(
                      '${groupData['flow'] ?? 0}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF7C9AFF), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupChatScreen(
                      groupId: group.id,
                      groupName: groupData['name'] ?? 'Group',
                      groupAvatar: groupData['avatar'] ?? '👥',
                      memberCount: (groupData['members'] as List?)?.length ?? 0,
                      groupFlow: groupData['flow'] ?? 0,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}