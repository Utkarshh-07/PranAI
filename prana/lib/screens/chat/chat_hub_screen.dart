// lib/screens/chat/chat_hub_screen.dart (FIXED)
import 'package:flutter/material.dart';
import 'package:prana/screens/chat/all_chats_tab.dart';
import 'package:provider/provider.dart';
import 'all_chats_tab.dart';
import 'friends_tab.dart';
import 'groups_tab.dart';
import 'ai_tab.dart';
import '../../services/ai_service.dart';

class ChatHubScreen extends StatefulWidget {
  const ChatHubScreen({super.key});

  @override
  State<ChatHubScreen> createState() => _ChatHubScreenState();
}

class _ChatHubScreenState extends State<ChatHubScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  final String currentUserId = "user1";
  final String currentUserDocId = "user_utkarsh";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (_) => AIService(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0F1E),
        appBar: AppBar(
          title: const Row(
            children: [
              Text('💬', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text(
                'CHATS',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
          ],
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
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F2F).withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF69B4),
                      Color(0xFF7B68EE),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: 'ALL'),
                  Tab(text: 'FRIENDS'),
                  Tab(text: 'GROUPS'),
                  Tab(text: 'AI'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            AllChatTab(
              currentUserId: currentUserId,
              currentUserDocId: currentUserDocId,
            ),
            FriendsTab(
              currentUserId: currentUserId,
              currentUserDocId: currentUserDocId,
            ),
            const GroupsTab(), // No parameters - FIXED
            const AiTab(currentUserId: ''),
          ],
        ),
      ),
    );
  }
}