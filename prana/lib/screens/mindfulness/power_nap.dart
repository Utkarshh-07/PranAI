import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart'; // Add this

class PowerNapScreen extends StatefulWidget {
  @override
  _PowerNapScreenState createState() => _PowerNapScreenState();
}

class _PowerNapScreenState extends State<PowerNapScreen>
    with TickerProviderStateMixin {
  // Audio Players - SINGLE INSTANCE ONLY for web
  AudioPlayer? _backgroundPlayer;
  AudioPlayer? _wakeupPlayer;
  
  // Random generator
  final math.Random _random = math.Random();
  
  // Timer variables
  Timer? _timer;
  int _selectedMinutes = 5;
  int _remainingSeconds = 5 * 60;
  bool _isRunning = false;
  bool _isCompleted = false;
  
  // Audio status
  bool _audioAvailable = true;
  bool _isBellPlaying = false;
  
  // Space/Star fields
  final List<Map<String, dynamic>> _phases = [
    {
      'name': 'GRAVITY RELEASE',
      'description': 'Leaving Earth\'s atmosphere',
      'color': Color(0xFF4CC9F0),
      'icon': Icons.rocket_launch,
      'gradient': [Color(0xFF000814), Color(0xFF001D3D)],
      'stars': 20,
    },
    {
      'name': 'ORBITAL DRIFT',
      'description': 'Floating in zero gravity',
      'color': Color(0xFF4361EE),
      'icon': Icons.satellite_alt,
      'gradient': [Color(0xFF001D3D), Color(0xFF003566)],
      'stars': 40,
    },
    {
      'name': 'DEEP SPACE',
      'description': 'Entering interstellar space',
      'color': Color(0xFF3A0CA3),
      'icon': Icons.star,
      'gradient': [Color(0xFF003566), Color(0xFF0A2463)],
      'stars': 60,
    },
    {
      'name': 'NEBULA DREAM',
      'description': 'Swimming through cosmic clouds',
      'color': Color(0xFF7209B7),
      'icon': Icons.cloud,
      'gradient': [Color(0xFF0A2463), Color(0xFF1E3A8A)],
      'stars': 80,
    },
    {
      'name': 'BLACK HOLE REST',
      'description': 'Absolute cosmic silence',
      'color': Color(0xFFF72585),
      'icon': Icons.circle,
      'gradient': [Color(0xFF1E3A8A), Color(0xFF3A0CA3)],
      'stars': 100,
    },
    {
      'name': 'SUPERNOVA AWAKENING',
      'description': 'Exploding with new energy',
      'color': Color(0xFF4ADE80),
      'icon': Icons.flash_on,
      'gradient': [Color(0xFF3A0CA3), Color(0xFF7209B7)],
      'stars': 120,
    },
  ];
  
  int _currentPhase = 0;
  
  // Advanced animations
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  
  // Star particles
  List<Map<String, dynamic>> _stars = [];
  Timer? _starTimer;
  
  // Planets for background
  List<Map<String, dynamic>> _planets = [];
  
  @override
  void initState() {
    super.initState();
    
    // Initialize audio players LATER - not in initState for web
    _initializeAudio();
    
    // Initialize animations
    _pulseController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _pulseController.repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _rotationController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );
    _rotationController.repeat();
    
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.linear,
      ),
    );
    
    // Initialize space elements
    _initializeSpace();
    
    _resetTimer();
  }
  
  Future<void> _initializeAudio() async {
    // WEB FIX: Initialize audio players in a delayed manner
    await Future.delayed(Duration(milliseconds: 500));
    
    try {
      if (kIsWeb) {
        // Web-specific initialization
        print('🌐 WEB PLATFORM DETECTED - Using web audio setup');
        
        // Create players
        _backgroundPlayer = AudioPlayer();
        _wakeupPlayer = AudioPlayer();
        
        // Web requires special handling
        await _backgroundPlayer!.setAsset('assets/audio/rain.wav');
        await _wakeupPlayer!.setAsset('assets/audio/bell1.wav');
        
        // Preload for web
        await _backgroundPlayer!.load();
        await _wakeupPlayer!.load();
        
        print('✅ Web audio initialized');
      } else {
        // Mobile/desktop initialization
        _backgroundPlayer = AudioPlayer();
        _wakeupPlayer = AudioPlayer();
        
        await _backgroundPlayer!.setAsset('assets/audio/rain.wav');
        await _wakeupPlayer!.setAsset('assets/audio/bell1.wav');
        
        print('✅ Mobile audio initialized');
      }
      
      // Configure both players
      _backgroundPlayer!.setLoopMode(LoopMode.all);
      _wakeupPlayer!.setLoopMode(LoopMode.all);
      
      _backgroundPlayer!.setVolume(0.3);
      _wakeupPlayer!.setVolume(0.6);
      
      setState(() {
        _audioAvailable = true;
      });
      
      print('🎵 Audio system ready');
      
    } catch (e) {
      print('❌ Audio initialization failed: $e');
      setState(() {
        _audioAvailable = false;
      });
    }
  }
  
  void _initializeSpace() {
    // Create stars
    _stars = List.generate(200, (index) {
      return {
        'x': _random.nextDouble(),
        'y': _random.nextDouble(),
        'size': _random.nextDouble() * 3 + 1,
        'speed': _random.nextDouble() * 0.5 + 0.1,
        'brightness': _random.nextDouble() * 0.7 + 0.3,
        'twinkle': _random.nextDouble() * 2 * math.pi,
      };
    });
    
    // Create planets
    _planets = [
      {
        'x': 0.2,
        'y': 0.3,
        'size': 40,
        'color': Color(0xFF4361EE),
        'speed': 0.001,
      },
      {
        'x': 0.8,
        'y': 0.6,
        'size': 30,
        'color': Color(0xFF7209B7),
        'speed': 0.002,
      },
      {
        'x': 0.4,
        'y': 0.8,
        'size': 25,
        'color': Color(0xFF4ADE80),
        'speed': 0.0015,
      },
    ];
    
    // Animate stars (twinkling)
    _starTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          for (var star in _stars) {
            star['twinkle'] = (star['twinkle']! + 0.1) % (2 * math.pi);
          }
          
          // Move planets
          for (var planet in _planets) {
            planet['x'] = (planet['x']! + planet['speed']!) % 1.0;
          }
        });
      }
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _starTimer?.cancel();
    _pulseController.dispose();
    _rotationController.dispose();
    
    // WEB FIX: Proper disposal
    if (_backgroundPlayer != null) {
      _backgroundPlayer!.dispose();
    }
    if (_wakeupPlayer != null) {
      _wakeupPlayer!.dispose();
    }
    
    super.dispose();
  }
  
  // Play background sound (rain/space sounds)
  Future<void> _playBackgroundSound() async {
    if (!_audioAvailable || _backgroundPlayer == null) return;
    
    try {
      print('🎵 Playing background sound...');
      
      // Stop bell if playing
      if (_isBellPlaying) {
        await _stopBell();
      }
      
      // WEB FIX: Don't reload, just play if already loaded
      if (kIsWeb) {
        // For web, use seek to start
        await _backgroundPlayer!.seek(Duration.zero);
        await _backgroundPlayer!.setVolume(0.3);
        await _backgroundPlayer!.play();
      } else {
        // For mobile, standard approach
        await _backgroundPlayer!.stop();
        await _backgroundPlayer!.setAsset('assets/audio/rain.wav');
        await _backgroundPlayer!.setLoopMode(LoopMode.all);
        await _backgroundPlayer!.setVolume(0.3);
        await _backgroundPlayer!.play();
      }
      
      print('✅ Background sound playing');
    } catch (e) {
      print('❌ Background audio error: $e');
    }
  }
  
  // Play wakeup bell
  Future<void> _playWakeupSound() async {
    if (!_audioAvailable || _wakeupPlayer == null) return;
    
    try {
      print('🔔 Playing wakeup bell...');
      
      // Stop background sound first
      if (_backgroundPlayer != null) {
        await _backgroundPlayer!.stop();
      }
      
      // WEB FIX: Don't reload, just play if already loaded
      if (kIsWeb) {
        await _wakeupPlayer!.seek(Duration.zero);
        await _wakeupPlayer!.setVolume(0.6);
        await _wakeupPlayer!.play();
      } else {
        await _wakeupPlayer!.stop();
        await _wakeupPlayer!.setAsset('assets/audio/bell1.wav');
        await _wakeupPlayer!.setLoopMode(LoopMode.all);
        await _wakeupPlayer!.setVolume(0.6);
        await _wakeupPlayer!.play();
      }
      
      setState(() {
        _isBellPlaying = true;
      });
      
      print('✅ Wakeup bell playing (continuous)');
    } catch (e) {
      print('❌ Wakeup audio error: $e');
    }
  }
  
  // Stop all sounds
  Future<void> _stopAllSounds() async {
    print('🔇 Stopping all sounds...');
    try {
      if (_backgroundPlayer != null) {
        await _backgroundPlayer!.stop();
      }
      if (_wakeupPlayer != null) {
        await _wakeupPlayer!.stop();
      }
      setState(() {
        _isBellPlaying = false;
      });
      print('✅ All sounds stopped');
    } catch (e) {
      // Ignore errors
    }
  }
  
  // Timer control methods
  Future<void> _startTimer() async {
    if (_isRunning) return;
    
    print('🚀 Starting timer...');
    
    setState(() {
      _isRunning = true;
      _isCompleted = false;
      _isBellPlaying = false;
    });
    
    // Start background space sound
    await _playBackgroundSound();
    
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          
          // Update phase
          int minutesPassed = (_selectedMinutes * 60 - _remainingSeconds) ~/ 60;
          _currentPhase = (minutesPassed * _phases.length) ~/ _selectedMinutes;
          _currentPhase = _currentPhase.clamp(0, _phases.length - 1);
          
          // Create shooting star on phase change
          if (_remainingSeconds % (_selectedMinutes * 60 ~/ _phases.length) == 0) {
            _createShootingStar();
          }
        } else {
          _completeTimer();
          timer.cancel();
        }
      });
    });
  }
  
  void _createShootingStar() {
    _stars.add({
      'x': 0.0,
      'y': _random.nextDouble() * 0.3,
      'size': 6.0,
      'speed': 0.05,
      'brightness': 1.0,
      'twinkle': 0.0,
      'isShooting': true,
      'angle': _random.nextDouble() * 0.5 + 0.2,
    });
  }
  
  Future<void> _pauseTimer() async {
    print('⏸️ Pausing timer...');
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
    if (_backgroundPlayer != null) {
      await _backgroundPlayer!.pause();
    }
  }
  
  Future<void> _resetTimer() async {
    print('🔄 Resetting timer...');
    setState(() {
      _isRunning = false;
      _isCompleted = false;
      _isBellPlaying = false;
      _remainingSeconds = _selectedMinutes * 60;
      _currentPhase = 0;
    });
    _timer?.cancel();
    
    await _stopAllSounds();
  }
  
  Future<void> _completeTimer() async {
    print('✅ Timer completed!');
    setState(() {
      _isRunning = false;
      _isCompleted = true;
      _currentPhase = _phases.length - 1;
    });
    
    // Play wake-up bell (continuous until stopped)
    await _playWakeupSound();
    
    // Show completion dialog after delay
    await Future.delayed(Duration(seconds: 2));
    
    if (mounted) {
      _showCompletionDialog();
    }
  }
  
  // Stop the bell manually
  Future<void> _stopBell() async {
    print('🔕 Stopping bell...');
    await _stopAllSounds();
    _resetTimer();
  }
  
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildCompletionDialog(),
    );
  }
  
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  double _getProgress() {
    int totalSeconds = _selectedMinutes * 60;
    return (totalSeconds - _remainingSeconds) / totalSeconds;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF000814),
              Color(0xFF001D3D),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Space background with stars - FIXED: Use List to avoid concurrent modification
            ..._buildStars(),
            
            // Planets
            ..._buildPlanets(),
            
            // Nebula overlay
            _buildNebulaOverlay(),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Space Station Header
                  _buildSpaceHeader(),
                  
                  Expanded(
                    child: SingleChildScrollView( // FIXED: Added scrollable
                      child: Column(
                        children: [
                          // Cosmic Timer (Black Hole)
                          _buildBlackHoleTimer(),
                          
                          SizedBox(height: 30),
                          
                          // Mission Control Panel
                          _buildMissionControl(),
                          
                          SizedBox(height: 30),
                          
                          // Time Warp Selector
                          _buildTimeWarpSelector(),
                          
                          SizedBox(height: 30),
                          
                          // Control Panel (Space Station Controls)
                          _buildControlPanel(),
                          
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildStars() {
    // FIXED: Create a copy to avoid concurrent modification
    List<Map<String, dynamic>> starsCopy = List.from(_stars);
    
    return starsCopy.map((star) {
      double twinkle = math.sin(star['twinkle']!) * 0.3 + 0.7;
      double opacity = star['brightness']! * twinkle;
      
      // Handle shooting stars
      if (star['isShooting'] == true) {
        double x = star['x']!;
        double y = star['y']!;
        star['x'] = x + star['speed']!;
        star['y'] = y + star['angle']! * star['speed']!;
        
        if (x > 1.2) {
          _stars.remove(star);
        }
      }
      
      return Positioned(
        left: star['x']! * MediaQuery.of(context).size.width,
        top: star['y']! * MediaQuery.of(context).size.height,
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: star['size']!,
            height: star['size']!,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  _phases[_currentPhase]['color'].withOpacity(0.5),
                ],
              ),
              boxShadow: star['isShooting'] == true
                  ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: _phases[_currentPhase]['color'].withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
            ),
          ),
        ),
      );
    }).toList();
  }
  
  List<Widget> _buildPlanets() {
    return _planets.map((planet) {
      return Positioned(
        left: planet['x']! * MediaQuery.of(context).size.width,
        top: planet['y']! * MediaQuery.of(context).size.height,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: Container(
            width: planet['size']!.toDouble(),
            height: planet['size']!.toDouble(),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  planet['color'],
                  planet['color'].withOpacity(0.5),
                  planet['color'].withOpacity(0.2),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: planet['color'].withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
  
  Widget _buildNebulaOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.5, 0.3),
            radius: 1.5,
            colors: [
              _phases[_currentPhase]['color'].withOpacity(0.1),
              Colors.transparent,
              Colors.transparent,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSpaceHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.rocket_launch, color: Color(0xFF4CC9F0), size: 16),
                    SizedBox(width: 8),
                    Text(
                      'STATION PRANA',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Deep Space Power Nap Protocol',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _audioAvailable ? Colors.green : Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: (_audioAvailable ? Colors.green : Colors.red)
                          .withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Text(
                kIsWeb ? 'WEB 🔊' : (_isBellPlaying ? 'BELL 🔊' : 'AUDIO'),
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildBlackHoleTimer() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Black hole accretion disk
          RotationTransition(
            turns: _rotationAnimation,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _phases[_currentPhase]['color'].withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: CustomPaint(
                painter: _AccretionDiskPainter(_phases[_currentPhase]['color']),
              ),
            ),
          ),
          
          // Event horizon (main timer)
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.black,
                    Colors.black,
                    _phases[_currentPhase]['color'].withOpacity(0.1),
                  ],
                  stops: [0.0, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _phases[_currentPhase]['color'].withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Progress ring (spaghettification effect)
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: _getProgress(),
                      strokeWidth: 6,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _phases[_currentPhase]['color'],
                      ),
                    ),
                  ),
                  
                  // Time display
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Courier',
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              blurRadius: 15,
                              color: _phases[_currentPhase]['color'],
                            ),
                            Shadow(
                              blurRadius: 30,
                              color: _phases[_currentPhase]['color'].withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _phases[_currentPhase]['color'].withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _phases[_currentPhase]['color'].withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _phases[_currentPhase]['name'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Orbiting satellites
          ..._buildOrbitingSatellites(),
        ],
      ),
    );
  }
  
  List<Widget> _buildOrbitingSatellites() {
    return List.generate(4, (index) {
      double angle = index * (math.pi / 2) + _pulseController.value * 2 * math.pi;
      double radius = 150;
      
      return Positioned(
        left: 130 + radius * math.cos(angle),
        top: 130 + radius * math.sin(angle),
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white,
                _phases[_currentPhase]['color'],
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _phases[_currentPhase]['color'].withOpacity(0.8),
                blurRadius: 15,
              ),
            ],
          ),
        ),
      );
    });
  }
  
  Widget _buildMissionControl() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.6),
            _phases[_currentPhase]['color'].withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _phases[_currentPhase]['color'].withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _phases[_currentPhase]['color'].withOpacity(0.1),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            _phases[_currentPhase]['icon'],
            color: _phases[_currentPhase]['color'],
            size: 40,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRunning ? Colors.green : Colors.orange,
                        boxShadow: [
                          BoxShadow(
                            color: (_isRunning ? Colors.green : Colors.orange)
                                .withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'MISSION STATUS',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  _phases[_currentPhase]['name'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  _phases[_currentPhase]['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      'SPACE PHASE ${_currentPhase + 1}/${_phases.length}',
                      style: TextStyle(
                        fontSize: 10,
                        color: _phases[_currentPhase]['color'],
                        letterSpacing: 1,
                      ),
                    ),
                    Spacer(),
                    ...List.generate(_phases.length, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index <= _currentPhase
                              ? _phases[_currentPhase]['color']
                              : Colors.white.withOpacity(0.1),
                          boxShadow: index <= _currentPhase
                              ? [
                                  BoxShadow(
                                    color: _phases[_currentPhase]['color']
                                        .withOpacity(0.5),
                                    blurRadius: 5,
                                  ),
                                ]
                              : [],
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimeWarpSelector() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'SELECT TIME WARP DURATION',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              letterSpacing: 3,
            ),
          ),
        ),
        SizedBox(height: 15),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [5, 10, 15, 20].map((minutes) {
            bool isSelected = _selectedMinutes == minutes;
            return GestureDetector(
              onTap: !_isRunning ? () {
                setState(() {
                  _selectedMinutes = minutes;
                  _resetTimer();
                });
              } : null,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            _phases[_currentPhase]['color'],
                            _phases[_currentPhase]['color'].withOpacity(0.7),
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.05),
                            Colors.white.withOpacity(0.02),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.1),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _phases[_currentPhase]['color'].withOpacity(0.5),
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Text(
                      '$minutes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.white70,
                        fontFamily: 'Courier',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'LIGHT YEARS',
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.white : Colors.white60,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildControlPanel() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'STATION CONTROLS',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Emergency Stop (only when bell is ringing)
              if (_isBellPlaying)
                _buildControlButton(
                  icon: Icons.emergency,
                  label: 'SILENCE BELL',
                  color: Colors.red,
                  onPressed: _stopBell,
                  isLarge: true,
                )
              else
                _buildControlButton(
                  icon: Icons.replay,
                  label: 'RESET',
                  color: Colors.blue,
                  onPressed: _isRunning || _isCompleted ? null : _resetTimer,
                ),
              
              // Main Control
              _buildMainControl(),
              
              // Stop Control
              _buildControlButton(
                icon: Icons.stop,
                label: 'ABORT',
                color: Colors.orange,
                onPressed: _isRunning ? _completeTimer : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
    bool isLarge = false,
  }) {
    return Column(
      children: [
        Container(
          width: isLarge ? 80 : 60,
          height: isLarge ? 80 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.3),
                Colors.transparent,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(icon, size: isLarge ? 30 : 24),
            color: Colors.white,
            onPressed: onPressed,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMainControl() {
    Color controlColor = _isRunning ? Colors.red : Color(0xFF4CC9F0);
    String label = _isRunning ? 'PAUSE' : 'LAUNCH';
    
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                controlColor,
                controlColor.withOpacity(0.5),
                controlColor.withOpacity(0.2),
                Colors.transparent,
              ],
              stops: [0.0, 0.3, 0.6, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: controlColor.withOpacity(0.4),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: IconButton(
            icon: Icon(
              _isRunning ? Icons.pause : Icons.play_arrow,
              size: 36,
            ),
            color: Colors.white,
            onPressed: () {
              if (_isRunning) {
                _pauseTimer();
              } else {
                _startTimer();
              }
            },
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCompletionDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF000814).withOpacity(0.95),
              Color(0xFF001D3D).withOpacity(0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Color(0xFF4CC9F0).withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF4CC9F0).withOpacity(0.3),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Supernova celebration
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF4CC9F0).withOpacity(0.9),
                    Color(0xFF7209B7).withOpacity(0.7),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF4CC9F0).withOpacity(0.6),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(Icons.rocket_launch, color: Colors.white, size: 50),
            ),
            
            SizedBox(height: 20),
            
            Text(
              'MISSION ACCOMPLISHED!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
                fontFamily: 'Courier',
              ),
            ),
            
            SizedBox(height: 10),
            
            Text(
              'You have successfully completed\na deep space power nap',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            
            SizedBox(height: 20),
            
            // Benefits display
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF4CC9F0).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  _buildBenefitRow('⚡ ENERGY BOOST', '+85%', Colors.yellow),
                  SizedBox(height: 10),
                  _buildBenefitRow('🎯 FOCUS LEVEL', '+70%', Colors.blue),
                  SizedBox(height: 10),
                  _buildBenefitRow('😌 STRESS REDUCTION', '-60%', Colors.green),
                  SizedBox(height: 10),
                  _buildBenefitRow('✨ MOOD ELEVATION', '+50%', Colors.pink),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _stopBell,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.8),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'SILENCE BELL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _stopBell();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CC9F0),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'NEW MISSION',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBenefitRow(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for accretion disk
class _AccretionDiskPainter extends CustomPainter {
  final Color color;
  
  _AccretionDiskPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Draw multiple concentric rings
    for (int i = 0; i < 20; i++) {
      double radius = 80 + i * 5;
      paint.color = color.withOpacity(0.05 + i * 0.02);
      canvas.drawCircle(center, radius, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}