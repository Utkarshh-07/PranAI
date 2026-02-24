// lib/screens/mindfulness/evening_wind.dart
import 'package:flutter/material.dart';
import 'dart:async';

class EveningWindScreen extends StatefulWidget {
  const EveningWindScreen({Key? key}) : super(key: key);

  @override
  _EveningWindScreenState createState() => _EveningWindScreenState();
}

class _EveningWindScreenState extends State<EveningWindScreen> 
    with SingleTickerProviderStateMixin {
  int _selectedTime = 8;
  int _remainingSeconds = 480;
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
      print('🔊 Sleep sounds would play');
    }
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
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
        backgroundColor: const Color(0xFF4CC9F0).withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sleep Preparation Complete! 🌙', 
          style: TextStyle(color: Colors.white, fontSize: 22)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.nightlight_round, size: 50, color: Colors.white),
            const SizedBox(height: 15),
            const Text(
              'Your body and mind are ready for restful sleep.',
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
                '💤 Sleep Quality: +${(_selectedTime * 8)}%',
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
              'Sweet Dreams!',
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
      backgroundColor: const Color(0xFF4CC9F0),
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
                    'Evening Wind-down',
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
                'Prepare your mind and body for deep, restful sleep.',
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
                children: [5, 8, 10, 15].map((minutes) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text('$minutes min'),
                      selected: _selectedTime == minutes,
                      selectedColor: Colors.white,
                      backgroundColor: const Color(0xFF1E88E5),
                      labelStyle: TextStyle(
                        color: _selectedTime == minutes
                            ? const Color(0xFF4CC9F0)
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

            // Main Content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.nightlight_round, size: 100, color: Colors.white),
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
                      'Relax and Unwind',
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