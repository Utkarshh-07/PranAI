// lib/screens/settings/notification_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _messageNotifications = true;
  bool _friendRequestNotifications = true;
  bool _achievementNotifications = true;
  bool _dailySummaryNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _messageNotifications = prefs.getBool('message_notifications') ?? true;
      _friendRequestNotifications = prefs.getBool('friend_request_notifications') ?? true;
      _achievementNotifications = prefs.getBool('achievement_notifications') ?? true;
      _dailySummaryNotifications = prefs.getBool('daily_summary_notifications') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('message_notifications', _messageNotifications);
    await prefs.setBool('friend_request_notifications', _friendRequestNotifications);
    await prefs.setBool('achievement_notifications', _achievementNotifications);
    await prefs.setBool('daily_summary_notifications', _dailySummaryNotifications);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E17),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1F2F),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text('Save', style: TextStyle(color: Color(0xFF4A80F0))),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSwitchTile(
            icon: Icons.chat_bubble_outline,
            title: 'New Messages',
            subtitle: 'Get notified when someone sends you a message',
            value: _messageNotifications,
            onChanged: (v) => setState(() => _messageNotifications = v),
          ),
          _buildSwitchTile(
            icon: Icons.person_add_alt,
            title: 'Friend Requests',
            subtitle: 'Get notified when someone sends a friend request',
            value: _friendRequestNotifications,
            onChanged: (v) => setState(() => _friendRequestNotifications = v),
          ),
          _buildSwitchTile(
            icon: Icons.emoji_events,
            title: 'Achievements',
            subtitle: 'Get notified when you unlock achievements',
            value: _achievementNotifications,
            onChanged: (v) => setState(() => _achievementNotifications = v),
          ),
          _buildSwitchTile(
            icon: Icons.summarize,
            title: 'Daily Summary',
            subtitle: 'Receive daily summary of your child\'s progress (Parents)',
            value: _dailySummaryNotifications,
            onChanged: (v) => setState(() => _dailySummaryNotifications = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: const Color(0xFF7C9AFF)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF4A80F0),
    );
  }
}