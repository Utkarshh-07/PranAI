// lib/screens/ai_chat/ai_home_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/ai_character_model.dart';
import 'ai_character_creator.dart';
import 'ai_chat_interface.dart' hide AICharacter;
import '../../widgets/animated_character.dart';

class AIHomeScreen extends StatefulWidget {
  const AIHomeScreen({super.key});

  @override
  State<AIHomeScreen> createState() => _AIHomeScreenState();
}

class _AIHomeScreenState extends State<AIHomeScreen> {
  List<AICharacter> _characters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString('ai_characters');
    
    if (saved != null) {
      final List<dynamic> jsonList = jsonDecode(saved);
      _characters = jsonList.map((j) => AICharacter.fromJson(j)).toList();
    } else {
      // Create default character
      _characters = [
        AICharacter(
          id: 'default_1',
          name: 'Alex',
          gender: 'male',
          voiceType: 'calm',
          baseColor: '#7C9AFF',
          eyeColor: '#FFFFFF',
        ),
      ];
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _saveCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = 
        _characters.map((c) => c.toJson()).toList();
    await prefs.setString('ai_characters', jsonEncode(jsonList));
  }

  void _addCharacter(AICharacter character) {
    setState(() {
      _characters.add(character);
    });
    _saveCharacters();
  }

  void _deleteCharacter(String id) {
    setState(() {
      _characters.removeWhere((c) => c.id == id);
    });
    _saveCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E17),
      appBar: AppBar(
        title: const Text(
          'AI Companions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
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
            onPressed: () async {
              final newCharacter = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AICharacterCreator(),
                ),
              );
              if (newCharacter != null) {
                _addCharacter(newCharacter);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _characters.isEmpty
              ? _buildEmptyState()
              : _buildCharacterGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '✨',
                style: TextStyle(fontSize: 80),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Create Your First AI Friend',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Design a companion that matches your personality',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              final newCharacter = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AICharacterCreator(),
                ),
              );
              if (newCharacter != null) {
                _addCharacter(newCharacter);
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Create AI Friend',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF69B4),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: _characters.length,
      itemBuilder: (context, index) {
        final character = _characters[index];
        return _buildCharacterCard(character);
      },
    );
  }

  Widget _buildCharacterCard(AICharacter character) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AIChatInterface(character: character),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(int.parse(character.baseColor.replaceFirst('#', '0xFF'))).withOpacity(0.3),
              const Color(0xFF7B68EE).withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(int.parse(character.baseColor.replaceFirst('#', '0xFF'))),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Character preview
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(int.parse(character.baseColor.replaceFirst('#', '0xFF'))),
                        const Color(0xFF7B68EE),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      character.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  character.gender == 'male' ? '♂ Male Voice' : '♀ Female Voice',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            // Delete button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _showDeleteDialog(character),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(AICharacter character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Character'),
        content: Text('Are you sure you want to delete ${character.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteCharacter(character.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}