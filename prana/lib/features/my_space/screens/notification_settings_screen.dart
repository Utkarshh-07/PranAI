// lib/features/my_space/screens/notification_settings_screen.dart (UPDATED)
import 'package:flutter/material.dart';
import '../models/notification_settings.dart';
import '../services/notification_service.dart';
import '../theme/my_space_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  late NotificationSettings _settings;
  late NotificationService _service;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = NotificationService();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _service.loadSettings();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await _service.saveSettings(_settings);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification settings saved!'),
          backgroundColor: MySpaceTheme.primaryLavender,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _settings.quietHourStart : _settings.quietHourEnd,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _settings.quietHourStart = picked;
        } else {
          _settings.quietHourEnd = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: MySpaceTheme.primaryLavender,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: MySpaceTheme.mainBackground,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Master switch
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Allow Notifications',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Master switch for all notifications'),
                  value: _settings.allowNotifications,
                  onChanged: (value) {
                    setState(() {
                      _settings.allowNotifications = value;
                    });
                  },
                  activeColor: MySpaceTheme.primaryLavender,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Reminder types
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REMINDER TYPES',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: MySpaceTheme.primaryLavender,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        title: const Text('Pre-event reminders'),
                        subtitle: const Text('Get notified before events start'),
                        value: _settings.preEventReminders && _settings.allowNotifications,
                        onChanged: _settings.allowNotifications
                            ? (value) => setState(() => _settings.preEventReminders = value!)
                            : null,
                        activeColor: MySpaceTheme.primaryLavender,
                      ),
                      CheckboxListTile(
                        title: const Text('Daily morning summary'),
                        subtitle: const Text('See your day at a glance'),
                        value: _settings.dailyMorningSummary && _settings.allowNotifications,
                        onChanged: _settings.allowNotifications
                            ? (value) => setState(() => _settings.dailyMorningSummary = value!)
                            : null,
                        activeColor: MySpaceTheme.primaryLavender,
                      ),
                      CheckboxListTile(
                        title: const Text('Weekly preview'),
                        subtitle: const Text('Get your week vibe every Sunday'),
                        value: _settings.weeklyPreview && _settings.allowNotifications,
                        onChanged: _settings.allowNotifications
                            ? (value) => setState(() => _settings.weeklyPreview = value!)
                            : null,
                        activeColor: MySpaceTheme.primaryLavender,
                      ),
                      CheckboxListTile(
                        title: const Text('Balance alerts'),
                        subtitle: const Text('Prevent study burnout'),
                        value: _settings.balanceAlerts && _settings.allowNotifications,
                        onChanged: _settings.allowNotifications
                            ? (value) => setState(() => _settings.balanceAlerts = value!)
                            : null,
                        activeColor: MySpaceTheme.primaryLavender,
                      ),
                      CheckboxListTile(
                        title: const Text('Post-event check-ins'),
                        subtitle: const Text('How did it go?'),
                        value: _settings.postEventCheckins && _settings.allowNotifications,
                        onChanged: _settings.allowNotifications
                            ? (value) => setState(() => _settings.postEventCheckins = value!)
                            : null,
                        activeColor: MySpaceTheme.primaryLavender,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Quiet hours
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'QUIET HOURS',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: MySpaceTheme.primaryLavender,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: const Text('Start time'),
                        subtitle: Text(_settings.quietHourStart.format(context)),
                        trailing: const Icon(Icons.access_time),
                        onTap: () => _selectTime(true),
                      ),
                      ListTile(
                        title: const Text('End time'),
                        subtitle: Text(_settings.quietHourEnd.format(context)),
                        trailing: const Icon(Icons.access_time),
                        onTap: () => _selectTime(false),
                      ),
                      const Text(
                        'No notifications during this time',
                        style: TextStyle(fontSize: 12, color: MySpaceTheme.mediumText),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Default reminder time
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DEFAULT REMINDER TIME',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: MySpaceTheme.primaryLavender,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: _settings.defaultReminderMinutes,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 5, child: Text('5 minutes before')),
                          DropdownMenuItem(value: 15, child: Text('15 minutes before')),
                          DropdownMenuItem(value: 30, child: Text('30 minutes before')),
                          DropdownMenuItem(value: 60, child: Text('1 hour before')),
                          DropdownMenuItem(value: 1440, child: Text('1 day before')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _settings.defaultReminderMinutes = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Sound selection
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NOTIFICATION SOUND',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: MySpaceTheme.primaryLavender,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RadioListTile<String>(
                        title: const Text('Gentle chime'),
                        value: 'gentle',
                        groupValue: _settings.sound,
                        onChanged: (value) {
                          setState(() {
                            _settings.sound = value!;
                          });
                        },
                        activeColor: MySpaceTheme.primaryLavender,
                      ),
                      RadioListTile<String>(
                        title: const Text('Ocean waves'),
                        value: 'waves',
                        groupValue: _settings.sound,
                        onChanged: (value) {
                          setState(() {
                            _settings.sound = value!;
                          });
                        },
                        activeColor: MySpaceTheme.primaryLavender,
                      ),
                      RadioListTile<String>(
                        title: const Text('Silent'),
                        value: 'silent',
                        groupValue: _settings.sound,
                        onChanged: (value) {
                          setState(() {
                            _settings.sound = value!;
                          });
                        },
                        activeColor: MySpaceTheme.primaryLavender,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MySpaceTheme.primaryLavender,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'SAVE SETTINGS',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}