// lib/screens/screening_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';

class ScreeningScreen extends StatefulWidget {
  const ScreeningScreen({super.key});

  @override
  State<ScreeningScreen> createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends State<ScreeningScreen> {
  int _currentQuestion = 0;
  int _genuineScore = 0;
  int _pranksterScore = 0;
  int? _selectedOptionIndex;
  
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What brings you to Prana today?',
      'submarine': '🚤',
      'options': [
        {'text': 'Need support with stress/anxiety', 'type': 'genuine', 'score': 3, 'icon': '😌', 'depth': 'Surface'},
        {'text': 'Just exploring the app features', 'type': 'neutral', 'score': 1, 'icon': '🔍', 'depth': '100m'},
        {'text': 'Friend recommended for mental wellness', 'type': 'genuine', 'score': 2, 'icon': '👫', 'depth': '200m'},
        {'text': 'Testing/checking it out', 'type': 'prankster', 'score': 3, 'icon': '🎮', 'depth': 'Deep Sea'},
      ],
    },
    {
      'question': 'How did you hear about us?',
      'submarine': '🛳️',
      'options': [
        {'text': 'School counselor/therapist', 'type': 'genuine', 'score': 3, 'icon': '🏫', 'depth': 'Surface'},
        {'text': 'Social media or meme', 'type': 'prankster', 'score': 3, 'icon': '📱', 'depth': 'Deep Sea'},
        {'text': 'Friend who uses it seriously', 'type': 'genuine', 'score': 2, 'icon': '💖', 'depth': '200m'},
        {'text': 'Online ad or article', 'type': 'neutral', 'score': 1, 'icon': '📰', 'depth': '100m'},
      ],
    },
    {
      'question': 'What are you hoping to find here?',
      'submarine': '🌊',
      'options': [
        {'text': 'A safe space to talk', 'type': 'genuine', 'score': 3, 'icon': '🛡️', 'depth': 'Surface'},
        {'text': 'Mental wellness exercises', 'type': 'genuine', 'score': 2, 'icon': '🧘', 'depth': '100m'},
        {'text': 'Just curious about features', 'type': 'neutral', 'score': 1, 'icon': '❓', 'depth': '200m'},
        {'text': 'Testing AI responses', 'type': 'prankster', 'score': 3, 'icon': '🤖', 'depth': 'Deep Sea'},
      ],
    },
  ];

  void _selectOption(int optionIndex) {
    setState(() {
      _selectedOptionIndex = optionIndex;
    });
    
    Future.delayed(const Duration(milliseconds: 600), () {
      final option = _questions[_currentQuestion]['options'][optionIndex];
      final score = option['score'] as int;
      
      if (option['type'] == 'genuine') {
        _genuineScore += score;
      } else if (option['type'] == 'prankster') {
        _pranksterScore += score;
      }
      
      setState(() {
        _selectedOptionIndex = null;
      });
      
      if (_currentQuestion < _questions.length - 1) {
        setState(() {
          _currentQuestion++;
        });
      } else {
        _determinePath();
      }
    });
  }

  void _determinePath() {
    bool isPotentialPrankster = _pranksterScore > _genuineScore;
    
    if (isPotentialPrankster) {
      Navigator.pushReplacementNamed(
        context,
        '/level1_warning',
        arguments: {
          'pranksterScore': _pranksterScore,
          'genuineScore': _genuineScore,
        },
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/terms',
        arguments: {
          'isPotentialPrankster': false,
          'pranksterScore': _pranksterScore,
          'genuineScore': _genuineScore,
        },
      );
    }
  }

  List<Widget> _buildSonarPulses() {
    List<Widget> pulses = [];
    
    for (int i = 0; i < 6; i++) {
      double size = 100 + (i * 40).toDouble();
      double opacity = 0.2 - (i * 0.03);
      
      pulses.add(Positioned(
        top: MediaQuery.of(context).size.height / 2 - size / 2,
        left: MediaQuery.of(context).size.width / 2 - size / 2,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.cyan.withOpacity(opacity),
              width: 1,
            ),
          ),
        ),
      ));
    }
    
    return pulses;
  }
  
  Widget _buildDeepSeaCreature(String emoji, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.cyan.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.cyan.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Deep ocean background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF020A24),
                    Color(0xFF051F46),
                    Color(0xFF0A3A6B),
                    Color(0xFF1E5590),
                  ],
                ),
              ),
            ),
          ),
          
          // Submarine glow
          Positioned(
            top: 100 + (_currentQuestion * 50),
            left: 50 + (_currentQuestion * 30),
            child: Container(
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: RadialGradient(
                  colors: [
                    Colors.cyan.withOpacity(0.4),
                    Colors.blue.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Submarine
          Positioned(
            top: 80,
            right: 30 + (_currentQuestion * 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A5F),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.cyan.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    '🚤',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Depth: ${_questions[_currentQuestion]['options'][0]['depth']}',
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Sonar pulses
          ..._buildSonarPulses(),
          
          // Deep sea creatures
          Positioned(top: 200, left: 40, child: _buildDeepSeaCreature('🐙', 30)),
          Positioned(top: 350, right: 60, child: _buildDeepSeaCreature('🦑', 40)),
          Positioned(top: 450, left: 80, child: _buildDeepSeaCreature('🐠', 25)),
          Positioned(top: 300, right: 100, child: _buildDeepSeaCreature('🦈', 35)),
          
          // Pressure gauge
          Positioned(
            top: 150,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.cyan.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  const Text(
                    '⏱️',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Q: ${_currentQuestion + 1}/${_questions.length}',
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  // Submarine control panel header
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0A3A6B).withOpacity(0.9),
                          const Color(0xFF1E5590).withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.cyan.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF00BCD4),
                                Color(0xFF007C91),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.cyan,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '🔭',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  '${_currentQuestion + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Submarine Screening',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.cyan,
                                ),
                              ),
                              Text(
                                'Diving deep to understand your needs',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.cyan.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A3A6B),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: (_currentQuestion + 1) / _questions.length,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF00BCD4),
                                          Color(0xFF0097A7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A3A6B).withOpacity(0.6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.cyan.withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '🌊',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${_questions.length - _currentQuestion}',
                                  style: const TextStyle(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Sonar question card
                  Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF0A3A6B).withOpacity(0.8),
                          const Color(0xFF1E5590).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.cyan.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.3),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.cyan.withOpacity(0.8),
                                    Colors.blue.withOpacity(0.4),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '📡',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SONAR SIGNAL #${_currentQuestion + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.cyan.withOpacity(0.9),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _questions[_currentQuestion]['question'],
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A3A6B).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.cyan.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.waves,
                                color: Colors.cyan,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Select your depth level answer',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.cyan.withOpacity(0.9),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.cyan,
                                  ),
                                ),
                                child: Text(
                                  _questions[_currentQuestion]['submarine'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Options
                  Expanded(
                    child: ListView.separated(
                      itemCount: _questions[_currentQuestion]['options'].length,
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final option = _questions[_currentQuestion]['options'][index];
                        final isSelected = _selectedOptionIndex == index;
                        
                        Color depthColor;
                        String creature;
                        
                        switch (option['type']) {
                          case 'genuine':
                            depthColor = const Color(0xFF4CAF50);
                            creature = '🐬';
                            break;
                          case 'prankster':
                            depthColor = const Color(0xFFF44336);
                            creature = '🦈';
                            break;
                          default:
                            depthColor = const Color(0xFF2196F3);
                            creature = '🐠';
                        }
                        
                        return GestureDetector(
                          onTap: () => _selectOption(index),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  depthColor.withOpacity(0.9),
                                  depthColor.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected 
                                    ? Colors.white 
                                    : Colors.white.withOpacity(0.3),
                                width: isSelected ? 3 : 1.5,
                              ),
                              boxShadow: isSelected ? [
                                BoxShadow(
                                  color: depthColor.withOpacity(0.6),
                                  blurRadius: 30,
                                  spreadRadius: 8,
                                ),
                              ] : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      option['icon'],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option['text'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        option['depth'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Submarine status
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A3A6B).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.cyan.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.settings_input_antenna,
                          color: Colors.cyan,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Submarine scanning complete in ${_questions.length - _currentQuestion - 1} signals',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Depth analysis: $_genuineScore genuine vs $_pranksterScore testing signals',
                                style: TextStyle(
                                  color: Colors.cyan.withOpacity(0.9),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          '🤿',
                          style: TextStyle(fontSize: 20),
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
    );
  }
}