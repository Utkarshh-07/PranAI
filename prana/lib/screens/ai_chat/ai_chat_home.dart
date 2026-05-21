// lib/screens/ai_chat/ai_chat_home.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/ai_service.dart';
import '../../models/ai_character_model.dart';
import 'ai_chat_interface.dart';
import 'ai_character_creator.dart';
import '../../widgets/animated_character.dart';

class AIChatHome extends StatefulWidget {
  const AIChatHome({super.key});

  @override
  State<AIChatHome> createState() => _AIChatHomeState();
}

class _AIChatHomeState extends State<AIChatHome> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AIService(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0E17),
        appBar: AppBar(
          title: const Text(
            '🤖 AI FRIENDS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AICharacterCreator(),
                  ),
                );
              },
            ),
          ],
        ),
        body: const AIFriendGrid(),
      ),
    );
  }
}

class AIFriendGrid extends StatelessWidget {
  const AIFriendGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final aiService = Provider.of<AIService>(context);
    final friends = aiService.getFriends();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AIChatInterface(character: friend),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(int.parse(friend.baseColor.replaceFirst('#', '0xFF'))).withOpacity(0.3),
                  const Color(0xFF7B68EE).withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(int.parse(friend.baseColor.replaceFirst('#', '0xFF'))),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(int.parse(friend.baseColor.replaceFirst('#', '0xFF'))),
                        const Color(0xFF7B68EE),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      friend.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  friend.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  friend.gender == 'male' ? '♂ Male Voice' : '♀ Female Voice',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}