// lib/screens/chat/ai_tab.dart (UPDATED)
import 'package:flutter/material.dart';
import '../../models/ai_character_model.dart';
import '../ai_chat/ai_chat_interface.dart';

class AiTab extends StatelessWidget {
  final String currentUserId;

  const AiTab({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final aiFriends = [
      AICharacter(
        id: 'ai_1',
        name: 'Alex',
        gender: 'male',
        voiceType: 'calm',
        baseColor: '#7C9AFF',
        eyeColor: '#FFFFFF',
      ),
      AICharacter(
        id: 'ai_2',
        name: 'Jordan',
        gender: 'neutral',
        voiceType: 'energetic',
        baseColor: '#FF69B4',
        eyeColor: '#FFFFFF',
      ),
      AICharacter(
        id: 'ai_3',
        name: 'Taylor',
        gender: 'female',
        voiceType: 'wise',
        baseColor: '#A3E4D7',
        eyeColor: '#FFFFFF',
      ),
      AICharacter(
        id: 'ai_4',
        name: 'Casey',
        gender: 'neutral',
        voiceType: 'gentle',
        baseColor: '#FFB7B2',
        eyeColor: '#FFFFFF',
      ),
    ];

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
        ...aiFriends.map((ai) => _buildAIChatTile(context, ai)),
      ],
    );
  }

  Widget _buildAIChatTile(BuildContext context, AICharacter ai) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ai.baseColorObj.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ai.baseColorObj,
                const Color(0xFF7B68EE),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              ai.initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          ai.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          'AI Friend • Online',
          style: TextStyle(
            color: Colors.green,
            fontSize: 12,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ai.baseColorObj, const Color(0xFF7B68EE)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'CHAT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
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
}