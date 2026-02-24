// FILE: lib/models/character_model.dart
class AICharacter {
  final String id;
  final String name;
  final String description;
  final String imageAsset; // Human image path
  final String primaryColor;
  final String secondaryColor;
  final String voiceGender; // Proper female/male voice
  final String personality;
  final String expertise;

  AICharacter({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.primaryColor,
    required this.secondaryColor,
    required this.voiceGender,
    required this.personality,
    required this.expertise,
  });

  // List of human AI characters
  static List<AICharacter> characters = [
    AICharacter(
      id: '1',
      name: 'Dr. Ananya Sharma',
      description: 'Professional psychologist with 10+ years experience',
      imageAsset: 'assets/characters/female_psychologist.png',
      primaryColor: '0xFF4A6FA5', // Soft blue
      secondaryColor: '0xFF06D6A0', // Teal
      voiceGender: 'female',
      personality: 'Empathetic, Calm, Supportive',
      expertise: 'Stress Management, Exam Anxiety',
    ),
    AICharacter(
      id: '2',
      name: 'Mentor Raj',
      description: 'Youth mentor and career counselor',
      imageAsset: 'assets/characters/male_mentor.png',
      primaryColor: '0xFF1E3A8A', // Navy blue
      secondaryColor: '0xFFFFD166', // Yellow
      voiceGender: 'male',
      personality: 'Motivational, Practical, Encouraging',
      expertise: 'Career Guidance, Motivation',
    ),
    AICharacter(
      id: '3',
      name: 'Dr. Priya Verma',
      description: 'Therapist specializing in student wellness',
      imageAsset: 'assets/characters/female_therapist.png',
      primaryColor: '0xFF9D4EDD', // Purple
      secondaryColor: '0xFFF15BB5', // Pink
      voiceGender: 'female',
      personality: 'Compassionate, Insightful, Patient',
      expertise: 'Emotional Support, Mindfulness',
    ),
    AICharacter(
      id: '4',
      name: 'Coach Arjun',
      description: 'Life coach and meditation guide',
      imageAsset: 'assets/characters/male_coach.png',
      primaryColor: '0xFF2A9D8F', // Green
      secondaryColor: '0xFFE9C46A', // Gold
      voiceGender: 'male',
      personality: 'Balanced, Wise, Grounded',
      expertise: 'Meditation, Life Balance',
    ),
    AICharacter(
      id: '5',
      name: 'Sister Kavita',
      description: 'Friendly companion and listener',
      imageAsset: 'assets/characters/female_companion.png',
      primaryColor: '0xFFE63946', // Coral
      secondaryColor: '0xFFA8DADC', // Light blue
      voiceGender: 'female',
      personality: 'Friendly, Warm, Approachable',
      expertise: 'Daily Support, Friendship',
    ),
  ];
}