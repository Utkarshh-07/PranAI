// lib/screens/chat/group_info_screen.dart
import 'package:flutter/material.dart';

class GroupInfoScreen extends StatelessWidget {
  final String groupName;
  final String groupAvatar;
  final int memberCount;
  final int groupFlow;

  const GroupInfoScreen({
    super.key,
    required this.groupName,
    required this.groupAvatar,
    required this.memberCount,
    required this.groupFlow,
  });

  @override
  Widget build(BuildContext context) {
    final members = [
      {'avatar': '🕊️', 'name': 'Riya', 'flow': 15, 'admin': true},
      {'avatar': '📚', 'name': 'Rahul', 'flow': 12, 'admin': true},
      {'avatar': '🎮', 'name': 'Aarav', 'flow': 23, 'admin': false},
      {'avatar': '👤', 'name': 'Priya', 'flow': 8, 'admin': false},
      {'avatar': '🏓', 'name': 'Ankit', 'flow': 5, 'admin': false},
      {'avatar': '🎨', 'name': 'Neha', 'flow': 10, 'admin': false},
      {'avatar': '🎵', 'name': 'Karan', 'flow': 6, 'admin': false},
      {'avatar': '📱', 'name': 'Simran', 'flow': 4, 'admin': false},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E17),
      appBar: AppBar(
        title: const Text(
          'Group Info',
          style: TextStyle(color: Colors.white),
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
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Group Avatar
            Container(
              width: 100,
              height: 100,
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
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              groupName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7C9AFF).withOpacity(0.2),
                    const Color(0xFF6C5CE7).withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '⚡',
                    style: TextStyle(fontSize: 14, color: Color(0xFF7C9AFF)),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$groupFlow day flow',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7C9AFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '👥 $memberCount members',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9AA8C7),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Group Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F2F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'GROUP STATS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('📚', '45', 'study sessions'),
                      _buildStatItem('🐚', '12', 'shells'),
                      _buildStatItem('🔥', '15', 'best flow'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Members List
            const Text(
              'MEMBERS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ...members.map((member) => Container(
              margin: const EdgeInsets.only(bottom: 8),
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
                        member['avatar'] as String,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              member['name'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (member['admin'] as bool) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C9AFF).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Admin',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF7C9AFF),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text(
                              '⚡',
                              style: TextStyle(fontSize: 10, color: Color(0xFF7C9AFF)),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${member['flow']}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF7C9AFF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A80F0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('ADD MEMBER'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('LEAVE GROUP'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}