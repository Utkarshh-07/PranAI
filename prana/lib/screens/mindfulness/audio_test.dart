// lib/screens/mindfulness/audio_test.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioTestScreen extends StatefulWidget {
  @override
  _AudioTestScreenState createState() => _AudioTestScreenState();
}

class _AudioTestScreenState extends State<AudioTestScreen> {
  final AudioPlayer _player = AudioPlayer();
  final List<Map<String, String>> _audioFiles = [
    {'name': 'Gentle Rain', 'path': 'assets/audio/gentle_rain.mp3'},
    {'name': 'Wake Up Bell 1', 'path': 'assets/audio/wake_up1.mp3'},
    {'name': 'Wake Up Bell 2', 'path': 'assets/audio/wake_up2.mp3'},
  ];
  
  bool _isPlaying = false;
  String _currentSound = '';
  
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  
  Future<void> _playSound(String path, String name) async {
    try {
      setState(() {
        _currentSound = name;
        _isPlaying = true;
      });
      
      await _player.stop();
      await _player.play(AssetSource(path));
      
      _player.onPlayerComplete.listen((event) {
        setState(() {
          _isPlaying = false;
        });
      });
    } catch (e) {
      print('Error playing sound: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isPlaying = false;
      });
    }
  }
  
  Future<void> _stopSound() async {
    await _player.stop();
    setState(() {
      _isPlaying = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Test'),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: Container(
        color: Color(0xFF0A2463),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Testing Audio Files',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Current Status:',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              _isPlaying ? '▶️ Playing: $_currentSound' : '⏸️ Stopped',
              style: TextStyle(
                color: _isPlaying ? Colors.green : Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30),
            ..._audioFiles.map((audio) {
              return Card(
                color: Colors.white.withOpacity(0.1),
                child: ListTile(
                  leading: Icon(Icons.audiotrack, color: Color(0xFF4CC9F0)),
                  title: Text(
                    audio['name']!,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    audio['path']!,
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: _isPlaying && _currentSound == audio['name']
                      ? IconButton(
                          icon: Icon(Icons.stop, color: Colors.red),
                          onPressed: _stopSound,
                        )
                      : IconButton(
                          icon: Icon(Icons.play_arrow, color: Colors.green),
                          onPressed: () => _playSound(audio['path']!, audio['name']!),
                        ),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Power Nap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CC9F0),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}