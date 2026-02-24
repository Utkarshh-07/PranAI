import 'package:flutter/material.dart';
import 'video_chat_screen.dart';

class CharacterCustomizationScreen extends StatefulWidget {
  final Map<String, dynamic> character;
  final Map<String, dynamic>? parentData;
  
  const CharacterCustomizationScreen({
    super.key,
    required this.character,
    this.parentData,
  });
  
  @override
  State<CharacterCustomizationScreen> createState() => _CharacterCustomizationScreenState();
}

class _CharacterCustomizationScreenState extends State<CharacterCustomizationScreen> {
  String _selectedVoiceGender = 'female';
  double _speechRate = 0.6; // NORMAL SPEED
  Color _primaryColor = const Color(0xFF4A6FA5);
  Color _secondaryColor = const Color(0xFF06D6A0);
  final TextEditingController _nameController = TextEditingController();
  String _selectedEmoji = '👩';
  
  final List<String> _voiceGenders = ['female', 'male'];
  final List<Color> _colorOptions = [
    const Color(0xFF4A6FA5),
    const Color(0xFF1E3A8A),
    const Color(0xFF9D4EDD),
    const Color(0xFF2A9D8F),
    const Color(0xFFE63946),
    const Color(0xFFF15BB5),
    const Color(0xFFFFD166),
    const Color(0xFF118AB2),
  ];
  
  final List<String> _emojiOptions = ['👩', '👨', '🧑‍⚕️', '🧑‍🏫', '👩‍💼', '👨‍💼'];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.character['name'] ?? 'AI Companion';
    _selectedVoiceGender = widget.character['voiceGender'] ?? 'female';
    _primaryColor = Color(widget.character['primaryColor'] ?? 0xFF4A6FA5);
    _secondaryColor = Color(widget.character['secondaryColor'] ?? 0xFF06D6A0);
    _selectedEmoji = widget.character['emoji'] ?? '👩';
    _speechRate = widget.character['speechRate'] ?? 0.6;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getUpdatedCharacterData() {
    return {
      ...widget.character,
      'name': _nameController.text.isNotEmpty ? _nameController.text : widget.character['name'] ?? 'AI Companion',
      'voiceGender': _selectedVoiceGender,
      'speechRate': _speechRate,
      'primaryColor': _primaryColor.value,
      'secondaryColor': _secondaryColor.value,
      'emoji': _selectedEmoji,
    };
  }

  @override
  Widget build(BuildContext context) {
    bool hasPhoto = widget.character['imageAsset'] != null && widget.character['imageAsset']!.isNotEmpty;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A2463),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            
            // Character Preview with YOUR PHOTO
            _buildCharacterPreview(hasPhoto),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildNameInput(),
                    const SizedBox(height: 25),
                    _buildVoiceGenderSelector(),
                    const SizedBox(height: 25),
                    _buildSpeechRateSlider(),
                    const SizedBox(height: 25),
                    _buildColorSelector('Primary Color', _primaryColor, true),
                    const SizedBox(height: 20),
                    _buildColorSelector('Secondary Color', _secondaryColor, false),
                    const SizedBox(height: 25),
                    _buildEmojiSelector(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF0A2463), const Color(0xFF1E3A8A)],
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
            'Customize AI Character',
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

  Widget _buildCharacterPreview(bool hasPhoto) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor.withOpacity(0.3), _secondaryColor.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ClipOval(
              child: hasPhoto
                  ? Image.asset(
                      widget.character['imageAsset']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildEmojiPreview();
                      },
                    )
                  : _buildEmojiPreview(),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _nameController.text.isNotEmpty 
                ? _nameController.text 
                : widget.character['name'] ?? 'Your AI Companion',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedVoiceGender == 'female' 
                ? 'Female Voice • Normal Speed'
                : 'Male Voice • Normal Speed',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPreview() {
    return Container(
      color: _primaryColor,
      child: Center(
        child: Text(
          _selectedEmoji,
          style: const TextStyle(fontSize: 60),
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Character Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: const InputDecoration(
              hintText: 'Enter character name...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              prefixIcon: Icon(Icons.person, color: Colors.white70),
            ),
            onChanged: (value) => setState(() {}),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voice Gender',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _voiceGenders.map((gender) {
              bool isSelected = _selectedVoiceGender == gender;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedVoiceGender = gender;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? _primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        gender == 'female' ? Icons.female : Icons.male,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        gender.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeechRateSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Speech Speed',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              _speechRate == 0.3 ? 'Slow' : _speechRate == 0.6 ? 'Normal' : 'Fast',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Slider(
                value: _speechRate,
                min: 0.3,
                max: 0.9,
                divisions: 2,
                label: _speechRate == 0.3 ? 'Slow' : _speechRate == 0.6 ? 'Normal' : 'Fast',
                activeColor: _primaryColor,
                inactiveColor: Colors.white30,
                onChanged: (value) {
                  setState(() {
                    _speechRate = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Slow', style: TextStyle(color: Colors.white70)),
                  Text('Normal', style: TextStyle(color: Colors.white70)),
                  Text('Fast', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector(String title, Color selectedColor, bool isPrimary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: _colorOptions.length,
            itemBuilder: (context, index) {
              Color color = _colorOptions[index];
              bool isSelected = isPrimary ? _primaryColor == color : _secondaryColor == color;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isPrimary) {
                      _primaryColor = color;
                    } else {
                      _secondaryColor = color;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Character Emoji',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: _emojiOptions.length,
            itemBuilder: (context, index) {
              String emoji = _emojiOptions[index];
              bool isSelected = _selectedEmoji == emoji;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedEmoji = emoji;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? _primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2463),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            final updatedCharacter = _getUpdatedCharacterData();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VideoChatScreen(
                  character: updatedCharacter,
                  parentData: widget.parentData,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            shadowColor: _primaryColor.withOpacity(0.5),
          ),
          child: const Text(
            'START VIDEO CHAT',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}