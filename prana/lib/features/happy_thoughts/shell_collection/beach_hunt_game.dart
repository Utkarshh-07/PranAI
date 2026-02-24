import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'dart:async';
import 'dart:ui' as ui;

import 'package:prana/features/happy_thoughts/shell_collection/models/shell_model.dart';

class EnhancedBeachHuntGame extends StatefulWidget {
  final Function(Shell) onShellFound;
  final int playerLevel;
  
  const EnhancedBeachHuntGame({
    Key? key,
    required this.onShellFound,
    this.playerLevel = 1,
  }) : super(key: key);
  
  @override
  _EnhancedBeachHuntGameState createState() => _EnhancedBeachHuntGameState();
}

class _EnhancedBeachHuntGameState extends State<EnhancedBeachHuntGame> 
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  
  // ============ SINGLE MASTER CONTROLLER ============
  // ✅ FIXED: Use ONE controller and derive all animations from it
  late AnimationController _masterController;
  
  // ============ DERIVED ANIMATIONS ============
  late Animation<double> _waveAnimation;
  late Animation<double> _sunRaysAnimation;
  late Animation<double> _sandGlitterAnimation;
  late Animation<double> _tideAnimation;
  late Animation<double> _cloudAnimation;
  late Animation<double> _sparkleAnimation;
  late Animation<double> _glowPulseAnimation;
  late Animation<Offset> _sunPosition;
  
  // ============ TIMERS ============
  Timer? _energyTimer;
  Timer? _particleTimer;
  Timer? _eventTimer;
  Timer? _rippleTimer;
  Timer? _creatureTimer;
  
  // ============ GAME STATE ============
  List<ShellSpot> _shellSpots = [];
  List<BrushStroke> _brushStrokes = [];
  List<Particle> _particles = [];
  List<SpecialItem> _specialItems = [];
  List<Footprint> _footprints = [];
  List<WaterRipple> _waterRipples = [];
  List<SandSparkle> _sandSparkles = [];
  
  bool _isDragging = false;
  Offset? _lastDragOffset;
  double _sandCoverage = 1.0;
  int _foundShellsCount = 0;
  Shell? _currentFoundShell;
  bool _isFindingShell = false;
  int _shellsFoundThisSession = 0;  // ✅ FIXED: Added missing variable
  
  // ============ PLAYER STATS ============
  int _playerEnergy = 100;
  int _playerCoins = 0;
  bool _hasMagnifyingGlass = false;
  bool _hasShovel = false;
  int _streakBonus = 1;
  
  // ============ ENVIRONMENT STATE ============
  BeachTheme _currentTheme = BeachTheme.sunny;
  TideState _tideState = TideState.low;
  WeatherType _currentWeather = WeatherType.clear;
  TimeOfDay _currentTimeOfDay = TimeOfDay.sunrise;
  
  // ============ DYNAMIC ELEMENTS ============
  List<Cloud> _clouds = [];
  List<Seagull> _seagulls = [];
  List<BeachCreature> _beachCreatures = [];
  List<Wave> _waves = [];
  
  // ============ SPECIAL EFFECTS ============
  bool _isSpecialEventActive = false;
  String? _currentEvent;
  DateTime? _eventEndTime;
  double _globalGlowIntensity = 0.0;
  
  // ============ TOOLS ============
  GameTool _selectedTool = GameTool.hand;
  List<GameTool> _unlockedTools = [GameTool.hand];
  
  // ============ TEXTURE CACHE ============
  bool _texturesLoaded = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _initializeControllers();
    _initializeEnvironment();
    _initializeGameElements();
    _startGameTimers();
    _loadTextures();
    _generateSandSparkles();
  }
  
  // ============ INITIALIZATION ============
  
  void _initializeControllers() {
    // ✅ FIXED: Single master controller for all animations
    _masterController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    // Derive all animations from master controller
    _waveAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -20.0, end: 20.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 20.0, end: -20.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _masterController,
      curve: Curves.easeInOutSine,
    ));
    
    _sunRaysAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: Curves.easeInOut,
    ))..addListener(() { setState(() {}); });
    
    _sandGlitterAnimation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: Curves.easeInOut,
    ));
    
    _tideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: Curves.easeInOut,
    ));
    
    _cloudAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: Curves.linear,
    ));
    
    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: Curves.linear,
    ));
    
    _glowPulseAnimation = Tween<double>(
      begin: 0.7,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: Curves.easeInOut,
    ));
    
    _sunPosition = Tween<Offset>(
      begin: const Offset(-0.1, 0.1),
      end: const Offset(1.1, 0.3),
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: Curves.easeInOut,
    ));
  }
  
  void _initializeEnvironment() {
    final now = DateTime.now();
    final hour = now.hour;
    
    // Set time of day
    if (hour >= 5 && hour < 8) {
      _currentTimeOfDay = TimeOfDay.sunrise;
      _currentTheme = BeachTheme.sunrise;
    } else if (hour >= 8 && hour < 11) {
      _currentTimeOfDay = TimeOfDay.morning;
      _currentTheme = BeachTheme.sunny;
    } else if (hour >= 11 && hour < 16) {
      _currentTimeOfDay = TimeOfDay.afternoon;
      _currentTheme = BeachTheme.sunny;
    } else if (hour >= 16 && hour < 19) {
      _currentTimeOfDay = TimeOfDay.sunset;
      _currentTheme = BeachTheme.sunset;
    } else if (hour >= 19 && hour < 21) {
      _currentTimeOfDay = TimeOfDay.evening;
      _currentTheme = BeachTheme.sunset;
    } else {
      _currentTimeOfDay = TimeOfDay.night;
      _currentTheme = BeachTheme.moonlight;
    }
    
    // Set random weather
    final random = Random();
    final weatherRoll = random.nextDouble();
    if (weatherRoll < 0.6) {
      _currentWeather = WeatherType.clear;
    } else if (weatherRoll < 0.8) {
      _currentWeather = WeatherType.partlyCloudy;
    } else if (weatherRoll < 0.95) {
      _currentWeather = WeatherType.cloudy;
    } else {
      _currentWeather = WeatherType.lightRain;
    }
    
    // Calculate tide
    _tideState = _calculateTideState();
  }
  
  void _initializeGameElements() {
    _generateClouds();
    _generateSeagulls();
    _generateWaves();
    _initializeBeachCreatures();
    _generateShells();
    _generateSpecialItems();
  }
  
  void _generateClouds() {
    final random = Random();
    final cloudCount = _currentWeather == WeatherType.clear ? 2 :
                      _currentWeather == WeatherType.partlyCloudy ? 4 :
                      _currentWeather == WeatherType.cloudy ? 6 : 3;
    
    for (int i = 0; i < cloudCount; i++) {
      _clouds.add(Cloud(
        position: Offset(
          random.nextDouble(),
          random.nextDouble() * 0.3,
        ),
        size: 60 + random.nextDouble() * 60,
        speed: 0.02 + random.nextDouble() * 0.03,
        opacity: 0.6 + random.nextDouble() * 0.3,
        type: CloudType.values[random.nextInt(CloudType.values.length)],
      ));
    }
  }
  
  void _generateSeagulls() {
    final random = Random();
    for (int i = 0; i < 3; i++) {
      _seagulls.add(Seagull(
        position: Offset(
          random.nextDouble(),
          0.1 + random.nextDouble() * 0.2,
        ),
        speed: 0.5 + random.nextDouble() * 0.5,
        wingPhase: random.nextDouble() * 2 * pi,
      ));
    }
  }
  
  void _generateWaves() {
    for (int i = 0; i < 5; i++) {
      _waves.add(Wave(
        amplitude: 10 + i * 5,
        frequency: 0.02 + i * 0.01,
        phase: i * 0.5,
        speed: 0.1,
      ));
    }
  }
  
  void _generateSandSparkles() {
    final random = Random();
    for (int i = 0; i < 100; i++) {
      _sandSparkles.add(SandSparkle(
        position: Offset(
          random.nextDouble(),
          0.4 + random.nextDouble() * 0.5,
        ),
        size: 1 + random.nextDouble() * 3,
        phase: random.nextDouble() * 2 * pi,
        speed: 0.5 + random.nextDouble() * 0.5,
      ));
    }
  }
  
  void _initializeBeachCreatures() {
    final random = Random();
    
    // Crabs
    for (int i = 0; i < 3; i++) {
      _beachCreatures.add(BeachCreature(
        type: BeachCreatureType.crab,
        position: Offset(
          0.2 + random.nextDouble() * 0.6,
          0.7 + random.nextDouble() * 0.2,
        ),
        direction: random.nextDouble() > 0.5 ? 1 : -1,
        speed: 0.3 + random.nextDouble() * 0.4,
        animationPhase: random.nextDouble() * 2 * pi,
      ));
    }
    
    // Starfish
    for (int i = 0; i < 5; i++) {
      _beachCreatures.add(BeachCreature(
        type: BeachCreatureType.starfish,
        position: Offset(
          0.1 + random.nextDouble() * 0.8,
          0.75 + random.nextDouble() * 0.15,
        ),
        direction: 0,
        speed: 0,
        animationPhase: random.nextDouble() * 2 * pi,
      ));
    }
    
    // Seagulls on beach
    for (int i = 0; i < 2; i++) {
      _beachCreatures.add(BeachCreature(
        type: BeachCreatureType.seagull,
        position: Offset(
          0.3 + random.nextDouble() * 0.4,
          0.65 + random.nextDouble() * 0.1,
        ),
        direction: 0,
        speed: 0,
        animationPhase: random.nextDouble() * 2 * pi,
      ));
    }
    
    // Dolphins (only in clear weather)
    if (_currentWeather == WeatherType.clear && random.nextDouble() > 0.5) {
      _beachCreatures.add(BeachCreature(
        type: BeachCreatureType.dolphin,
        position: const Offset(-0.2, 0.2),
        direction: 1,
        speed: 0.6,
        animationPhase: 0,
      ));
    }
  }
  
  void _generateShells() {
    final random = Random();
    final shellCount = 8 + widget.playerLevel + random.nextInt(5);
    
    for (int i = 0; i < shellCount; i++) {
      final x = 0.1 + random.nextDouble() * 0.8;
      final y = 0.45 + random.nextDouble() * 0.4;
      final depth = random.nextDouble();
      
      _shellSpots.add(ShellSpot(
        position: Offset(x, y),
        isFound: false,
        glowIntensity: 0.0,
        shellType: _getRandomShellType(widget.playerLevel),
        depth: depth,
        rarityMultiplier: 1.0,
        rotation: random.nextDouble() * 2 * pi,
        scale: 0.8 + random.nextDouble() * 0.6,
      ));
    }
  }
  
  void _generateSpecialItems() {
    final random = Random();
    
    if (widget.playerLevel >= 2 && !_hasMagnifyingGlass) {
      _specialItems.add(SpecialItem(
        type: SpecialItemType.magnifyingGlass,
        position: Offset(0.85, 0.25),
        isCollected: false,
        rotation: 0.2,
        pulsePhase: random.nextDouble() * 2 * pi,
      ));
    }
    
    if (widget.playerLevel >= 3 && !_hasShovel) {
      _specialItems.add(SpecialItem(
        type: SpecialItemType.shovel,
        position: Offset(0.12, 0.3),
        isCollected: false,
        rotation: -0.1,
        pulsePhase: random.nextDouble() * 2 * pi,
      ));
    }
    
    // Random treasure chest
    if (random.nextDouble() > 0.7) {
      _specialItems.add(SpecialItem(
        type: SpecialItemType.treasureChest,
        position: Offset(
          0.2 + random.nextDouble() * 0.6,
          0.5 + random.nextDouble() * 0.3,
        ),
        isCollected: false,
        rotation: 0,
        pulsePhase: random.nextDouble() * 2 * pi,
      ));
    }
  }
  
  Future<void> _loadTextures() async {
    try {
      await Future.wait([
        precacheImage(const AssetImage('assets/images/beach_textures/sand_base.jpg'), context),
        precacheImage(const AssetImage('assets/images/beach_textures/sand_normal.jpg'), context),
      ]);
      setState(() {
        _texturesLoaded = true;
      });
    } catch (e) {
      print('Error loading textures: $e');
    }
  }
  
  // ============ GAME LOGIC ============
  
  void _startGameTimers() {
    // ✅ FIXED: Single timer for energy
    _energyTimer?.cancel();
    _energyTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_playerEnergy < 100 && mounted) {
        setState(() {
          _playerEnergy = (_playerEnergy + 5).clamp(0, 100);
        });
      }
    });
    
    // ✅ FIXED: Single timer for particles
    _particleTimer?.cancel();
    _particleTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        _updateParticles();
      }
    });
    
    // ✅ FIXED: Single timer for events
    _eventTimer?.cancel();
    _eventTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isSpecialEventActive && Random().nextDouble() < 0.2 && mounted) {
        _startSpecialEvent();
      }
    });
    
    // ✅ FIXED: Single timer for ripples
    _rippleTimer?.cancel();
    _rippleTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_waterRipples.length < 10 && mounted) {
        _addRandomWaterRipple();
        if (mounted) setState(() {});
      }
    });
    
    // ✅ FIXED: Single timer for creatures
    _creatureTimer?.cancel();
    _creatureTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        _updateBeachCreatures();
      }
    });
  }
  
  void _updateParticles() {
    bool needsUpdate = false;
    
    for (int i = _particles.length - 1; i >= 0; i--) {
      final particle = _particles[i];
      particle.lifetime -= 0.016;
      particle.position = Offset(
        particle.position.dx + particle.velocity.dx,
        particle.position.dy + particle.velocity.dy,
      );
      particle.velocity = Offset(
        particle.velocity.dx * 0.98,
        particle.velocity.dy * 0.98 + 0.001,
      );
      particle.opacity = particle.lifetime;
      
      if (particle.lifetime <= 0) {
        _particles.removeAt(i);
        needsUpdate = true;
      }
    }
    
    for (int i = _waterRipples.length - 1; i >= 0; i--) {
      final ripple = _waterRipples[i];
      ripple.lifetime -= 0.016;
      ripple.radius += 2;
      
      if (ripple.lifetime <= 0) {
        _waterRipples.removeAt(i);
        needsUpdate = true;
      }
    }
    
    if (needsUpdate && mounted) {
      setState(() {});
    }
  }
  
  void _updateBeachCreatures() {
    bool needsUpdate = false;
    
    for (var creature in _beachCreatures) {
      if (creature.type == BeachCreatureType.crab) {
        creature.position = Offset(
          creature.position.dx + (creature.direction * creature.speed * 0.01),
          creature.position.dy,
        );
        
        if (creature.position.dx < 0.1 || creature.position.dx > 0.9) {
          creature.direction *= -1;
          needsUpdate = true;
        }
      } else if (creature.type == BeachCreatureType.dolphin) {
        creature.position = Offset(
          creature.position.dx + (creature.direction * creature.speed * 0.02),
          creature.position.dy,
        );
        
        if (creature.position.dx > 1.1) {
          creature.position = Offset(-0.1, creature.position.dy);
          needsUpdate = true;
        }
      }
    }
    
    if (needsUpdate && mounted) {
      setState(() {});
    }
  }
  
  void _addRandomWaterRipple() {
    final random = Random();
    _waterRipples.add(WaterRipple(
      position: Offset(
        random.nextDouble(),
        0.15 + random.nextDouble() * 0.1,
      ),
      radius: 5,
      lifetime: 1.0,
    ));
  }
  
  void _startSpecialEvent() {
    if (_isSpecialEventActive) return;
    
    final events = [
      'golden_hour',
      'bioluminescence',
      'treasure_tide',
      'crab_parade',
      'dolphin_visit',
    ];
    
    _currentEvent = events[Random().nextInt(events.length)];
    _isSpecialEventActive = true;
    _eventEndTime = DateTime.now().add(const Duration(seconds: 45));
    
    switch (_currentEvent) {
      case 'golden_hour':
        _globalGlowIntensity = 0.8;
        _streakBonus = 3;
        break;
      case 'bioluminescence':
        _globalGlowIntensity = 1.2;
        for (var spot in _shellSpots) {
          spot.glowIntensity = 0.3;
          spot.rarityMultiplier = 1.5;
        }
        break;
      case 'treasure_tide':
        _addTreasureChest();
        break;
      case 'crab_parade':
        _startCrabParade();
        break;
    }
    
    if (mounted) setState(() {});
    
    Timer(const Duration(seconds: 45), () {
      _endSpecialEvent();
    });
  }
  
  void _endSpecialEvent() {
    _isSpecialEventActive = false;
    _globalGlowIntensity = 0.0;
    _streakBonus = 1;
    _currentEvent = null;
    _eventEndTime = null;
    
    for (var spot in _shellSpots) {
      spot.rarityMultiplier = 1.0;
      if (!spot.isFound) {
        spot.glowIntensity = 0.0;
      }
    }
    
    if (mounted) setState(() {});
  }
  
  void _addTreasureChest() {
    _specialItems.add(SpecialItem(
      type: SpecialItemType.treasureChest,
      position: Offset(0.5, 0.6),
      isCollected: false,
      rotation: 0,
      pulsePhase: 0,
    ));
  }
  
  void _startCrabParade() {
    for (var creature in _beachCreatures) {
      if (creature.type == BeachCreatureType.crab) {
        creature.direction = 1;
        creature.speed = 1.0;
      }
    }
  }
  
  TideState _calculateTideState() {
    final now = DateTime.now();
    final hour = now.hour + now.minute / 60.0;
    final tideValue = sin(hour * pi / 6);
    
    if (tideValue < -0.5) return TideState.low;
    if (tideValue < 0) return TideState.rising;
    if (tideValue < 0.5) return TideState.high;
    return TideState.falling;
  }
  
  // ============ INTERACTION HANDLERS ============
  
  void _onPanStart(DragStartDetails details) {
    if (_playerEnergy <= 0) return;
    
    setState(() {
      _isDragging = true;
      _lastDragOffset = details.localPosition;
    });
  }
  
  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging || _playerEnergy <= 0) return;
    
    final currentOffset = details.localPosition;
    final size = MediaQuery.of(context).size;
    
    final brushSize = _getBrushSize();
    final energyCost = _getEnergyCost();
    
    _brushStrokes.add(BrushStroke(
      start: _lastDragOffset!,
      end: currentOffset,
      timestamp: DateTime.now(),
      tool: _selectedTool,
      size: brushSize,
    ));
    
    _addSandParticles(currentOffset, brushSize);
    
    if (_selectedTool == GameTool.hand && Random().nextDouble() < 0.3) {
      _addFootprint(currentOffset);
    }
    
    _checkForInteractions(currentOffset, brushSize);
    
    setState(() {
      _sandCoverage = (_sandCoverage - 0.0003 * brushSize).clamp(0.2, 1.0);
      _playerEnergy = (_playerEnergy - energyCost).clamp(0, 100);
      _lastDragOffset = currentOffset;
      
      if (_brushStrokes.length > 100) {
        _brushStrokes.removeRange(0, 30);
      }
      if (_footprints.length > 50) {
        _footprints.removeRange(0, 20);
      }
    });
  }
  
  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
      _lastDragOffset = null;
    });
  }
  
  double _getBrushSize() {
    switch (_selectedTool) {
      case GameTool.hand: return 35.0;
      case GameTool.magnifyingGlass: return 55.0;
      case GameTool.shovel: return 70.0;
      case GameTool.net: return 45.0;
      case GameTool.metalDetector: return 90.0;
    }
  }
  
  int _getEnergyCost() {
    switch (_selectedTool) {
      case GameTool.hand: return 1;
      case GameTool.magnifyingGlass: return 2;
      case GameTool.shovel: return 4;
      case GameTool.net: return 2;
      case GameTool.metalDetector: return 6;
    }
  }
  
  void _addSandParticles(Offset position, double brushSize) {
    final random = Random();
    final particleCount = (brushSize / 5).round();
    
    for (int i = 0; i < particleCount; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 2 + random.nextDouble() * 4;
      
      _particles.add(Particle(
        position: Offset(
          position.dx / MediaQuery.of(context).size.width,
          position.dy / MediaQuery.of(context).size.height,
        ),
        velocity: Offset(
          cos(angle) * speed * 0.001,
          sin(angle) * speed * 0.001 - 0.005,
        ),
        color: _getSandColor(),
        size: 2 + random.nextDouble() * 4,
        lifetime: 0.8 + random.nextDouble() * 0.6,
        opacity: 0.8,
      ));
    }
  }
  
  void _addFootprint(Offset position) {
    _footprints.add(Footprint(
      position: Offset(
        position.dx / MediaQuery.of(context).size.width,
        position.dy / MediaQuery.of(context).size.height,
      ),
      rotation: Random().nextDouble() * 0.2 - 0.1,
      timestamp: DateTime.now(),
      opacity: 0.7,
    ));
  }
  
  void _checkForInteractions(Offset position, double brushSize) {
    final size = MediaQuery.of(context).size;
    final normalizedPos = Offset(
      position.dx / size.width,
      position.dy / size.height,
    );
    
    for (var spot in _shellSpots) {
      if (spot.isFound) continue;
      
      final distance = (normalizedPos - spot.position).distance;
      final effectiveRange = brushSize / size.width * 1.5;
      
      if (distance < effectiveRange) {
        double revealSpeed = _getRevealSpeed();
        spot.glowIntensity = (spot.glowIntensity + revealSpeed).clamp(0.0, 1.0);
        
        if (spot.glowIntensity >= 1.0) {
          _findShell(spot);
        }
      }
    }
    
    for (var item in _specialItems) {
      if (item.isCollected) continue;
      
      final distance = (normalizedPos - item.position).distance;
      if (distance < 0.05) {
        _collectSpecialItem(item);
      }
    }
    
    for (var creature in _beachCreatures) {
      final distance = (normalizedPos - creature.position).distance;
      if (distance < 0.06) {
        _interactWithCreature(creature);
      }
    }
  }
  
  double _getRevealSpeed() {
    switch (_selectedTool) {
      case GameTool.shovel: return 0.12;
      case GameTool.metalDetector: return 0.08;
      case GameTool.magnifyingGlass: return 0.06;
      case GameTool.net: return 0.04;
      case GameTool.hand: return 0.03;
    }
  }
  
  void _findShell(ShellSpot spot) {
    spot.isFound = true;
    _foundShellsCount++;
    _shellsFoundThisSession++;
    
    final shell = _createShellFromSpot(spot);
    
    _addCelebrationParticles(spot.position);
    
    setState(() {
      _currentFoundShell = shell;
      _isFindingShell = true;
    });
    
    if (_shellsFoundThisSession > 1) {
      _streakBonus = (_streakBonus + 1).clamp(1, 5);
    }
  }
  
  void _addCelebrationParticles(Offset position) {
    final random = Random();
    final size = MediaQuery.of(context).size;
    final screenPos = Offset(
      position.dx * size.width,
      position.dy * size.height,
    );
    
    for (int i = 0; i < 20; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 5 + random.nextDouble() * 5;
      
      _particles.add(Particle(
        position: Offset(
          screenPos.dx / size.width,
          screenPos.dy / size.height,
        ),
        velocity: Offset(
          cos(angle) * speed * 0.001,
          sin(angle) * speed * 0.001,
        ),
        color: Colors.yellow,
        size: 3 + random.nextDouble() * 4,
        lifetime: 1.2,
        opacity: 1.0,
      ));
    }
  }
  
  Shell _createShellFromSpot(ShellSpot spot) {
    final rarity = spot.shellType;
    final random = Random();
    final effectiveRarity = _applyRarityMultiplier(rarity, spot.rarityMultiplier);
    
    return Shell(
      id: 'shell_${DateTime.now().millisecondsSinceEpoch}',
      name: _getShellName(effectiveRarity),
      emoji: _getShellEmoji(effectiveRarity),
      rarity: effectiveRarity,
      category: ShellCategory.SEASHELL,
      glowColor: _getShellColor(effectiveRarity),
      description: _generateShellDescription(effectiveRarity, spot.depth),
      discoveredAt: DateTime.now(),
      discoveredIn: 'Beach Hunt',
      gradientColors: _getShellGradient(effectiveRarity),
      specialEffect: _getShellEffect(effectiveRarity),
      size: 0.8 + random.nextDouble() * 0.4,
    );
  }
  
  void _collectSpecialItem(SpecialItem item) {
    item.isCollected = true;
    
    switch (item.type) {
      case SpecialItemType.magnifyingGlass:
        _hasMagnifyingGlass = true;
        _unlockedTools.add(GameTool.magnifyingGlass);
        break;
      case SpecialItemType.shovel:
        _hasShovel = true;
        _unlockedTools.add(GameTool.shovel);
        break;
      case SpecialItemType.treasureChest:
        _playerCoins += 500;
        break;
      case SpecialItemType.fishingNet:
        _unlockedTools.add(GameTool.net);
        break;
    }
    
    _addCelebrationParticles(item.position);
    if (mounted) setState(() {});
  }
  
  void _interactWithCreature(BeachCreature creature) {
    switch (creature.type) {
      case BeachCreatureType.crab:
        _playerCoins += 15;
        creature.direction *= -1;
        break;
      case BeachCreatureType.starfish:
        _playerEnergy = (_playerEnergy + 10).clamp(0, 100);
        break;
      case BeachCreatureType.seagull:
        _revealNearestShell();
        break;
      case BeachCreatureType.dolphin:
        _playerEnergy = (_playerEnergy + 30).clamp(0, 100);
        break;
      case BeachCreatureType.turtle:
        _streakBonus = (_streakBonus + 1).clamp(1, 5);
        break;
    }
    
    if (mounted) setState(() {});
  }
  
  void _revealNearestShell() {
    for (var spot in _shellSpots) {
      if (!spot.isFound && spot.glowIntensity < 0.5) {
        spot.glowIntensity = 0.5;
        break;
      }
    }
    if (mounted) setState(() {});
  }
  
  // ============ HELPER METHODS ============
  
  Color _getTimeBasedTint() {
    switch (_currentTimeOfDay) {
      case TimeOfDay.sunrise: return const Color(0xFFFFB74D).withOpacity(0.25);
      case TimeOfDay.morning: return const Color(0xFFFFF9C4).withOpacity(0.15);
      case TimeOfDay.afternoon: return Colors.white.withOpacity(0.1);
      case TimeOfDay.sunset: return const Color(0xFFFF8A65).withOpacity(0.25);
      case TimeOfDay.evening: return const Color(0xFF9575CD).withOpacity(0.2);
      case TimeOfDay.night: return const Color(0xFF4A148C).withOpacity(0.15);
    }
  }
  
  Color _getSandColor() {
    switch (_tideState) {
      case TideState.low: return const Color(0xFFF4E3C6);
      case TideState.rising: return const Color(0xFFE9D4B0);
      case TideState.high: return const Color(0xFFD4B48C);
      case TideState.falling: return const Color(0xFFE9D4B0);
    }
  }
  
  double _getTideHeight() {
    switch (_tideState) {
      case TideState.low: return 0.0;
      case TideState.rising: return 0.3 + sin(_tideAnimation.value * pi) * 0.1;
      case TideState.high: return 0.6;
      case TideState.falling: return 0.3 - sin(_tideAnimation.value * pi) * 0.1;
    }
  }
  
  LinearGradient _getSkyGradient() {
    switch (_currentTimeOfDay) {
      case TimeOfDay.sunrise:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Color(0xFFFF7E5F),
            Color(0xFFFEB47B),
            Color(0xFFFFE47A),
            Color(0xFFB4E1FF),
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        );
      case TimeOfDay.morning:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87CEEB),
            Color(0xFFB0E2FF),
            Color(0xFFFFF0DB),
          ],
        );
      case TimeOfDay.afternoon:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4AA3DF),
            Color(0xFF87CEEB),
            Color(0xFFFFF4D2),
          ],
        );
      case TimeOfDay.sunset:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4834D4),
            Color(0xFFFF6B6B),
            Color(0xFFFFB88C),
            Color(0xFFFCE38A),
          ],
          stops: [0.0, 0.4, 0.7, 1.0],
        );
      case TimeOfDay.evening:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF303F9F),
            Color(0xFF5C6BC0),
            Color(0xFF7986CB),
          ],
        );
      case TimeOfDay.night:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D2B4D),
            Color(0xFF1A3A5F),
            Color(0xFF274A6F),
            Colors.black54,
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        );
    }
  }
  
  List<Color> _getOceanColors() {
    switch (_currentTimeOfDay) {
      case TimeOfDay.sunrise:
        return const [
          Color(0xFF4ECDC4),
          Color(0xFF1E90FF),
          Color(0xFF0A4B7A),
        ];
      case TimeOfDay.morning:
        return const [
          Color(0xFF6DC8F3),
          Color(0xFF3399FF),
          Color(0xFF1E5F8E),
        ];
      case TimeOfDay.afternoon:
        return const [
          Color(0xFF4AA3DF),
          Color(0xFF1E88E5),
          Color(0xFF0D47A1),
        ];
      case TimeOfDay.sunset:
        return const [
          Color(0xFF9370DB),
          Color(0xFF4169E1),
          Color(0xFF191970),
        ];
      case TimeOfDay.evening:
        return const [
          Color(0xFF5C6BC0),
          Color(0xFF3949AB),
          Color(0xFF1A237E),
        ];
      case TimeOfDay.night:
        return const [
          Color(0xFF1A237E),
          Color(0xFF0D1642),
          Color(0xFF03081A),
        ];
    }
  }
  
  // ============ BUILD METHODS ============
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. SKY GRADIENT
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: _getSkyGradient(),
            ),
            child: Stack(
              children: [
                _buildSunMoon(),
                if (_currentTimeOfDay == TimeOfDay.night) _buildStars(),
                ..._clouds.map((cloud) => _buildCloud(cloud, size)),
                ..._seagulls.map((seagull) => _buildSeagull(seagull, size)),
              ],
            ),
          ),
          
          // 2. ATMOSPHERIC EFFECTS
          if (_currentWeather == WeatherType.lightRain) _buildRainEffect(size),
          if (_isSpecialEventActive) _buildSpecialEventEffect(size),
          
          // 3. OCEAN WITH WAVES
          _buildOcean(size),
          
          // 4. BEACH SAND
          _buildBeach(size),
          
          // 5. WATER RIPPLES
          ..._waterRipples.map((ripple) => _buildWaterRipple(ripple, size)),
          
          // 6. FOOTPRINTS
          ..._footprints.map((footprint) => _buildFootprint(footprint, size)),
          
          // 7. BEACH CREATURES
          ..._beachCreatures.map((creature) => _buildBeachCreature(creature, size)),
          
          // 8. SAND SPARKLES
          ..._sandSparkles.map((sparkle) => _buildSandSparkle(sparkle, size)),
          
          // 9. SHELLS
          ..._shellSpots.where((spot) => !spot.isFound).map((spot) => 
            _buildShellSpot(spot, size)
          ),
          
          // 10. SPECIAL ITEMS
          ..._specialItems.where((item) => !item.isCollected).map((item) =>
            _buildSpecialItem(item, size)
          ),
          
          // 11. INTERACTIVE LAYER
          Positioned.fill(
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                painter: InteractivePainter(
                  brushStrokes: _brushStrokes,
                ),
              ),
            ),
          ),
          
          // 12. PARTICLES
          ..._particles.map((particle) => _buildParticle(particle, size)),
          
          // 13. UI OVERLAY
          _buildGameUI(size),
          
          // 14. SHELL DISCOVERY OVERLAY
          if (_isFindingShell && _currentFoundShell != null)
            _buildShellDiscoveryOverlay(),
          
          // 15. TOOL SELECTION PANEL
          _buildToolSelectionPanel(),
          
          // 16. SPECIAL EVENT NOTIFICATION
          if (_isSpecialEventActive)
            _buildSpecialEventNotification(),
        ],
      ),
    );
  }
  
  Widget _buildSunMoon() {
    final isDay = _currentTimeOfDay != TimeOfDay.night;
    final isEvening = _currentTimeOfDay == TimeOfDay.sunset || 
                      _currentTimeOfDay == TimeOfDay.evening;
    
    return AnimatedBuilder(
      animation: _sunPosition,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          right: MediaQuery.of(context).size.width * (isEvening ? 0.1 : 0.15),
          child: Transform.rotate(
            angle: _sunPosition.value.dx * 2,
            child: Container(
              width: isDay ? 90 : 70,
              height: isDay ? 90 : 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDay
                      ? [Colors.yellow, Colors.orange.shade700]
                      : [Colors.grey.shade100, Colors.grey.shade400],
                  stops: const [0.0, 0.8],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDay ? Colors.orange : Colors.white).withOpacity(0.6),
                    blurRadius: 50,
                    spreadRadius: 30,
                  ),
                  BoxShadow(
                    color: (isDay ? Colors.yellow : Colors.grey.shade300).withOpacity(0.3),
                    blurRadius: 80,
                    spreadRadius: 40,
                  ),
                ],
              ),
              child: isDay
                  ? Center(
                      child: Transform.scale(
                        scale: _sunRaysAnimation.value,
                        child: Icon(
                          Icons.wb_sunny,
                          color: Colors.white.withOpacity(0.8),
                          size: 50,
                        ),
                      ),
                    )
                  : const Center(
                      child: Text('🌙', style: TextStyle(fontSize: 40)),
                    ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildStars() {
    return Positioned.fill(
      child: CustomPaint(
        painter: StarsPainter(
          phase: _sparkleAnimation.value,
        ),
      ),
    );
  }
  
  Widget _buildCloud(Cloud cloud, Size size) {
    return AnimatedBuilder(
      animation: _cloudAnimation,
      builder: (context, child) {
        final x = (cloud.position.dx + _cloudAnimation.value * cloud.speed) % 1.2;
        return Positioned(
          left: x * size.width - 50,
          top: cloud.position.dy * size.height,
          child: Opacity(
            opacity: cloud.opacity,
            child: Transform.scale(
              scale: 1.0 + sin(_masterController.value * 2) * 0.02,
              child: Text(
                _getCloudEmoji(cloud.type),
                style: TextStyle(fontSize: cloud.size),
              ),
            ),
          ),
        );
      },
    );
  }
  
  String _getCloudEmoji(CloudType type) {
    switch (type) {
      case CloudType.cumulus: return '☁️';
      case CloudType.stratus: return '🌥️';
      case CloudType.cirrus: return '☁️';
      case CloudType.storm: return '🌧️';
    }
  }
  
  Widget _buildSeagull(Seagull seagull, Size size) {
    return AnimatedBuilder(
      animation: _masterController,
      builder: (context, child) {
        final x = (seagull.position.dx + _masterController.value * seagull.speed * 0.1) % 1.2;
        final y = seagull.position.dy + sin(_masterController.value * 4 + seagull.wingPhase) * 0.01;
        final wingAngle = sin(_masterController.value * 8 + seagull.wingPhase) * 0.2;
        
        return Positioned(
          left: x * size.width,
          top: y * size.height,
          child: Transform.rotate(
            angle: wingAngle,
            child: const Text('🕊️', style: TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }
  
  Widget _buildRainEffect(Size size) {
    return Positioned.fill(
      child: CustomPaint(
        painter: RainPainter(
          phase: _masterController.value,
        ),
      ),
    );
  }
  
  Widget _buildSpecialEventEffect(Size size) {
    switch (_currentEvent) {
      case 'golden_hour':
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                colors: [
                  Colors.amber.withOpacity(0.2),
                  Colors.transparent,
                  Colors.transparent,
                ],
                radius: 1.5,
              ),
            ),
          ),
        );
      case 'bioluminescence':
        return Positioned.fill(
          child: CustomPaint(
            painter: BioluminescencePainter(
              phase: _masterController.value,
              intensity: _globalGlowIntensity,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
  
  Widget _buildOcean(Size size) {
    final tideHeight = _getTideHeight();
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: size.height * (0.25 + tideHeight * 0.2),
      child: ClipPath(
        clipper: WaveClipper(
          waveAnimation: _waveAnimation.value,
          tideHeight: tideHeight,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _getOceanColors(),
            ),
          ),
          child: Stack(
            children: [
              ..._waves.map((wave) => Positioned.fill(
                child: CustomPaint(
                  painter: WavePainter(
                    wave: wave,
                    phase: _masterController.value,
                    tideHeight: tideHeight,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildBeach(Size size) {
    final tideHeight = _getTideHeight();
    
    return Positioned(
      bottom: size.height * (0.25 + tideHeight * 0.2),
      left: 0,
      right: 0,
      top: size.height * 0.4,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/beach_textures/sand_base.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              _getTimeBasedTint(),
              BlendMode.softLight,
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/beach_textures/sand_normal.jpg',
                  fit: BoxFit.cover,
                  color: Colors.white.withOpacity(0.3),
                  colorBlendMode: BlendMode.overlay,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: size.height * 0.15,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.blue.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height * 0.1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWaterRipple(WaterRipple ripple, Size size) {
    return Positioned(
      left: ripple.position.dx * size.width - ripple.radius,
      top: (0.2 + ripple.position.dy) * size.height - ripple.radius,
      child: AnimatedBuilder(
        animation: _masterController,
        builder: (context, child) {
          return Opacity(
            opacity: ripple.lifetime * 0.5,
            child: Container(
              width: ripple.radius * 2,
              height: ripple.radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3 * ripple.lifetime),
                  width: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildFootprint(Footprint footprint, Size size) {
    return Positioned(
      left: footprint.position.dx * size.width - 15,
      top: footprint.position.dy * size.height - 10,
      child: Transform.rotate(
        angle: footprint.rotation,
        child: Opacity(
          opacity: footprint.opacity,
          child: const Text('👣', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
  
  Widget _buildBeachCreature(BeachCreature creature, Size size) {
    return Positioned(
      left: creature.position.dx * size.width - 15,
      top: creature.position.dy * size.height - 15,
      child: AnimatedBuilder(
        animation: _masterController,
        builder: (context, child) {
          if (creature.type == BeachCreatureType.crab) {
            final yOffset = sin(_masterController.value * 4 + creature.animationPhase) * 3;
            return Transform.translate(
              offset: Offset(0, yOffset),
              child: Text(
                '🦀',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            );
          }
          return Text(
            _getCreatureEmoji(creature.type),
            style: const TextStyle(fontSize: 28),
          );
        },
      ),
    );
  }
  
  String _getCreatureEmoji(BeachCreatureType type) {
    switch (type) {
      case BeachCreatureType.crab: return '🦀';
      case BeachCreatureType.starfish: return '⭐';
      case BeachCreatureType.seagull: return '🕊️';
      case BeachCreatureType.dolphin: return '🐬';
      case BeachCreatureType.turtle: return '🐢';
    }
  }
  
  Widget _buildSandSparkle(SandSparkle sparkle, Size size) {
    return AnimatedBuilder(
      animation: _sparkleAnimation,
      builder: (context, child) {
        final intensity = 0.3 + sin(_sparkleAnimation.value + sparkle.phase) * 0.3;
        return Positioned(
          left: sparkle.position.dx * size.width,
          top: sparkle.position.dy * size.height,
          child: Opacity(
            opacity: intensity * _sandGlitterAnimation.value,
            child: Container(
              width: sparkle.size,
              height: sparkle.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.3),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildShellSpot(ShellSpot spot, Size size) {
    final pos = Offset(
      spot.position.dx * size.width,
      spot.position.dy * size.height,
    );
    
    return Positioned(
      left: pos.dx - 15,
      top: pos.dy - 15,
      child: AnimatedBuilder(
        animation: _glowPulseAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              if (spot.glowIntensity > 0)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getShellColor(spot.shellType)
                            .withOpacity(0.4 * spot.glowIntensity * 
                                (0.7 + sin(_masterController.value * 2) * 0.3)),
                        blurRadius: 20 * spot.glowIntensity,
                        spreadRadius: 10 * spot.glowIntensity,
                      ),
                    ],
                  ),
                ),
              Transform.rotate(
                angle: spot.rotation + (spot.isFound ? 0 : sin(_masterController.value) * 0.05),
                child: Opacity(
                  opacity: 0.3 + (1 - spot.depth) * 0.7,
                  child: Text(
                    _getShellEmoji(spot.shellType),
                    style: TextStyle(
                      fontSize: 30 + (1 - spot.depth) * 10,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildSpecialItem(SpecialItem item, Size size) {
    final pos = Offset(
      item.position.dx * size.width - 20,
      item.position.dy * size.height - 20,
    );
    
    return Positioned(
      left: pos.dx,
      top: pos.dy,
      child: AnimatedBuilder(
        animation: _glowPulseAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: item.rotation + sin(_masterController.value) * 0.05,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: _getSpecialItemColor(item.type)
                        .withOpacity(0.5 + sin(_masterController.value) * 0.2),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _getSpecialItemEmoji(item.type),
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  String _getSpecialItemEmoji(SpecialItemType type) {
    switch (type) {
      case SpecialItemType.magnifyingGlass: return '🔍';
      case SpecialItemType.shovel: return '🪣';
      case SpecialItemType.treasureChest: return '🧰';
      case SpecialItemType.fishingNet: return '🕸️';
    }
  }
  
  Color _getSpecialItemColor(SpecialItemType type) {
    switch (type) {
      case SpecialItemType.magnifyingGlass: return Colors.blue;
      case SpecialItemType.shovel: return Colors.brown;
      case SpecialItemType.treasureChest: return Colors.yellow;
      case SpecialItemType.fishingNet: return Colors.teal;
    }
  }
  
  Widget _buildParticle(Particle particle, Size size) {
    final screenPos = Offset(
      particle.position.dx * size.width,
      particle.position.dy * size.height,
    );
    
    return Positioned(
      left: screenPos.dx - particle.size / 2,
      top: screenPos.dy - particle.size / 2,
      child: Opacity(
        opacity: particle.opacity,
        child: Container(
          width: particle.size,
          height: particle.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: particle.color,
            boxShadow: [
              BoxShadow(
                color: particle.color.withOpacity(0.5),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGameUI(Size size) {
    return Positioned.fill(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                  _buildGlassStatChip('⚡', '$_playerEnergy', const Color(0xFFFFD700)),
                  const SizedBox(width: 8),
                  _buildGlassStatChip('💰', '$_playerCoins', const Color(0xFF4CAF50)),
                  const SizedBox(width: 8),
                  _buildGlassStatChip('🐚', '$_foundShellsCount', const Color(0xFFFF9800)),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: PopupMenuButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      itemBuilder: (context) => [
                        const PopupMenuItem(child: Text('Sound On/Off')),
                        const PopupMenuItem(child: Text('Music On/Off')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.waves, color: Colors.blue.shade200, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _getTideStateText(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, color: Colors.white.withOpacity(0.7), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    _getTimeOfDayText(),
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),
                  if (_streakBonus > 1) ...[
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.yellow.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.yellow.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          const Text('✨', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(
                            '${_streakBonus}x',
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGlassStatChip(String icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  String _getTideStateText() {
    switch (_tideState) {
      case TideState.low: return 'Low Tide';
      case TideState.rising: return '🌊 Rising Tide';
      case TideState.high: return 'High Tide';
      case TideState.falling: return '⬇️ Falling Tide';
    }
  }
  
  String _getTimeOfDayText() {
    switch (_currentTimeOfDay) {
      case TimeOfDay.sunrise: return 'Sunrise';
      case TimeOfDay.morning: return 'Morning';
      case TimeOfDay.afternoon: return 'Afternoon';
      case TimeOfDay.sunset: return 'Sunset';
      case TimeOfDay.evening: return 'Evening';
      case TimeOfDay.night: return 'Night';
    }
  }
  
  Widget _buildToolSelectionPanel() {
    return Positioned(
      bottom: 100,
      left: 16,
      right: 16,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildToolButton(GameTool.hand, '✋', 'Hand', 1),
            if (_hasMagnifyingGlass)
              _buildToolButton(GameTool.magnifyingGlass, '🔍', 'Search', 2),
            if (_hasShovel)
              _buildToolButton(GameTool.shovel, '🪣', 'Dig', 4),
            _buildToolButton(GameTool.net, '🕸️', 'Net', 2),
            _buildToolButton(GameTool.metalDetector, '📡', 'Scan', 6),
          ],
        ),
      ),
    );
  }
  
  Widget _buildToolButton(GameTool tool, String emoji, String label, int cost) {
    final isSelected = _selectedTool == tool;
    final isUnlocked = _unlockedTools.contains(tool);
    final canAfford = _playerEnergy >= cost;
    final isEnabled = isUnlocked && canAfford;
    
    return GestureDetector(
      onTap: isEnabled ? () => setState(() => _selectedTool = tool) : null,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? Colors.blue.withOpacity(0.8)
              : isEnabled
                  ? Colors.white.withOpacity(0.15)
                  : Colors.grey.withOpacity(0.1),
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : isEnabled
                    ? Colors.white.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 5,
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(
              fontSize: 24,
              color: isEnabled ? Colors.white : Colors.grey,
            )),
            Text(
              label,
              style: TextStyle(
                color: isEnabled ? Colors.white : Colors.grey,
                fontSize: 10,
              ),
            ),
            Text(
              '$cost⚡',
              style: TextStyle(
                color: canAfford ? Colors.yellow : Colors.grey,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSpecialEventNotification() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 80,
      left: 16,
      right: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getEventGradient(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: _getEventColor().withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(_getEventIcon(), color: Colors.yellow, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getEventTitle(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getEventDescription(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (_eventEndTime != null)
              TweenAnimationBuilder(
                duration: const Duration(seconds: 1),
                tween: Tween(
                  begin: 1.0,
                  end: _eventEndTime!.difference(DateTime.now()).inSeconds / 45.0,
                ),
                builder: (context, value, child) {
                  return Stack(
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          value: value.clamp(0.0, 1.0),
                          backgroundColor: Colors.white.withOpacity(0.2),
                          color: Colors.yellow,
                          strokeWidth: 3,
                        ),
                      ),
                      Center(
                        child: Text(
                          '${(value * 45).round()}s',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildShellDiscoveryOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.elasticOut,
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _currentFoundShell!.glowColor,
                    _currentFoundShell!.glowColor.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _currentFoundShell!.glowColor.withOpacity(0.6),
                    blurRadius: 70,
                    spreadRadius: 30,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Text(
                            _currentFoundShell!.emoji,
                            style: const TextStyle(fontSize: 90),
                          ),
                        );
                      },
                    ),
                  ),
                  ...List.generate(12, (index) {
                    final angle = 2 * pi * index / 12;
                    return AnimatedBuilder(
                      animation: _glowPulseAnimation,
                      builder: (context, child) {
                        return Positioned.fill(
                          child: Align(
                            alignment: Alignment(
                              sin(angle + _masterController.value) * 0.8,
                              cos(angle + _masterController.value) * 0.8,
                            ),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(
                                  0.5 + sin(_masterController.value + index) * 0.3
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(
                color: _currentFoundShell!.rarityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _currentFoundShell!.rarityColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: _currentFoundShell!.rarityColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                _getRarityString(_currentFoundShell!.rarity).toUpperCase(),
                style: TextStyle(
                  color: _currentFoundShell!.rarityColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _currentFoundShell!.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '✨ Found during ${_getTimeOfDayText()} ✨',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '🎁 REWARDS',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRewardCard('💰', '${50 * _streakBonus}'),
                      const SizedBox(width: 30),
                      _buildRewardCard('⚡', '${10 * _streakBonus}'),
                      const SizedBox(width: 30),
                      _buildRewardCard('🐚', '1'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGlassButton(
                  'Continue Hunting',
                  Icons.arrow_forward,
                  Colors.white.withOpacity(0.2),
                  () {
                    setState(() {
                      _isFindingShell = false;
                      _playerCoins += 50 * _streakBonus;
                      _playerEnergy = (_playerEnergy + 10 * _streakBonus).clamp(0, 100);
                    });
                  },
                ),
                const SizedBox(width: 20),
                _buildGlassButton(
                  'Collect & Read',
                  Icons.menu_book,
                  _currentFoundShell!.glowColor,
                  () {
                    widget.onShellFound(_currentFoundShell!);
                    setState(() {
                      _playerCoins += 50 * _streakBonus;
                      _playerEnergy = (_playerEnergy + 10 * _streakBonus).clamp(0, 100);
                      _isFindingShell = false;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRewardCard(String icon, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.yellow.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGlassButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 10,
        shadowColor: color.withOpacity(0.5),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: Colors.white, size: 20),
        ],
      ),
    );
  }
  
  // ============ EVENT HELPER METHODS ============
  
  List<Color> _getEventGradient() {
    switch (_currentEvent) {
      case 'golden_hour': return [Colors.amber, Colors.orange, Colors.deepOrange];
      case 'bioluminescence': return [Colors.cyan, Colors.blue, Colors.purple];
      case 'treasure_tide': return [Colors.yellow, Colors.green, Colors.teal];
      case 'crab_parade': return [Colors.red, Colors.orange, Colors.pink];
      case 'dolphin_visit': return [Colors.blue, Colors.lightBlue, Colors.cyan];
      default: return [Colors.purple, Colors.blue, Colors.pink];
    }
  }
  
  Color _getEventColor() {
    switch (_currentEvent) {
      case 'golden_hour': return Colors.amber;
      case 'bioluminescence': return Colors.cyan;
      case 'treasure_tide': return Colors.yellow;
      case 'crab_parade': return Colors.red;
      case 'dolphin_visit': return Colors.blue;
      default: return Colors.purple;
    }
  }
  
  IconData _getEventIcon() {
    switch (_currentEvent) {
      case 'golden_hour': return Icons.wb_sunny;
      case 'bioluminescence': return Icons.water_drop;
      case 'treasure_tide': return Icons.inventory;
      case 'crab_parade': return Icons.pets;
      case 'dolphin_visit': return Icons.sailing;
      default: return Icons.auto_awesome;
    }
  }
  
  String _getEventTitle() {
    switch (_currentEvent) {
      case 'golden_hour': return '✨ GOLDEN HOUR ✨';
      case 'bioluminescence': return '🌊 BIOLUMINESCENT WAVES 🌊';
      case 'treasure_tide': return '💎 TREASURE TIDE 💎';
      case 'crab_parade': return '🦀 CRAB PARADE 🦀';
      case 'dolphin_visit': return '🐬 DOLPHIN VISIT 🐬';
      default: return '✨ SPECIAL EVENT ✨';
    }
  }
  
  String _getEventDescription() {
    switch (_currentEvent) {
      case 'golden_hour': return '3x coins! The beach is glowing with golden light.';
      case 'bioluminescence': return 'Rarer shells! The ocean sparkles with magic.';
      case 'treasure_tide': return 'A treasure chest has washed ashore!';
      case 'crab_parade': return 'Crabs are dancing! Tap them for bonus coins.';
      case 'dolphin_visit': return 'Friendly dolphins! They restore your energy.';
      default: return 'Something magical is happening...';
    }
  }
  
  // ============ SHELL GENERATION METHODS ============
  
  ShellRarity _getRandomShellType(int playerLevel) {
    final random = Random();
    final roll = random.nextDouble();
    final levelBonus = playerLevel * 0.02;
    
    if (roll < 0.45 - levelBonus) return ShellRarity.COMMON;
    if (roll < 0.75 - levelBonus * 0.5) return ShellRarity.RARE;
    if (roll < 0.92 - levelBonus * 0.3) return ShellRarity.EPIC;
    if (roll < 0.98) return ShellRarity.LEGENDARY;
    return ShellRarity.MYTHICAL;
  }
  
  ShellRarity _applyRarityMultiplier(ShellRarity original, double multiplier) {
    if (multiplier <= 1.0) return original;
    
    final random = Random();
    if (multiplier >= 1.5 && random.nextDouble() < 0.3) {
      switch (original) {
        case ShellRarity.COMMON: return ShellRarity.RARE;
        case ShellRarity.RARE: return ShellRarity.EPIC;
        case ShellRarity.EPIC: return ShellRarity.LEGENDARY;
        case ShellRarity.LEGENDARY: return ShellRarity.MYTHICAL;
        default: return original;
      }
    }
    return original;
  }
  
  String _getShellName(ShellRarity rarity) {
    final names = {
      ShellRarity.COMMON: ['Sand Dollar', 'Olive Shell', 'Wentletrap', 'Periwinkle'],
      ShellRarity.RARE: ['Moon Snail', 'Tiger Cowrie', 'Queen Conch', 'Papal Cross'],
      ShellRarity.EPIC: ['Rainbow Abalone', 'Golden Cowrie', 'Imperial Volute', 'Sunburst Star'],
      ShellRarity.LEGENDARY: ['Dragon\'s Heart', 'Phoenix Clam', 'Unicorn Horn', 'Mermaid\'s Purse'],
      ShellRarity.MYTHICAL: ['Celestial Nautilus', 'Ocean\'s Tear', 'Atlantis Pearl', 'Kraken\'s Tooth'],
    };
    final list = names[rarity]!;
    return list[Random().nextInt(list.length)];
  }
  
  String _getShellEmoji(ShellRarity rarity) {
    switch (rarity) {
      case ShellRarity.COMMON: return '🐚';
      case ShellRarity.RARE: return '✨';
      case ShellRarity.EPIC: return '💎';
      case ShellRarity.LEGENDARY: return '👑';
      case ShellRarity.MYTHICAL: return '🌌';
    }
  }
  
  Color _getShellColor(ShellRarity rarity) {
    switch (rarity) {
      case ShellRarity.COMMON: return Colors.brown.shade400;
      case ShellRarity.RARE: return Colors.blue.shade400;
      case ShellRarity.EPIC: return Colors.purple.shade400;
      case ShellRarity.LEGENDARY: return Colors.yellow.shade700;
      case ShellRarity.MYTHICAL: return Colors.deepPurple.shade400;
    }
  }
  
  List<Color> _getShellGradient(ShellRarity rarity) {
    switch (rarity) {
      case ShellRarity.COMMON: return [Colors.brown.shade300, Colors.brown.shade700];
      case ShellRarity.RARE: return [Colors.blue.shade300, Colors.blue.shade900];
      case ShellRarity.EPIC: return [Colors.purple.shade300, Colors.purple.shade900];
      case ShellRarity.LEGENDARY: return [Colors.yellow.shade400, Colors.orange.shade700];
      case ShellRarity.MYTHICAL: return [Colors.deepPurple.shade300, Colors.purple.shade900];
    }
  }
  
  String _getShellEffect(ShellRarity rarity) {
    switch (rarity) {
      case ShellRarity.COMMON: return 'none';
      case ShellRarity.RARE: return 'sparkle';
      case ShellRarity.EPIC: return 'pulse';
      case ShellRarity.LEGENDARY: return 'rainbow';
      case ShellRarity.MYTHICAL: return 'cosmic';
    }
  }
  
  String _getRarityString(ShellRarity rarity) {
    switch (rarity) {
      case ShellRarity.COMMON: return 'Common';
      case ShellRarity.RARE: return 'Rare';
      case ShellRarity.EPIC: return 'Epic';
      case ShellRarity.LEGENDARY: return 'Legendary';
      case ShellRarity.MYTHICAL: return 'Mythical';
    }
  }
  
  String _generateShellDescription(ShellRarity rarity, double depth) {
    final timeOfDay = _getTimeOfDayText().toLowerCase();
    final tideState = _tideState.toString().split('.').last.toLowerCase();
    final depthDesc = depth > 0.7 ? 'deeply buried in the wet sand' : 
                     depth > 0.3 ? 'partially hidden under fine grains' : 
                     'glistening near the surface';
    
    final stories = {
      ShellRarity.COMMON: [
        'Found during a peaceful $timeOfDay $tideState tide, $depthDesc. The ocean whispers: "Even the smallest treasures carry the sea\'s memory."',
        'This humble shell washed ashore this $timeOfDay, $depthDesc. It carries the rhythm of gentle waves and calm days.',
        '$depthDesc during $tideState tide, this shell remembers: "Patience reveals the beauty in simplicity."',
      ],
      ShellRarity.RARE: [
        '$depthDesc in the golden $timeOfDay light. The ocean reveals: "Rare treasures find those who seek with an open heart."',
        'Born from moonlight and mystery, discovered $depthDesc during $tideState tide. It holds starlight in its curves.',
        'A rare gift from the $timeOfDay sea, $depthDesc. The shell glows with secrets of distant shores.',
      ],
      ShellRarity.EPIC: [
        'Forged in deep ocean currents, this $depthDesc treasure emerged during $tideState tide. The sea proclaims: "Courage leads to wonders."',
        'An ancient artifact from the abyss, $depthDesc in $timeOfDay\'s light. It pulses with the heartbeat of the ocean.',
        '$depthDesc and shimmering with power, this $tideState tide gift chose you. "Greatness awaits," it whispers.',
      ],
      ShellRarity.LEGENDARY: [
        'A myth made real, discovered $depthDesc as the $timeOfDay sun painted the waves gold. "You are the legend you seek," it sings.',
        'Only one in a million finds this $tideState tide miracle, $depthDesc. It declares: "Your destiny writes itself in sand and sea."',
        'The ocean\'s greatest secret, revealed $depthDesc during sacred $timeOfDay hours. "Legendary hearts find legendary treasures."',
      ],
      ShellRarity.MYTHICAL: [
        'A fragment of ocean\'s soul, $depthDesc as reality bends to magic. The cosmos whispers: "You\'ve touched the infinite."',
        'Beyond legend, beyond time - this impossible treasure found you $depthDesc. The universe echoes: "You are the myth."',
        'The sea\'s final secret, unveiled $depthDesc as $tideState tides carry ancient magic. "You\'ve found what never was, yet always will be."',
      ],
    };
    
    final list = stories[rarity]!;
    return list[Random().nextInt(list.length)];
  }
  
  // ============ DISPOSE ============
  
  @override
  void dispose() {
    // ✅ FIXED: Cancel all timers
    _energyTimer?.cancel();
    _particleTimer?.cancel();
    _eventTimer?.cancel();
    _rippleTimer?.cancel();
    _creatureTimer?.cancel();
    
    // ✅ FIXED: Dispose single controller
    _masterController.dispose();
    
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

// ============ ENUMS ============

enum BeachTheme { sunrise, sunny, sunset, moonlight }
enum TideState { low, rising, high, falling }
enum WeatherType { clear, partlyCloudy, cloudy, lightRain }
enum TimeOfDay { sunrise, morning, afternoon, sunset, evening, night }
enum GameTool { hand, magnifyingGlass, shovel, net, metalDetector }
enum SpecialItemType { magnifyingGlass, shovel, treasureChest, fishingNet }
enum BeachCreatureType { crab, starfish, seagull, dolphin, turtle }
enum CloudType { cumulus, stratus, cirrus, storm }

// ============ MODELS ============

class ShellSpot {
  final Offset position;
  bool isFound;
  double glowIntensity;
  ShellRarity shellType;
  double depth;
  double rarityMultiplier;
  double rotation;
  double scale;
  
  ShellSpot({
    required this.position,
    required this.isFound,
    required this.glowIntensity,
    required this.shellType,
    required this.depth,
    required this.rarityMultiplier,
    required this.rotation,
    required this.scale,
  });
}

class SpecialItem {
  final SpecialItemType type;
  final Offset position;
  bool isCollected;
  final double rotation;
  final double pulsePhase;
  
  SpecialItem({
    required this.type,
    required this.position,
    required this.isCollected,
    required this.rotation,
    required this.pulsePhase,
  });
}

class BeachCreature {
  final BeachCreatureType type;
  Offset position;
  int direction;
  double speed;
  double animationPhase;
  
  BeachCreature({
    required this.type,
    required this.position,
    required this.direction,
    required this.speed,
    required this.animationPhase,
  });
}

class Cloud {
  Offset position;
  double size;
  double speed;
  double opacity;
  CloudType type;
  
  Cloud({
    required this.position,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.type,
  });
}

class Seagull {
  Offset position;
  double speed;
  double wingPhase;
  
  Seagull({
    required this.position,
    required this.speed,
    required this.wingPhase,
  });
}

class Wave {
  double amplitude;
  double frequency;
  double phase;
  double speed;
  
  Wave({
    required this.amplitude,
    required this.frequency,
    required this.phase,
    required this.speed,
  });
}

class BrushStroke {
  final Offset start;
  final Offset end;
  final DateTime timestamp;
  final GameTool tool;
  final double size;
  
  BrushStroke({
    required this.start,
    required this.end,
    required this.timestamp,
    required this.tool,
    required this.size,
  });
}

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double lifetime;
  double opacity;
  
  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.lifetime,
    required this.opacity,
  });
}

class WaterRipple {
  Offset position;
  double radius;
  double lifetime;
  
  WaterRipple({
    required this.position,
    required this.radius,
    required this.lifetime,
  });
}

class Footprint {
  Offset position;
  double rotation;
  DateTime timestamp;
  double opacity;
  
  Footprint({
    required this.position,
    required this.rotation,
    required this.timestamp,
    required this.opacity,
  });
}

class SandSparkle {
  Offset position;
  double size;
  double phase;
  double speed;
  
  SandSparkle({
    required this.position,
    required this.size,
    required this.phase,
    required this.speed,
  });
}

// ============ CUSTOM PAINTERS ============

class InteractivePainter extends CustomPainter {
  final List<BrushStroke> brushStrokes;
  
  InteractivePainter({required this.brushStrokes});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in brushStrokes) {
      final paint = Paint()
        ..color = Colors.transparent
        ..blendMode = BlendMode.clear
        ..strokeWidth = stroke.size
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(stroke.start, stroke.end, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WaveClipper extends CustomClipper<Path> {
  final double waveAnimation;
  final double tideHeight;
  
  WaveClipper({required this.waveAnimation, required this.tideHeight});
  
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    
    for (double i = 0; i <= size.width; i += 10) {
      path.lineTo(
        i,
        size.height * 0.2 + 
        sin(i * 0.02 + waveAnimation * 0.1) * 10 +
        cos(i * 0.01 + waveAnimation) * 5,
      );
    }
    
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }
  
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldDelegate) => true;
}

class WavePainter extends CustomPainter {
  final Wave wave;
  final double phase;
  final double tideHeight;
  
  WavePainter({required this.wave, required this.phase, required this.tideHeight});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2 + tideHeight * 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final path = Path();
    path.moveTo(0, size.height * 0.2);
    
    for (double x = 0; x <= size.width; x += 5) {
      final y = size.height * 0.2 + 
                sin(x * wave.frequency + phase * wave.speed + wave.phase) * 
                wave.amplitude * (0.5 + tideHeight * 0.5);
      path.lineTo(x, y);
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class StarsPainter extends CustomPainter {
  final double phase;
  
  StarsPainter({required this.phase});
  
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.6;
      final brightness = 0.3 + sin(phase + random.nextDouble() * 10) * 0.3 + random.nextDouble() * 0.2;
      paint.color = Colors.white.withOpacity(brightness);
      canvas.drawCircle(Offset(x, y), 1 + random.nextDouble() * 2, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RainPainter extends CustomPainter {
  final double phase;
  
  RainPainter({required this.phase});
  
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(123);
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..strokeWidth = 1.5;
    
    for (int i = 0; i < 100; i++) {
      final x = (random.nextDouble() * size.width + phase * 50) % size.width;
      final y = (random.nextDouble() * size.height + phase * 100) % size.height;
      final length = 15 + random.nextDouble() * 20;
      canvas.drawLine(Offset(x, y), Offset(x + 2, y + length), paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BioluminescencePainter extends CustomPainter {
  final double phase;
  final double intensity;
  
  BioluminescencePainter({required this.phase, required this.intensity});
  
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(456);
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.3;
      final radius = 30 + sin(phase * 2 + i) * 10;
      final opacity = 0.1 + sin(phase * 3 + i) * 0.05 * intensity;
      
      paint.color = Colors.cyan.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
      
      paint.color = Colors.blue.withOpacity(opacity * 0.5);
      canvas.drawCircle(Offset(x + 20, y - 10), radius * 0.7, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}