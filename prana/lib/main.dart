// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// YOUR EXISTING IMPORTS
import 'package:prana/screens/home_screen.dart';
import 'package:prana/screens/login_screen.dart';
import 'package:prana/screens/screening_screen.dart';
import 'package:prana/screens/terms_screen.dart';
import 'package:prana/screens/parent_contact_screen.dart';
import 'package:prana/screens/student_dashboard.dart';
import 'package:prana/screens/mindfulness/mindfulness_home.dart';
import 'package:prana/screens/ai_chat/character_selection.dart';
import 'package:prana/screens/parent/parent_dashboard.dart';
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

// ===== NEW MY SPACE IMPORTS =====
import 'package:prana/features/my_space/my_space_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with YOUR config
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
          '/my_space': (context) => MySpaceScreen(parentData: null),
          
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
          
          // ============ AI CHAT ============
          '/character_selection': (context) => CharacterSelectionScreen(parentData: null),
          
          // ============ PARENT ============
          '/parent_dashboard': (context) => const ParentDashboard(
                parentEmail: '',
                studentCode: '',
              ),
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
          
          // My Space with arguments
          if (settings.name == '/my_space' && settings.arguments != null) {
            final args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => MySpaceScreen(
                parentData: args is Map<String, dynamic> ? args : null,
              ),
            );
          }
          
          // Character Selection with arguments
          if (settings.name == '/character_selection' && settings.arguments != null) {
            final args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => CharacterSelectionScreen(
                parentData: args is Map<String, dynamic> ? args : null,
              ),
            );
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