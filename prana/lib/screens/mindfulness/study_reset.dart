// lib/screens/mindfulness/study_reset.dart
import 'package:flutter/material.dart';
import 'dart:async';

class StudyResetScreen extends StatefulWidget {
  const StudyResetScreen({Key? key}) : super(key: key);

  @override
  _StudyResetScreenState createState() => _StudyResetScreenState();
}

class _StudyResetScreenState extends State<StudyResetScreen> 
    with SingleTickerProviderStateMixin {
  int _selectedTime = 3;
  int _remainingSeconds = 180;
  bool _isRunning = false;
  Timer? _timer;
  bool _isSoundEnabled = true;
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;
    
    setState(() {
      _isRunning = true;
      _remainingSeconds = _selectedTime * 60;
    });
    
    if (_isSoundEnabled) {
      print('🔊 Study sound would play');
    }
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          
          if (_remainingSeconds == 5 && _isSoundEnabled) {
            print('🔔 Completion sound would play');
          }
        } else {
          _timer?.cancel();
          _isRunning = false;
          _showCompletionDialog();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
    });
    print('⏸️ Timer paused');
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
      _remainingSeconds = _selectedTime * 60;
    });
    print('🔄 Timer reset');
  }

  void _toggleSound() {
    setState(() {
      _isSoundEnabled = !_isSoundEnabled;
    });
    print(_isSoundEnabled ? '🔊 Sound enabled' : '🔇 Sound disabled');
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF72585).withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Study Reset Complete! 🎯', 
          style: TextStyle(color: Colors.white, fontSize: 22)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school, size: 50, color: Colors.white),
            const SizedBox(height: 15),
            const Text(
              'Your mind is refreshed and ready to focus!',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '🎯 Focus Boost: +${(_selectedTime * 15)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Back to Study!',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF72585),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Study Reset',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _toggleSound,
                    icon: Icon(
                      _isSoundEnabled ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Quick focus booster for study breaks. Refresh your mind in minutes!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // Time Selection
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [1, 3, 5, 7].map((minutes) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text('$minutes min'),
                      selected: _selectedTime == minutes,
                      selectedColor: Colors.white,
                      backgroundColor: Colors.pink[300],
                      labelStyle: TextStyle(
                        color: _selectedTime == minutes
                            ? const Color(0xFFF72585)
                            : Colors.white,
                      ),
                      onSelected: (_) {
                        if (!_isRunning) {
                          setState(() {
                            _selectedTime = minutes;
                            _remainingSeconds = minutes * 60;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),

            // Main Timer Display
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.school, size: 80, color: Colors.white),
                    const SizedBox(height: 20),
                    Text(
                      '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Monospace',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Focus and Breathe',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reset
                  IconButton(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.replay, color: Colors.white, size: 30),
                  ),

                  // Play/Pause
                  IconButton(
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    icon: Icon(
                      _isRunning ? Icons.pause_circle : Icons.play_circle,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),

                  // Sound Toggle
                  IconButton(
                    onPressed: _toggleSound,
                    icon: Icon(
                      _isSoundEnabled ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}