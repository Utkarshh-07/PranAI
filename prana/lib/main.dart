// lib/main.dart (COMPLETE WORKING VERSION)
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prana/screens/ai_chat/api_test_screen.dart';
import 'package:provider/provider.dart';

// YOUR EXISTING IMPORTS
import 'package:prana/screens/home_screen.dart';
import 'package:prana/screens/login_screen.dart';
import 'package:prana/screens/screening_screen.dart';
import 'package:prana/screens/terms_screen.dart';
import 'package:prana/screens/parent_contact_screen.dart';
import 'package:prana/screens/student_dashboard.dart';
import 'package:prana/screens/mindfulness/mindfulness_home.dart';
import 'package:prana/screens/parent/parent_dashboard.dart';
import 'package:prana/screens/parent/parent_summary_screen.dart';
import 'package:prana/screens/prankster_flow/level1_warning.dart';
import 'package:prana/screens/prankster_flow/level2_winterfell.dart';
import 'package:prana/screens/prankster_flow/level3_danger_zone.dart';
import 'package:prana/screens/prankster_flow/level4_cyber_cell.dart';

// MINDFULNESS SCREENS
import 'package:prana/screens/mindfulness/power_nap.dart';
import 'package:prana/screens/mindfulness/breathing_exercise.dart';
import 'package:prana/screens/mindfulness/study_reset.dart';
import 'package:prana/screens/mindfulness/evening_wind.dart';

// HAPPY THOUGHTS
import 'package:prana/screens/mindfulness/happy_thoughts/happy_thoughts_home.dart';

// SHELL COLLECTION FEATURES
import 'package:prana/features/happy_thoughts/shell_collection/shell_collection_home.dart';
import 'package:prana/features/happy_thoughts/shell_collection/shell_story_reveal.dart';
import 'package:prana/features/happy_thoughts/shell_collection/oceans_diary.dart';
import 'package:prana/features/happy_thoughts/shell_collection/beach_hunt_game.dart';
import 'package:prana/features/happy_thoughts/shell_collection/models/shell_model.dart';

// ===== AUTH IMPORTS =====
import 'package:prana/providers/auth_provider.dart' as app;
import 'package:prana/screens/auth/welcome_screen.dart';

// ===== MY SPACE IMPORTS =====
import 'package:prana/features/my_space/my_space_screen.dart';
import 'package:prana/features/my_space/my_rhythm_screen.dart';

// ===== CHAT IMPORTS =====
import 'package:prana/screens/chat/chat_hub_screen.dart';
import 'package:prana/screens/chat/friend_chat_screen.dart';
import 'package:prana/screens/chat/group_chat_screen.dart';
import 'package:prana/screens/chat/add_friend_screen.dart';
import 'package:prana/screens/chat/create_group_screen.dart';

// ===== NEW AI CHAT IMPORTS =====
import 'package:prana/screens/ai_chat/ai_chat_home.dart';
import 'package:prana/screens/ai_chat/ai_character_creator.dart';
import 'package:prana/screens/ai_chat/ai_chat_interface.dart' as chat;
import 'package:prana/screens/ai_chat/ai_video_interface.dart' as video;

// ===== FRIEND REQUEST SERVICE =====
import 'package:prana/services/friend_request_service.dart';

// ===== NOTIFICATION & SUMMARY SERVICES =====
import 'package:prana/services/notification_service.dart';
import 'package:prana/services/summary_scheduler.dart';
import 'package:prana/services/parent_summary_service.dart';

// ===== SETTINGS SCREENS =====
import 'package:prana/screens/settings/notification_settings_screen.dart';

// ===== FUNCTION TO CREATE TEST USERS =====
Future<void> _createTestUsers() async {
  try {
    print('📝 Checking if users exist...');
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    
    if (snapshot.docs.isEmpty) {
      print('📝 Creating test users...');
      
      // Create Utkarsh (Student)
      await FirebaseFirestore.instance.collection('users').doc('user_utkarsh').set({
        'uid': 'user1',
        'username': 'Utkarsh',
        'avatar': '💗',
        'email': 'utkarsh@test.com',
        'flow': 15,
        'isOnline': true,
        'userType': 'student',
        'lastActive': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Utkarsh created');
      
      // Create Hardik (Student)
      await FirebaseFirestore.instance.collection('users').doc('user_hardik').set({
        'uid': 'user2',
        'username': 'Hardik',
        'avatar': '😉',
        'email': 'hardik@test.com',
        'flow': 15,
        'isOnline': true,
        'userType': 'student',
        'lastActive': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Hardik created');
      
      // Create Arya (Student)
      await FirebaseFirestore.instance.collection('users').doc('user_arya').set({
        'uid': 'user3',
        'username': 'Arya',
        'avatar': '😒',
        'email': 'arya@test.com',
        'flow': 7,
        'isOnline': false,
        'userType': 'student',
        'lastActive': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Arya created');
      
      // Create Parent User (linked to Utkarsh)
      await FirebaseFirestore.instance.collection('users').doc('parent_utkarsh').set({
        'uid': 'parent1',
        'username': 'Parent',
        'avatar': '👨‍👩‍👧',
        'email': 'parent@test.com',
        'userType': 'parent',
        'linkedStudentId': 'user_utkarsh',
        'linkedStudentName': 'Utkarsh',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Parent user created');
      
      // Create a test chat between Utkarsh and Hardik
      await FirebaseFirestore.instance.collection('chats').doc('chat_utkarsh_hardik').set({
        'participants': ['user1', 'user2'],
        'participantNames': {
          'user1': 'Utkarsh',
          'user2': 'Hardik',
        },
        'participantAvatars': {
          'user1': '💗',
          'user2': '😉',
        },
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'type': 'private',
        'unreadCount': {
          'user1': 0,
          'user2': 0,
        },
        'flow': 15,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Test chat created');
      
      // Add a test message
      await FirebaseFirestore.instance
          .collection('chats')
          .doc('chat_utkarsh_hardik')
          .collection('messages')
          .doc('msg1')
          .set({
        'senderId': 'user2',
        'senderName': 'Hardik',
        'senderAvatar': '😉',
        'text': 'Hey Utkarsh! How are you?',
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
        'readBy': ['user2'],
        'deliveredTo': ['user2'],
      });
      print('✅ Test message created');
      
      // Create friends subcollection for Utkarsh
      await FirebaseFirestore.instance
          .collection('users')
          .doc('user_utkarsh')
          .collection('friends')
          .doc('user_hardik')
          .set({
        'friendId': 'user2',
        'friendDocId': 'user_hardik',
        'friendName': 'Hardik',
        'friendAvatar': '😉',
        'status': 'accepted',
        'since': FieldValue.serverTimestamp(),
        'chatId': 'chat_utkarsh_hardik',
        'flow': 15,
      });
      
      // Create friends subcollection for Hardik
      await FirebaseFirestore.instance
          .collection('users')
          .doc('user_hardik')
          .collection('friends')
          .doc('user_utkarsh')
          .set({
        'friendId': 'user1',
        'friendDocId': 'user_utkarsh',
        'friendName': 'Utkarsh',
        'friendAvatar': '💗',
        'status': 'accepted',
        'since': FieldValue.serverTimestamp(),
        'chatId': 'chat_utkarsh_hardik',
        'flow': 15,
      });
      
      print('✅ Friends subcollections created');
      
      // Add friend request collection for testing
      await FirebaseFirestore.instance.collection('friend_requests').add({
        'fromUserId': 'user3',
        'fromUserDocId': 'user_arya',
        'fromUserName': 'Arya',
        'fromUserAvatar': '😒',
        'toUserId': 'user1',
        'toUserDocId': 'user_utkarsh',
        'toUserName': 'Utkarsh',
        'toUserAvatar': '💗',
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ Test friend request created');
      
      // Add sample mood entries for testing summaries
      await FirebaseFirestore.instance
          .collection('users')
          .doc('user_utkarsh')
          .collection('mood_entries')
          .add({
        'mood': 7,
        'stress': 4,
        'note': 'Felt good today',
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ Sample mood entries created');
      
      print('🎉 All test data created successfully!');
      
    } else {
      print('✅ Users already exist in database');
      print('📊 Found ${snapshot.docs.length} users');
    }
  } catch (e) {
    print('❌ Error creating test data: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDUUsxHjxsYliZvxPgLeZUYKkai1gNw2X4",
        appId: "1:913489507783:android:d0e1a21a736fc20f9c55e2",
        messagingSenderId: "913489507783",
        projectId: "pranai-27f75",
        authDomain: "pranai-27f75.firebaseapp.com",
        storageBucket: "pranai-27f75.firebasestorage.app",
      ),
    );
    print('✅ Firebase initialized successfully');
    
    // Initialize Notification Service
    await NotificationService().initialize();
    print('✅ Notification Service initialized');
    
    // Start Summary Scheduler (for parent daily summaries)
    SummaryScheduler().startScheduler();
    print('✅ Summary Scheduler started');
    
    // CREATE TEST USERS AND DATA
    await _createTestUsers();
    
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }
  
  runApp(const PranaApp());
}

class PranaApp extends StatelessWidget {
  const PranaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => app.AuthProvider()),
      ],
      child: MaterialApp(
        title: 'PRANA - Mental Fitness',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF0A2463),
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: const Color(0xFF0A2463),
          useMaterial3: true,
        ),
        
        // START WITH HOME SCREEN
        home: const HomeScreen(),
        
        // ALL ROUTES DEFINED CLEARLY
        routes: {
          // ============ AUTH FLOW ============
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const LoginScreen(),
          
          // ============ CORE FLOW ============
          '/screening': (context) => const ScreeningScreen(),
          '/student_dashboard': (context) => StudentDashboard(parentData: null),
          
          // ============ MY SPACE ============
          '/my-space': (context) => const MySpaceScreen(),
          '/my-rhythm': (context) => const MyRhythmScreen(),
          
          // ============ CHAT ============
          '/chat-hub': (context) => const ChatHubScreen(),
          '/add-friend': (context) => const AddFriendScreen(),
          '/create-group': (context) => const CreateGroupScreen(),
          
          // ============ AI CHAT ============
          '/ai_home': (context) => const AIChatHome(),
          '/ai_creator': (context) => const AICharacterCreator(),
          '/api-test': (context) => const APITestScreen(),
          
          // ============ MINDFULNESS FLOW ============
          '/mindfulness_home': (context) => const MindfulnessHomeScreen(),
          '/power_nap': (context) => PowerNapScreen(),
          '/breathing_exercise': (context) => const BreathingExerciseScreen(),
          '/study_reset': (context) => const StudyResetScreen(),
          '/evening_wind': (context) => const EveningWindScreen(),
          
          // ============ HAPPY THOUGHTS FEATURES ============
          '/happy_thoughts': (context) => const HappyThoughtsHome(),
          
          // ============ SHELL COLLECTION FEATURES ============
          '/shell_collection': (context) => ShellCollectionHome(),
          
          // ============ PARENT FEATURES ============
          '/parent_dashboard': (context) => const ParentDashboard(
                parentEmail: '',
                studentCode: '',
              ),
          '/parent-summaries': (context) => ParentSummaryScreen(
                parentId: 'parent_utkarsh',
              ),
          
          // ============ SETTINGS ============
          '/notification-settings': (context) => const NotificationSettingsScreen(),
        },
        
        // Handle routes with arguments
        onGenerateRoute: (settings) {
          // Terms Screen with arguments
          if (settings.name == '/terms') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => TermsScreen(
                isPotentialPrankster: args?['isPotentialPrankster'] ?? false,
                pranksterScore: args?['pranksterScore'] ?? 0,
                genuineScore: args?['genuineScore'] ?? 0,
              ),
            );
          }
          
          // Parent Contact with arguments
          if (settings.name == '/parent_contact') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => ParentContactScreen(
                isPrankster: args?['isPrankster'] ?? false,
                pranksterScore: args?['pranksterScore'] ?? 0,
                userType: args?['userType'] ?? 'Genuine',
                fakeCrisisCount: args?['fakeCrisisCount'],
                calculatedFine: args?['calculatedFine'],
                fineLevel: args?['fineLevel'],
              ),
            );
          }
          
          // Student Dashboard with arguments
          if (settings.name == '/student_dashboard' && settings.arguments != null) {
            final args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => StudentDashboard(
                parentData: args is Map<String, dynamic> ? args : null,
              ),
            );
          }
          
          // Parent Summary Screen with dynamic parent ID
          if (settings.name == '/parent-summaries' && settings.arguments != null) {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => ParentSummaryScreen(
                parentId: args?['parentId'] ?? 'parent_utkarsh',
              ),
            );
          }
          
          // Friend Chat with arguments
          if (settings.name == '/friend-chat') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => FriendChatScreen(
                chatId: args?['chatId'] ?? '',
                friendName: args?['friendName'] ?? '',
                friendAvatar: args?['friendAvatar'] ?? '👤',
                friendUid: args?['friendUid'] ?? '',
              ),
            );
          }
          
          // Group Chat with arguments
          if (settings.name == '/group-chat') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => GroupChatScreen(
                groupId: args?['groupId'] ?? '',
                groupName: args?['groupName'] ?? 'Group',
                groupAvatar: args?['groupAvatar'] ?? '👥',
                memberCount: args?['memberCount'] ?? 0,
                groupFlow: args?['groupFlow'] ?? 0,
              ),
            );
          }
          
          // AI Chat Interface with arguments
          if (settings.name == '/ai_chat') {
            final args = settings.arguments as Map<String, dynamic>?;
            final character = args?['character'];
            if (character != null) {
              return MaterialPageRoute(
                builder: (context) => chat.AIChatInterface(character: character),
              );
            }
          }
          
          // AI Video Interface with arguments
          if (settings.name == '/ai_video') {
            final args = settings.arguments as Map<String, dynamic>?;
            final character = args?['character'];
            if (character != null) {
              return MaterialPageRoute(
                builder: (context) => video.AIVideoInterface(character: character),
              );
            }
          }
          
          // PRANKSTER FLOW ROUTES
          if (settings.name == '/level1_warning') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => Level1WarningScreen(
                pranksterScore: args?['pranksterScore'] ?? 0,
                genuineScore: args?['genuineScore'] ?? 0,
              ),
            );
          }
          
          if (settings.name == '/level2_winterfell') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => Level2WinterfellScreen(
                pranksterScore: args?['pranksterScore'] ?? 0,
                genuineScore: args?['genuineScore'] ?? 0,
                userPath: args?['userPath'] ?? 'testing',
              ),
            );
          }
          
          if (settings.name == '/level3_danger_zone') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => Level3DangerZoneScreen(
                pranksterScore: args?['pranksterScore'] ?? 0,
                genuineScore: args?['genuineScore'] ?? 0,
                userPath: args?['userPath'] ?? 'testing',
              ),
            );
          }
          
          if (settings.name == '/level4_cyber_cell') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => Level4CyberCellScreen(
                pranksterScore: args?['pranksterScore'] ?? 0,
                genuineScore: args?['genuineScore'] ?? 0,
                userPath: args?['userPath'] ?? 'testing',
                fakeCrisisCount: args?['fakeCrisisCount'] ?? 0,
                calculatedFine: args?['calculatedFine'] ?? 0,
                fineLevel: args?['fineLevel'] ?? 'NONE',
              ),
            );
          }
          
          // SHELL COLLECTION ROUTES
          if (settings.name == '/shell_story_reveal') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => ShellStoryReveal(
                shell: args?['shell'],
                story: args?['story'],
              ),
            );
          }
          
          if (settings.name == '/oceans_diary') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => OceansDiary(
                shells: args?['shells'],
              ),
            );
          }
          
          if (settings.name == '/beach_hunt_game') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => EnhancedBeachHuntGame(
                onShellFound: args?['onShellFound'] as Function(Shell),
              ),
            );
          }
          
          return null;
        },
      ),
    );
  }
}