// lib/screens/parent/parent_dashboard.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'parent_notifications_screen.dart';
import '../../services/emotional_analysis_service.dart';
import '../../services/notification_service.dart';

class ParentDashboard extends StatefulWidget {
  final String parentEmail;
  final String studentCode;
  
  const ParentDashboard({
    Key? key,
    required this.parentEmail,
    required this.studentCode,
  }) : super(key: key);
  
  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  Map<String, dynamic> childData = {
    'name': 'Utkarsh',
    'currentMood': 'Calm & Happy',
    'moodEmoji': '😊',
    'stressLevel': 3,
    'sleepQuality': 'Excellent',
    'streak': '7 days',
    'activities': 'Meditation, AI Chat',
  };
  
  int _unreadCount = 0;
  final EmotionalAnalysisService _analysisService = EmotionalAnalysisService();
  final NotificationService _notificationService = NotificationService();

  final Color harborBlue = Color(0xFF2C5282);
  final Color warmBrown = Color(0xFF975A16);
  final Color cozyOrange = Color(0xFFDD6B20);
  final Color gardenGreen = Color(0xFF38A169);
  final Color softCream = Color(0xFFFEF3C7);
  final Color warmRed = Color(0xFFE53E3E);
  final Color skyBlue = Color(0xFF63B3ED);
  final Color waterBlue = Color(0xFF4299E1);

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  void _loadUnreadCount() {
    FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: 'parent_utkarsh')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() {
          _unreadCount = snapshot.docs.length;
        });
      }
    });
  }

  Future<void> _sendTestNotification(String type) async {
    Map<String, dynamic> notification;
    
    switch (type) {
      case 'exam':
        notification = _analysisService.getExamStressNotification(childData['name']);
        break;
      case 'lonely':
        notification = _analysisService.getLonelinessNotification(childData['name']);
        break;
      case 'achievement':
        notification = _analysisService.getAchievementNotification(childData['name']);
        break;
      case 'urgent':
        notification = _analysisService.getUrgentNotification(childData['name']);
        break;
      default:
        return;
    }
    
    await _analysisService.sendDemoNotification('parent_utkarsh', notification);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${notification['title']} sent!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _testPopupNotification() async {
    await _notificationService.showTestPopup();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔔 Popup notification triggered!')),
    );
  }

  void _testExamStressPopup() async {
    await _notificationService.sendExamStressAlert(childData['name']);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📚 Exam stress popup sent!')),
    );
  }

  void _testUrgentPopup() async {
    await _notificationService.sendUrgentAlert(childData['name']);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🚨 Urgent alert popup sent!')),
    );
  }

  void _testCelebrationPopup() async {
    await _notificationService.sendCelebrationAlert(childData['name']);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎉 Celebration popup sent!')),
    );
  }

  void _showTestAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: harborBlue.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: cozyOrange, width: 2),
        ),
        title: Row(
          children: [
            Icon(Icons.notifications_active, color: cozyOrange),
            SizedBox(width: 10),
            Text(
              'Test Parent Alerts',
              style: TextStyle(color: softCream, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '🔔 POPUP NOTIFICATIONS',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              _buildTestAlertButton('Test Popup', '🔔', _testPopupNotification, color: Colors.purple),
              const SizedBox(height: 8),
              _buildTestAlertButton('Exam Stress Popup', '📚', _testExamStressPopup, color: Colors.orange),
              const SizedBox(height: 8),
              _buildTestAlertButton('Urgent Alert Popup', '🚨', _testUrgentPopup, color: Colors.red),
              const SizedBox(height: 8),
              _buildTestAlertButton('Celebration Popup', '🎉', _testCelebrationPopup, color: Colors.green),
              
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '📱 STORE NOTIFICATIONS',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              _buildTestAlertButton('Exam Stress', '📚', () => _sendTestNotification('exam'), color: Colors.orange),
              const SizedBox(height: 8),
              _buildTestAlertButton('Loneliness', '💭', () => _sendTestNotification('lonely'), color: Colors.blue),
              const SizedBox(height: 8),
              _buildTestAlertButton('Achievement', '🏆', () => _sendTestNotification('achievement'), color: Colors.green),
              const SizedBox(height: 8),
              _buildTestAlertButton('Urgent Alert', '🚨', () => _sendTestNotification('urgent'), isUrgent: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: softCream.withOpacity(0.7))),
          ),
        ],
      ),
    );
  }

  Widget _buildTestAlertButton(String label, String emoji, VoidCallback onTap, {bool isUrgent = false, Color? color}) {
    final buttonColor = color ?? (isUrgent ? warmRed : gardenGreen);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: buttonColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: buttonColor.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 24)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: softCream, fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.send, color: buttonColor, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedHarborBackground(),
          
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildMoodCard(),
                  _buildQuickInsights(),
                  _buildWeeklyMoodTracker(),
                  _buildFamilyActivities(),
                  _buildSafetySection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: FloatingActionButton(
              onPressed: _testPopupNotification,
              heroTag: 'test_popup',
              backgroundColor: Colors.purple,
              mini: true,
              child: const Icon(Icons.notifications_active, color: Colors.white),
            ),
          ),
          FloatingActionButton.extended(
            onPressed: _showTestAlertDialog,
            icon: Icon(Icons.notifications_active, color: softCream),
            label: const Text('Test Alert', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: cozyOrange,
            elevation: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            harborBlue.withOpacity(0.9),
            waterBlue.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: softCream.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 25,
            spreadRadius: 3,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: softCream.withOpacity(0.2),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: softCream),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _testPopupNotification,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.purple.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notification_add, color: softCream, size: 16),
                      const SizedBox(width: 4),
                      Text('Popup', style: TextStyle(color: softCream, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: cozyOrange.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cozyOrange.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.notifications, color: softCream, size: 18),
                        const SizedBox(width: 8),
                        Text('Insights', style: TextStyle(color: softCream, fontWeight: FontWeight.w600, fontSize: 14)),
                      ],
                    ),
                  ),
                  if (_unreadCount > 0)
                    Positioned(
                      right: -5,
                      top: -5,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: warmRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '$_unreadCount',
                          style: TextStyle(color: softCream, fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ParentNotificationsScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: gardenGreen.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: gardenGreen.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.visibility, color: softCream, size: 18),
                      const SizedBox(width: 8),
                      Text('View All', style: TextStyle(color: softCream, fontWeight: FontWeight.w600, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: cozyOrange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: cozyOrange.withOpacity(0.5)),
                ),
                child: Center(child: Text('🏡', style: TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome to House Harbor', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: softCream, height: 1.1)),
                    const SizedBox(height: 5),
                    Text('${childData['name']}\'s wellness sanctuary', style: TextStyle(fontSize: 16, color: softCream.withOpacity(0.9))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, spreadRadius: 2)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, color: cozyOrange, size: 24),
              const SizedBox(width: 10),
              Text("Today's Emotional Weather", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: softCream)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gardenGreen.withOpacity(0.3), skyBlue.withOpacity(0.3)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: gardenGreen.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                Text(childData['moodEmoji'], style: TextStyle(fontSize: 60)),
                const SizedBox(height: 10),
                Text(childData['currentMood'], style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: softCream)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMoodIndicator('Stress', '${childData['stressLevel']}/10', gardenGreen),
                    _buildMoodIndicator('Sleep', childData['sleepQuality'], skyBlue),
                    _buildMoodIndicator('Streak', childData['streak'], cozyOrange),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weekly Progress', style: TextStyle(color: softCream.withOpacity(0.9), fontSize: 14)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.7,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(gardenGreen),
                      borderRadius: BorderRadius.circular(10),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: gardenGreen.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: gardenGreen.withOpacity(0.5)),
                ),
                child: Text('↑ 25%', style: TextStyle(color: softCream, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInsights() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: harborBlue.withOpacity(0.7),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: softCream.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, spreadRadius: 2)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: cozyOrange),
              const SizedBox(width: 10),
              Text('Quick Insights', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: softCream)),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.2,
            children: [
              _buildInsightCard(icon: Icons.psychology, title: 'AI Session', value: '45 min', color: skyBlue, progress: 0.8),
              _buildInsightCard(icon: Icons.self_improvement, title: 'Meditation', value: 'Daily', color: gardenGreen, progress: 1.0),
              _buildInsightCard(icon: Icons.nightlight_round, title: 'Sleep', value: '8.2 hrs', color: waterBlue, progress: 0.9),
              _buildInsightCard(icon: Icons.trending_up, title: 'Improvement', value: '30%', color: cozyOrange, progress: 0.7),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyMoodTracker() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: warmBrown.withOpacity(0.7),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: cozyOrange.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: softCream),
              const SizedBox(width: 10),
              Text('Weekly Mood Journey', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: softCream)),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 5),
                _buildDayCard('Mon', '😊', 0.9, gardenGreen),
                _buildDayCard('Tue', '😐', 0.6, cozyOrange),
                _buildDayCard('Wed', '😊', 0.8, gardenGreen),
                _buildDayCard('Thu', '😟', 0.4, warmRed),
                _buildDayCard('Fri', '😊', 0.9, gardenGreen),
                _buildDayCard('Sat', '😄', 1.0, gardenGreen),
                _buildDayCard('Sun', '😊', 0.8, gardenGreen),
                const SizedBox(width: 5),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: gardenGreen.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: gardenGreen.withOpacity(0.5)),
              ),
              child: Text('Most Positive: Saturday! 🌟', style: TextStyle(color: softCream, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyActivities() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: harborBlue.withOpacity(0.7),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: gardenGreen.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.family_restroom, color: gardenGreen),
              const SizedBox(width: 10),
              Text('Family Harbor Activities', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: softCream)),
            ],
          ),
          const SizedBox(height: 20),
          _buildActivityTile(emoji: '🌳', title: 'Garden Stroll', time: 'Today 6 PM', color: gardenGreen),
          _buildActivityTile(emoji: '🎨', title: 'Creative Time', time: 'Tomorrow 4 PM', color: skyBlue),
          _buildActivityTile(emoji: '🍕', title: 'Family Dinner', time: 'Friday 7 PM', color: cozyOrange),
        ],
      ),
    );
  }

  Widget _buildSafetySection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: warmRed.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: warmRed.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: softCream),
              const SizedBox(width: 10),
              Text('Harbor Safety', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: softCream)),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildSafetyButton('Emergency Call', Icons.emergency),
              _buildSafetyButton('School Contact', Icons.school),
              _buildSafetyButton('Family Alert', Icons.family_restroom),
              _buildSafetyButton('Quick Help', Icons.help),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedHarborBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4C51BF), Color(0xFF2D3748), Color(0xFF2C5282)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.5,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2D3748).withOpacity(0.8), Color(0xFF4A5568).withOpacity(0.6)],
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2C5282).withOpacity(0.7), Color(0xFF2B6CB0).withOpacity(0.8)],
                ),
              ),
              child: CustomPaint(painter: _WavePainter()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIndicator(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Center(child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: softCream))),
        ),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: softCream.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required double progress,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(color: softCream.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: softCream)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(5),
              minHeight: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(String day, String mood, double progress, Color color) {
    return Container(
      width: 70,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(fontWeight: FontWeight.w600, color: softCream, fontSize: 14)),
          const SizedBox(height: 8),
          Text(mood, style: TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(2)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile({
    required String emoji,
    required String title,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: color.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(emoji, style: TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: softCream, fontSize: 16)),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(color: softCream.withOpacity(0.8), fontSize: 14)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: color, size: 16),
        ],
      ),
    );
  }

  Widget _buildSafetyButton(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: warmRed.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: warmRed.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: softCream),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 14, color: softCream, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(
        Offset(i, size.height * 0.3),
        Offset(i + 15, size.height * 0.28),
        paint,
      );
    }
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i, size.height * 0.5),
        Offset(i + 20, size.height * 0.48),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}