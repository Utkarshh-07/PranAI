// lib/screens/chat/group_feed_screen.dart
import 'package:flutter/material.dart';

class GroupFeedScreen extends StatelessWidget {
  final String groupName;
  final String groupAvatar;
  final int memberCount;
  final int streak;

  const GroupFeedScreen({
    super.key,
    required this.groupName,
    required this.groupAvatar,
    required this.memberCount,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
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
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF0A0F1E),
        child: SafeArea(
          child: Column(
            children: [
              // Group Header
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
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
                          groupAvatar,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            groupName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '$memberCount members',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFFF69B4).withOpacity(0.2),
                                      const Color(0xFF7B68EE).withOpacity(0.2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      '🔥',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '$streak',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFFF69B4),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Feed
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'GROUP FEED',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFeedItem(
                      avatar: '🕊️',
                      name: 'Riya',
                      emoji: '👑',
                      achievement: 'Crown Shell',
                      time: '2h ago',
                    ),
                    const SizedBox(height: 8),
                    _buildFeedItem(
                      avatar: '📚',
                      name: 'Rahul',
                      emoji: '✨',
                      achievement: 'Golden Shell',
                      time: '5h ago',
                    ),
                    const SizedBox(height: 8),
                    _buildFeedItem(
                      avatar: '🎮',
                      name: 'Aarav',
                      emoji: '🐚',
                      achievement: 'Calm Shell',
                      time: '8h ago',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedItem({
    required String avatar,
    required String name,
    required String emoji,
    required String achievement,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFFF69B4),
                  Color(0xFF7B68EE),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                avatar,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      achievement,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}