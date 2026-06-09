// lib/screens/parent/parent_notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ParentNotificationsScreen extends StatefulWidget {
  const ParentNotificationsScreen({super.key});

  @override
  State<ParentNotificationsScreen> createState() => _ParentNotificationsScreenState();
}

class _ParentNotificationsScreenState extends State<ParentNotificationsScreen> {
  bool _isLoading = true;
  List<QueryDocumentSnapshot> _notifications = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _createSampleNotificationsIfEmpty();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: 'parent_utkarsh')
          .get();

      final docs = snapshot.docs;
      
      // Sort manually in memory (no index needed)
      docs.sort((a, b) {
        final aTime = (a.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        final bTime = (b.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        return bTime.compareTo(aTime);
      });

      setState(() {
        _notifications = docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print('❌ Error loading notifications: $e');
    }
  }

  Future<void> _createSampleNotificationsIfEmpty() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: 'parent_utkarsh')
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) {
        await _createSampleNotification(
          title: '🌊 Welcome to Parent Insights',
          body: 'You will receive AI-generated insights about your child\'s wellbeing here.',
          type: 'info',
          actionStep: 'Check back regularly for updates about your child\'s emotional wellness.',
        );
        
        await _createSampleNotification(
          title: '🎉 Sample Celebration Alert',
          body: 'Your child completed their daily wellness check-in!',
          type: 'celebration',
          actionStep: '"I\'m proud of you for taking care of your mental health!"',
        );
        
        await _createSampleNotification(
          title: '💡 How It Works',
          body: 'When your child chats with AI friends, we analyze for wellbeing insights.',
          type: 'info',
          actionStep: 'No chat history is shared - only anonymous wellness insights.',
        );
        
        // Reload notifications after creating samples
        await _loadNotifications();
        print('✅ Sample notifications created');
      }
    } catch (e) {
      print('❌ Error creating samples: $e');
    }
  }

  Future<void> _createSampleNotification({
    required String title,
    required String body,
    required String type,
    String? actionStep,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': 'parent_utkarsh',
        'title': title,
        'body': body,
        'type': type,
        'actionStep': actionStep,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      print('❌ Error creating notification: $e');
    }
  }

  Future<void> _markAsRead(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(docId)
          .update({'isRead': true});
      
      // Refresh the list
      await _loadNotifications();
    } catch (e) {
      print('❌ Error marking as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E17),
      appBar: AppBar(
        title: const Text('Parent Insights', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1F2F),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.orange, size: 48),
            const SizedBox(height: 16),
            Text(
              'Unable to load insights',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection',
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNotifications,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B68EE),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌊', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'No insights yet',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Test alerts from the dashboard!',
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await _createSampleNotificationsIfEmpty();
                await _loadNotifications();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Load Sample Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B68EE),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final doc = _notifications[index];
          final data = doc.data() as Map<String, dynamic>;
          return _buildNotificationCard(data, doc.id);
        },
      ),
    );
  }
  
  Widget _buildNotificationCard(Map<String, dynamic> data, String docId) {
    final timestamp = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    final isRead = data['isRead'] ?? false;
    final type = data['type'] ?? 'info';
    
    Color getColor() {
      switch (type) {
        case 'urgent': return Colors.red;
        case 'celebration': return Colors.green;
        case 'support': return Colors.orange;
        case 'attention': return Colors.blue;
        default: return const Color(0xFF7B68EE);
      }
    }
    
    IconData getIcon() {
      switch (type) {
        case 'urgent': return Icons.warning_amber_rounded;
        case 'celebration': return Icons.celebration;
        case 'support': return Icons.family_restroom;
        case 'attention': return Icons.notifications_active;
        default: return Icons.insights;
      }
    }
    
    return GestureDetector(
      onTap: () {
        _showNotificationDetails(data);
        if (!isRead) {
          _markAsRead(docId);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              getColor().withOpacity(0.15),
              getColor().withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: getColor().withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: getColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(getIcon(), color: getColor(), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      data['title'] ?? 'PRANA Insight',
                      style: TextStyle(
                        color: getColor(),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!isRead)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('h:mm a').format(timestamp),
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                data['body'] ?? '',
                style: TextStyle(
                  color: isRead ? Colors.white70 : Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
            
            if (data['actionStep'] != null && data['actionStep'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: getColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: getColor().withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.amber, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          data['actionStep'],
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '🤍 AI-generated wellbeing insight',
                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1F2F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] ?? 'Insight',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data['body'] ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      if (data['actionStep'] != null && data['actionStep'].toString().isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.lightbulb, color: Colors.amber),
                                  SizedBox(width: 8),
                                  Text(
                                    'Suggested Action',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data['actionStep'],
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B68EE),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Close', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}