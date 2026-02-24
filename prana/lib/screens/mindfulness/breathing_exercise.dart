// lib/screens/mindfulness/breathing_exercise.dart
import 'package:flutter/material.dart';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  
  String _currentPhase = 'Ready?';
  String _instruction = 'Watch baby whale breathe';
  int _remainingTime = 0;
  int _phaseIndex = 0;
  int _cycleCount = 1;
  int _totalCycles = 4;
  bool _isActive = false;
  bool _showCompletion = false;
  String? _selectedMood;
  
  final List<Map<String, dynamic>> _phases = [
    {
      'name': 'INHALE',
      'duration': 4,
      'instruction': 'Breathe in slowly...',
      'color': Color(0xFF89CFF0),
    },
    {
      'name': 'HOLD',
      'duration': 7,
      'instruction': 'Hold gently...',
      'color': Color(0xFF4CC9F0),
    },
    {
      'name': 'EXHALE',
      'duration': 8,
      'instruction': 'Exhale slowly...',
      'color': Color(0xFF06D6A0),
    },
  ];

  final List<Map<String, dynamic>> _moodOptions = [
    {
      'emoji': '😊',
      'label': 'Calm & Peaceful',
      'color': Color(0xFF06D6A0),
      'message': 'Glad you found peace! Regular practice helps maintain this calm.',
      'bgColor': Color(0xFFE8F5E9),
    },
    {
      'emoji': '😌',
      'label': 'Relaxed',
      'color': Color(0xFF4CC9F0),
      'message': 'Wonderful! The relaxation will carry through your day.',
      'bgColor': Color(0xFFE3F2FD),
    },
    {
      'emoji': '😴',
      'label': 'Sleepy',
      'color': Color(0xFF7209B7),
      'message': 'Perfect time for rest! Your body is telling you it needs recovery.',
      'bgColor': Color(0xFFF3E5F5),
    },
    {
      'emoji': '😃',
      'label': 'Energized',
      'color': Color(0xFFFFD166),
      'message': 'Great! Use this energy positively in your daily activities.',
      'bgColor': Color(0xFFFFF8E1),
    },
    {
      'emoji': '🤔',
      'label': 'Mindful',
      'color': Color(0xFF219EBC),
      'message': 'Excellent! Being present is the first step to mindfulness.',
      'bgColor': Color(0xFFE0F7FA),
    },
    {
      'emoji': '😐',
      'label': 'Neutral',
      'color': Color(0xFFA0A0A0),
      'message': 'That\'s okay! Consistency is key. Try again tomorrow.',
      'bgColor': Color(0xFFFAFAFA),
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _phases[0]['duration']),
    );
    
    _scale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
    
    _controller.addListener(() {
      setState(() {
        _remainingTime = (_phases[_phaseIndex]['duration'] * (1 - _controller.value)).ceil();
      });
    });
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isActive) {
        _nextPhase();
      }
    });
  }

  void _startBreathing() {
    if (!_isActive) {
      setState(() {
        _isActive = true;
        _phaseIndex = 0;
        _currentPhase = _phases[_phaseIndex]['name'];
        _instruction = _phases[_phaseIndex]['instruction'];
        _cycleCount = 1;
        _showCompletion = false;
        _selectedMood = null;
      });
      _playPhase();
    }
  }

  void _playPhase() {
    _controller.duration = Duration(seconds: _phases[_phaseIndex]['duration']);
    _controller.forward(from: 0.0);
  }

  void _nextPhase() {
    setState(() {
      if (_phaseIndex < _phases.length - 1) {
        _phaseIndex++;
      } else {
        _phaseIndex = 0;
        _cycleCount++;
        
        if (_cycleCount > _totalCycles) {
          _isActive = false;
          _showCompletion = true;
          _currentPhase = 'Complete!';
          _instruction = 'Great job! How do you feel now?';
          return;
        }
      }
      
      _currentPhase = _phases[_phaseIndex]['name'];
      _instruction = _phases[_phaseIndex]['instruction'];
    });
    
    if (_isActive) {
      _playPhase();
    }
  }

  void _pauseBreathing() {
    _controller.stop();
    setState(() {
      _isActive = false;
      _currentPhase = 'Paused';
      _instruction = 'Tap resume to continue';
    });
  }

  void _resumeBreathing() {
    if (!_isActive) {
      setState(() {
        _isActive = true;
        _currentPhase = _phases[_phaseIndex]['name'];
        _instruction = _phases[_phaseIndex]['instruction'];
      });
      _controller.forward();
    }
  }

  void _resetBreathing() {
    _controller.reset();
    setState(() {
      _isActive = false;
      _phaseIndex = 0;
      _cycleCount = 1;
      _currentPhase = 'Ready?';
      _instruction = 'Watch baby whale breathe';
      _remainingTime = _phases[_phaseIndex]['duration'];
      _showCompletion = false;
      _selectedMood = null;
    });
  }

  void _selectMood(String moodEmoji) {
    setState(() {
      _selectedMood = moodEmoji;
    });
    
    Future.delayed(Duration(milliseconds: 500), () {
      _showAppreciationDialog(moodEmoji);
    });
  }

  void _showAppreciationDialog(String moodEmoji) {
    final moodData = _moodOptions.firstWhere((mood) => mood['emoji'] == moodEmoji);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Color(0xFF1E3A8A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: moodData['color'] as Color, width: 3),
        ),
        elevation: 20,
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Celebration Icon with CUTE EMOJI BACKGROUND
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (moodData['color'] as Color).withOpacity(0.4),
                      (moodData['color'] as Color).withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: moodData['color'] as Color, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: (moodData['color'] as Color).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: moodData['bgColor'] as Color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '🎉',
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Title
              Text(
                'Amazing Work!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 10),
              
              // Mood Display with CUTE EMOJI BACKGROUND
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: moodData['bgColor'] as Color,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          moodEmoji,
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You feel:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          moodData['label'],
                          style: TextStyle(
                            color: moodData['color'] as Color,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 15),
              
              // Personalized Message
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  moodData['message'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Stats Summary
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(0xFF06D6A0).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  '🌊',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Cycles:',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          '$_totalCycles',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(0xFF4CC9F0).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  '⏱️',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Total Time:',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          '${_calculateTotalTime()} min',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFD166).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  '🏆',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Focus Level:',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD166).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFFFFD166)),
                          ),
                          child: Text(
                            'Excellent 🏆',
                            style: TextStyle(color: Color(0xFFFFD166), fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 25),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _resetBreathing();
                      },
                      icon: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '🔁',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      label: Text('Do Another'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      icon: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: (moodData['color'] as Color).withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '🏠',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      label: Text('Return Home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: moodData['color'] as Color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateTotalTime() {
    int secondsPerCycle = 0;
    for (var phase in _phases) {
      secondsPerCycle += phase['duration'] as int;
    }
    int totalSeconds = secondsPerCycle * _totalCycles;
    return (totalSeconds / 60).ceil();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color phaseColor = _isActive ? _phases[_phaseIndex]['color'] as Color : Color(0xFF4CC9F0);
    
    return Scaffold(
      backgroundColor: Color(0xFF0A2463),
      body: SafeArea(
        child: Column(
          children: [
            // ============ HEADER ============
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0A2463),
                    Color(0xFF1E3A8A),
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deep Breathing',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'with Baby Whale Splash',
                          style: TextStyle(
                            color: Color(0xFF89CFF0),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF06D6A0).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xFF06D6A0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              '🌀',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '$_cycleCount/$_totalCycles',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ============ TIMER SELECTION ============
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.black.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '⏱️',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Duration:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 10),
                  _buildDurationOption('1 min', 1),
                  SizedBox(width: 8),
                  _buildDurationOption('3 min', 2),
                  SizedBox(width: 8),
                  _buildDurationOption('5 min', 4),
                  SizedBox(width: 8),
                  _buildDurationOption('10 min', 8),
                ],
              ),
            ),

            // ============ MAIN CONTENT ============
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF0A2463),
                          Color(0xFF1E3A8A),
                          Color(0xFF219EBC),
                        ],
                      ),
                    ),
                  ),
                  
                  // ============ COMPLETION SCREEN ============
                  if (_showCompletion)
                    Positioned.fill(
                      child: Container(
                        color: Color(0xFF0A2463),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Celebration with CUTE EMOJI BACKGROUND
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Color(0xFFFFD166).withOpacity(0.4),
                                    Color(0xFF06D6A0).withOpacity(0.1),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(color: Color(0xFFFFD166).withOpacity(0.5), width: 3),
                              ),
                              child: Center(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFF8E1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '🎉',
                                      style: TextStyle(fontSize: 60),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 30),
                            
                            // Appreciation Message
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Color(0xFF06D6A0).withOpacity(0.5)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'You did amazing!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF89CFF0).withOpacity(0.3),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '🐋',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Completing $_totalCycles breathing cycles is fantastic!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4CC9F0).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Color(0xFF4CC9F0)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE0F7FA),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '💭',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'How do you feel now?',
                                          style: TextStyle(
                                            color: Color(0xFF4CC9F0),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: 30),
                            
                            // Mood Selection Grid with CUTE EMOJI BACKGROUNDS
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Wrap(
                                spacing: 15,
                                runSpacing: 15,
                                alignment: WrapAlignment.center,
                                children: _moodOptions.map((mood) {
                                  bool isSelected = _selectedMood == mood['emoji'];
                                  return GestureDetector(
                                    onTap: () => _selectMood(mood['emoji']),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: isSelected 
                                            ? (mood['color'] as Color).withOpacity(0.2)
                                            : Colors.black.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isSelected 
                                              ? mood['color'] as Color
                                              : Colors.white.withOpacity(0.1),
                                          width: isSelected ? 3 : 1,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: (mood['color'] as Color).withOpacity(0.4),
                                                  blurRadius: 20,
                                                  spreadRadius: 3,
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // CUTE EMOJI BACKGROUND
                                          Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: mood['bgColor'] as Color,
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                mood['emoji'],
                                                style: TextStyle(fontSize: 40),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            mood['label'],
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.white70,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Skip Option
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _showCompletion = false;
                                  _resetBreathing();
                                });
                              },
                              icon: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '⏭️',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              label: Text(
                                'Skip mood check',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  // ============ BREATHING EXERCISE UI ============
                  if (!_showCompletion) ...[
                    // Breathing circle
                    if (_isActive)
                      Center(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 280 * (_scale.value),
                          height: 280 * (_scale.value),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                phaseColor.withOpacity(0.15),
                                phaseColor.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                              color: phaseColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    
                    // Baby Whale with CUTE EMOJI BACKGROUND
                    Center(
                      child: Transform.scale(
                        scale: _scale.value,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 160,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFB3E0FF),
                                    Color(0xFF89CFF0),
                                    Color(0xFF4CC9F0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(80),
                                border: Border.all(color: Colors.white.withOpacity(0.9), width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF4CC9F0).withOpacity(0.6),
                                    blurRadius: 25,
                                    spreadRadius: 5,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE3F2FD),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.5),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '🐋',
                                      style: TextStyle(fontSize: 45),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            
                            // Name Tag with EMOJI
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFD166),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '🐳',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Baby Splash',
                                    style: TextStyle(
                                      color: Color(0xFF0A2463),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Phase Display
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            _currentPhase,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: phaseColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '💨',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  _instruction,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Timer with CUTE EMOJI BACKGROUND
                    Positioned(
                      bottom: 110,
                      right: 20,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: phaseColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: phaseColor.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '⏱️',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'TIME',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              '$_remainingTime',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Monospace',
                                shadows: [
                                  Shadow(
                                    color: phaseColor.withOpacity(0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'seconds',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Phase Indicator with EMOJIS
                    Positioned(
                      bottom: 110,
                      left: 20,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: phaseColor, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '🌀',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'PHASE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: List.generate(_phases.length, (index) {
                                bool isActive = _phaseIndex == index;
                                bool isCompleted = index < _phaseIndex;
                                String phaseEmoji = ['🌬️', '⏸️', '💨'][index];
                                
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isActive 
                                        ? _phases[index]['color'] as Color
                                        : isCompleted
                                          ? (_phases[index]['color'] as Color).withOpacity(0.3)
                                          : Colors.white.withOpacity(0.1),
                                    border: Border.all(
                                      color: isActive ? Colors.white : Colors.transparent,
                                      width: 2,
                                    ),
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: (_phases[index]['color'] as Color).withOpacity(0.5),
                                              blurRadius: 10,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      phaseEmoji,
                                      style: TextStyle(
                                        fontSize: isActive ? 16 : 14,
                                        color: isActive ? Colors.white : Colors.white70,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ============ CONTROL BUTTONS ============
                        // ============ CONTROL BUTTONS ============
            if (!_showCompletion)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Progress dots with cute emoji
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_totalCycles, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: index < _cycleCount ? 18 : 10,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: index < _cycleCount
                                ? Color(0xFF06D6A0)
                                : Colors.white.withOpacity(0.3),
                            boxShadow: index < _cycleCount
                                ? [
                                    BoxShadow(
                                      color: Color(0xFF06D6A0).withOpacity(0.5),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : [],
                          ),
                          child: index < _cycleCount
                              ? Center(
                                  child: Text(
                                    '✨',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                )
                              : null,
                        );
                      }),
                    ),
                    SizedBox(height: 16),
                    
                    // Control Buttons with cute emoji backgrounds
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Start/Pause/Resume Button
                        ElevatedButton(
                          onPressed: () {
                            if (!_isActive) {
                              if (_currentPhase == 'Ready?' || _currentPhase == 'Complete!' || _currentPhase == 'Paused') {
                                _startBreathing();
                              } else {
                                _resumeBreathing();
                              }
                            } else {
                              _pauseBreathing();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !_isActive ? Color(0xFF06D6A0) : Color(0xFFFF6B6B),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            shadowColor: !_isActive ? Color(0xFF06D6A0).withOpacity(0.5) : Color(0xFFFF6B6B).withOpacity(0.5),
                            elevation: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    !_isActive ? '▶️' : '⏸️',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                !_isActive ? 
                                  (_currentPhase == 'Paused' ? 'Resume' : 'Start') 
                                  : 'Pause',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        
                        // Reset Button
                        ElevatedButton(
                          onPressed: _resetBreathing,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7209B7),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            shadowColor: Color(0xFF7209B7).withOpacity(0.5),
                            elevation: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '🔁',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Reset', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationOption(String label, int cycles) {
    bool isSelected = _totalCycles == cycles;
    return GestureDetector(
      onTap: () {
        setState(() {
          _totalCycles = cycles;
          _cycleCount = 1;
          _resetBreathing();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF06D6A0) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Color(0xFF06D6A0) : Colors.white.withOpacity(0.3),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(0xFF06D6A0).withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isSelected ? 0.3 : 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  '⏱️',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}