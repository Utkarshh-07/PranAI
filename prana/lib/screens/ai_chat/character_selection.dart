import 'package:flutter/material.dart';
import 'character_customization.dart';

class CharacterSelectionScreen extends StatefulWidget {
  final Map<String, dynamic>? parentData;
  
  const CharacterSelectionScreen({
    super.key,
    this.parentData,
  });
  
  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  Map<String, dynamic>? selectedCharacter;
  
  // List of AI characters - ONLY 2 WITH YOUR PHOTOS
  final List<Map<String, dynamic>> characters = [
    {
      'id': '1',
      'name': 'Dr. Ananya Sharma',
      'description': 'Professional Psychologist with 10+ years experience',
      'imageAsset': 'assets/characters/female_psychologist.png', // ✅ YOUR PHOTO
      'primaryColor': 0xFF4A6FA5,
      'secondaryColor': 0xFF06D6A0,
      'voiceGender': 'female',
      'personality': 'Empathetic, Calm, Supportive',
      'expertise': 'Stress Management, Exam Anxiety',
      'emoji': '👩‍⚕️',
    },
    {
      'id': '2',
      'name': 'Mentor Raj',
      'description': 'Youth Mentor and Career Counselor',
      'imageAsset': 'assets/characters/male_mentor.png', // ✅ YOUR PHOTO
      'primaryColor': 0xFF1E3A8A,
      'secondaryColor': 0xFFFFD166,
      'voiceGender': 'male',
      'personality': 'Motivational, Practical, Encouraging',
      'expertise': 'Career Guidance, Motivation',
      'emoji': '👨‍🏫',
    },
    // Add 3 more characters with fallback emojis (no photos)
    {
      'id': '3',
      'name': 'Dr. Priya Verma',
      'description': 'Therapist specializing in Student Wellness',
      'imageAsset': '', // No photo, will use emoji
      'primaryColor': 0xFF9D4EDD,
      'secondaryColor': 0xFFF15BB5,
      'voiceGender': 'female',
      'personality': 'Compassionate, Insightful, Patient',
      'expertise': 'Emotional Support, Mindfulness',
      'emoji': '🧑‍⚕️',
    },
    {
      'id': '4',
      'name': 'Coach Arjun',
      'description': 'Life Coach and Meditation Guide',
      'imageAsset': '', // No photo, will use emoji
      'primaryColor': 0xFF2A9D8F,
      'secondaryColor': 0xFFE9C46A,
      'voiceGender': 'male',
      'personality': 'Balanced, Wise, Grounded',
      'expertise': 'Meditation, Life Balance',
      'emoji': '🧘‍♂️',
    },
    {
      'id': '5',
      'name': 'Sister Kavita',
      'description': 'Friendly Companion and Listener',
      'imageAsset': '', // No photo, will use emoji
      'primaryColor': 0xFFE63946,
      'secondaryColor': 0xFFA8DADC,
      'voiceGender': 'female',
      'personality': 'Friendly, Warm, Approachable',
      'expertise': 'Daily Support, Friendship',
      'emoji': '👩',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2463),
      body: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Character Grid
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose Your AI Companion',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select a professional to guide you through your mental wellness journey',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Character Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final character = characters[index];
                      bool isSelected = selectedCharacter?['id'] == character['id'];
                      
                      return _buildCharacterCard(character, isSelected);
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Start Button
          _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0A2463),
            const Color(0xFF1E3A8A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          const Text(
            'AI Character Selection',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(Map<String, dynamic> character, bool isSelected) {
    Color primaryColor = Color(character['primaryColor'] ?? 0xFF4A6FA5);
    bool hasPhoto = character['imageAsset'] != null && character['imageAsset']!.isNotEmpty;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCharacter = character;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.3) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.white.withOpacity(0.2),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Character Image/Emoji
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: hasPhoto
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.asset(
                        character['imageAsset']!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildEmojiFallback(character, primaryColor);
                        },
                      ),
                    )
                  : _buildEmojiFallback(character, primaryColor),
            ),
            
            // Character Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character['name'] ?? 'AI Companion',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      character['personality'] ?? 'Supportive',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          character['voiceGender'] == 'female' 
                              ? Icons.female 
                              : Icons.male,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          character['voiceGender'] == 'female' 
                              ? 'Female Voice' 
                              : 'Male Voice',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    
                    // Selection Indicator
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'SELECTED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiFallback(Map<String, dynamic> character, Color primaryColor) {
    return Container(
      color: primaryColor,
      child: Center(
        child: Text(
          character['emoji'] ?? '👤',
          style: const TextStyle(fontSize: 50),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1EA3A8).withOpacity(0.5),
        border: Border(
          top: BorderSide(color: const Color(0xFF1E3A8A).withOpacity(0.5)),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: selectedCharacter == null 
              ? null 
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CharacterCustomizationScreen(
                        character: selectedCharacter!,
                        parentData: widget.parentData,
                      ),
                    ),
                  );
                },
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          label: const Text(
            'CUSTOMIZE & START CHAT',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCharacter == null 
                ? Colors.grey 
                : const Color(0xFF1EA3A8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            shadowColor: const Color(0xFF1EA3A8).withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}