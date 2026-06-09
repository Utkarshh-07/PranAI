// lib/services/notification_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(settings, onDidReceiveNotificationResponse: _onNotificationTap);
    
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission();
    }
    
    await _getFCMToken();
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    
    _isInitialized = true;
    print('✅ Notification Service initialized');
  }

  Future<void> _getFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('📱 FCM Token: $token');
        await _saveTokenToFirestore(token);
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    try {
      await FirebaseFirestore.instance.collection('fcm_tokens').doc(token).set({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
      print('✅ Token saved to Firestore');
    } catch (e) {
      print('❌ Error saving token: $e');
    }
  }

  void _showForegroundNotification(RemoteMessage message) {
    print('📨 Foreground notification: ${message.notification?.title}');
    if (message.notification != null) {
      _showLocalNotification(
        title: message.notification!.title ?? 'PRANA',
        body: message.notification!.body ?? 'You have a new notification',
        payload: message.data.toString(),
      );
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    print('🔔 Notification tapped: ${response.payload}');
  }

  void _handleMessage(RemoteMessage message) {
    print('📱 App opened from notification: ${message.data}');
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'prana_channel',
      'PRANA Notifications',
      channelDescription: 'Notifications for PRANA app',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.hashCode,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'title': title,
        'body': body,
        'type': type,
        'data': data ?? {},
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
      
      await _showLocalNotification(title: title, body: body);
      print('✅ Notification sent to user: $userId');
    } catch (e) {
      print('❌ Error sending notification: $e');
    }
  }

  Future<void> sendNotificationToParent({
    required String parentId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    await sendNotificationToUser(
      userId: parentId,
      title: title,
      body: body,
      type: type,
      data: data,
    );
  }

  Future<void> showTestPopup() async {
    await _showLocalNotification(
      title: '🧪 Test Popup',
      body: 'This is a test notification from PRANA!',
    );
  }

  Future<void> sendExamStressAlert(String childName) async {
    await _showLocalNotification(
      title: '🌊 PRANA - Parent Insight',
      body: '$childName seems to be under significant exam pressure. Check the app for guidance.',
    );
  }

  Future<void> sendUrgentAlert(String childName) async {
    await _showLocalNotification(
      title: '🚨 URGENT PARENT ALERT',
      body: '$childName has expressed severe distress. Immediate attention needed!',
    );
  }

  Future<void> sendCelebrationAlert(String childName) async {
    await _showLocalNotification(
      title: '🎉 PRANA - Parent Joy',
      body: '$childName achieved something today! Check the app to celebrate!',
    );
  }
}