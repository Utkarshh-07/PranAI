// lib/screens/chat/groups_tab.dart (FIXED - No constructor parameters)
import 'package:flutter/material.dart';
import 'group_feed_screen.dart';

class GroupsTab extends StatelessWidget {
  const GroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A0F1E),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to create group
                      Navigator.pushNamed(context, '/create-group');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A80F0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('CREATE GROUP'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Join group with code
                      _showJoinGroupDialog(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF7B68EE)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('JOIN'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) {
                final items = [
                  {
                    'avatar': '📚',
                    'name': 'Study Circle - Class 12A',
                    'members': 8,
                    'streak': 12,
                    'lastActive': 'Riya shared an achievement • 2h',
                  },
                  {
                    'avatar': '👪',
                    'name': 'Family - The Johnsons',
                    'members': 4,
                    'streak': 7,
                    'lastActive': 'Mom sent a gift • 5h',
                  },
                  {
                    'avatar': '🎮',
                    'name': 'Gaming Squad',
                    'members': 6,
                    'streak': 3,
                    'lastActive': 'Aarav shared a shell • 8h',
                  },
                ];
                
                final item = items[index];
                return _buildGroupItem(context, item);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showJoinGroupDialog(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2F),
        title: const Text('Join Group', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: codeController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter group code',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            filled: true,
            fillColor: const Color(0xFF0A0F1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Join group logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Joining group...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A80F0),
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupItem(BuildContext context, Map<String, dynamic> item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupFeedScreen(
                groupName: item['name'] as String,
                groupAvatar: item['avatar'] as String,
                memberCount: item['members'] as int,
                streak: item['streak'] as int,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F2F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
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
                          item['avatar'] as String,
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
                            item['name'] as String,
                            style: const TextStyle(
                              fontSize: 16,
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
                                '${item['members']} members',
                                style: TextStyle(
                                  fontSize: 12,
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
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${item['streak']}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFFFF69B4),
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['lastActive'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}