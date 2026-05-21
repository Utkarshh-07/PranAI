// lib/screens/ai_chat/ai_character_creator.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../services/ai_service.dart';
import '../../models/ai_character_model.dart';

class AICharacterCreator extends StatefulWidget {
  const AICharacterCreator({super.key});

  @override
  State<AICharacterCreator> createState() => _AICharacterCreatorState();
}

class _AICharacterCreatorState extends State<AICharacterCreator> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _uuid = const Uuid();
  
  String _selectedGender = 'male';
  String _selectedVoice = 'calm';
  String _selectedColor = '#7C9AFF';
  String _selectedEyeColor = '#FFFFFF';
  
  final List<String> _genders = ['male', 'female', 'neutral'];
  final List<String> _voiceTypes = ['calm', 'energetic', 'wise', 'gentle'];
  
  final List<Map<String, dynamic>> _colors = [
    {'name': 'Ocean', 'code': '#7C9AFF'},
    {'name': 'Coral', 'code': '#FF6B6B'},
    {'name': 'Mint', 'code': '#A3E4D7'},
    {'name': 'Lavender', 'code': '#B19CD9'},
    {'name': 'Sunset', 'code': '#FFB7B2'},
    {'name': 'Forest', 'code': '#95D5B2'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E17),
      appBar: AppBar(
        title: const Text(
          'Create Companion',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A1F2F),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview Card
              _buildPreviewCard(),
              
              const SizedBox(height: 24),
              
              // Name Field
              const Text(
                'Name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter a name for your companion',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: const Color(0xFF1A1F2F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Gender Selection
              const Text(
                'Gender',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildGenderSelector(),
              
              const SizedBox(height: 20),
              
              // Voice Type
              const Text(
                'Voice Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildVoiceSelector(),
              
              const SizedBox(height: 20),
              
              // Color Selection
              const Text(
                'Character Color',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildColorSelector(),
              
              const SizedBox(height: 20),
              
              // Eye Color
              const Text(
                'Eye Color',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildEyeColorSelector(),
              
              const SizedBox(height: 40),
              
              // Create Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _createCharacter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Create Companion',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(int.parse(_selectedColor.replaceFirst('#', '0xFF'))),
            const Color(0xFF7B68EE),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Preview',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    _nameController.text.isEmpty 
                        ? '?'
                        : _nameController.text[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Color(int.parse(_selectedEyeColor.replaceFirst('#', '0xFF'))),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _nameController.text.isEmpty ? 'Name' : _nameController.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_selectedGender} • ${_selectedVoice}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: _genders.map((gender) {
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedGender = gender),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _selectedGender == gender
                    ? Colors.blue
                    : const Color(0xFF1A1F2F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  gender[0].toUpperCase() + gender.substring(1),
                  style: TextStyle(
                    color: _selectedGender == gender
                        ? Colors.white
                        : Colors.white70,
                    fontWeight: _selectedGender == gender
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVoiceSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _voiceTypes.map((voice) {
        return GestureDetector(
          onTap: () => setState(() => _selectedVoice = voice),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _selectedVoice == voice
                  ? Colors.blue
                  : const Color(0xFF1A1F2F),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              voice[0].toUpperCase() + voice.substring(1),
              style: TextStyle(
                color: _selectedVoice == voice ? Colors.white : Colors.white70,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorSelector() {
    return Row(
      children: _colors.map((color) {
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedColor = color['code']),
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Color(int.parse(color['code'].replaceFirst('#', '0xFF'))),
                borderRadius: BorderRadius.circular(12),
                border: _selectedColor == color['code']
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEyeColorSelector() {
    return Row(
      children: [
        _buildEyeColorOption('#FFFFFF', 'White'),
        _buildEyeColorOption('#000000', 'Black'),
        _buildEyeColorOption('#FFD700', 'Gold'),
        _buildEyeColorOption('#00FF00', 'Green'),
      ],
    );
  }

  Widget _buildEyeColorOption(String colorCode, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedEyeColor = colorCode),
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: _selectedEyeColor == colorCode
                ? Colors.blue
                : const Color(0xFF1A1F2F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(int.parse(colorCode.replaceFirst('#', '0xFF'))),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createCharacter() async {
    if (_formKey.currentState!.validate()) {
      final character = AICharacter(
        id: _uuid.v4(),
        name: _nameController.text,
        gender: _selectedGender,
        voiceType: _selectedVoice,
        baseColor: _selectedColor,
        eyeColor: _selectedEyeColor,
      );

      final aiService = AIService();
      await aiService.addFriend(character);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${character.name} created!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }
}