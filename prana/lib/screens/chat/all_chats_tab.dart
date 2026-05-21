// lib/screens/chat/all_chat_tab.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'friend_chat_screen.dart';
import 'group_chat_screen.dart';
import 'ai_tab.dart'; // Now this will work

class AllChatTab extends StatelessWidget {
  final String currentUserId;
  final String currentUserDocId;

  const AllChatTab({
    super.key,
    required this.currentUserId,
    required this.currentUserDocId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chats').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allChats = snapshot.data?.docs ?? [];
        
        final userChats = allChats.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final participants = List<String>.from(data['participants'] ?? []);
          return participants.contains(currentUserId);
        }).toList();

        if (userChats.isEmpty) {
          return const Center(
            child: Text(
              'No chats yet',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: userChats.length,
          itemBuilder: (context, index) {
            final chatData = userChats[index].data() as Map<String, dynamic>;
            final chatId = userChats[index].id;
            final participants = List<String>.from(chatData['participants'] ?? []);
            
            final otherUserUid = participants.firstWhere(
              (id) => id != currentUserId,
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
}