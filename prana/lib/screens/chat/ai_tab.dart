// lib/screens/chat/ai_tab.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/ai_character_model.dart';
import '../../services/ai_service.dart';
import '../ai_chat/ai_chat_interface.dart';

class AiTab extends StatefulWidget {
  const AiTab({super.key, required String currentUserId});

  @override
  State<AiTab> createState() => _AiTabState();
}

class _AiTabState extends State<AiTab> {
  List<AICharacter> _aiFriends = [];
  Map<String, dynamic>? _lastSummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Schedule after first frame to ensure provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      // Use listen: false because we're not rebuilding during load
      final aiService = Provider.of<AIService>(context, listen: false);
      await aiService.loadFromPrefs();
      
      if (mounted) {
        setState(() {
          _aiFriends = aiService.getFriends();
          _isLoading = false;
        });
      }
      
      _loadLastSummary();
    } catch (e) {
      print('Error loading AI friends: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadLastSummary() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _lastSummary = {
          'date': DateTime.now().toIso8601String(),
          'tasks': 8,
          'totalTasks': 10,
          'mood': 'happy',
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'YOUR AI COMPANIONS',
            style: TextStyle(
              color: Color(0xFF7C9AFF),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ..._aiFriends.map((ai) => _buildAIChatTile(ai)).toList(),
        
        const SizedBox(height: 24),
        
        if (_lastSummary != null) ...[
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              'TODAY\'S SUMMARY',
              style: TextStyle(
                color: Color(0xFF7C9AFF),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          _buildSummaryCard(),
        ],
        
        const SizedBox(height: 24),
        
        _buildAchievementCard(),
      ],
    );
  }

  Widget _buildAIChatTile(AICharacter ai) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(int.parse(ai.baseColor.replaceFirst('#', '0xFF'))).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(int.parse(ai.baseColor.replaceFirst('#', '0xFF'))),
                const Color(0xFF7B68EE),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              ai.name[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          ai.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          'AI Companion • Online',
          style: TextStyle(
            color: Colors.green,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white70,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AIChatInterface(character: ai),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
    final dateFormat = DateFormat('EEEE, MMMM d');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateFormat.format(DateTime.now()),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your Day in Review',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '• Completed 12 tasks (92%!)',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            '• Meditated for 20 minutes',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            '• Found 2 new shells 🐚',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your AI friend has more insights...',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to default AI chat
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFF69B4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Chat Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.blue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.purple, size: 20),
              SizedBox(width: 8),
              Text(
                '✨ MOMENTOS✨',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '• Completed 8/10 tasks today',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          const Text(
            '• 3 study sessions • 2 breaks',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          const Text(
            '• Found a Crown Shell! 👑',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Want a detailed summary from your AI friend?',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Generate AI summary
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: const Text('Ask AI'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}