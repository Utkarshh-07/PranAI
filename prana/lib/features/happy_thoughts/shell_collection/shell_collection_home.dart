// lib/features/happy_thoughts/shell_collection/shell_collection_home.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prana/features/happy_thoughts/shell_collection/models/shell_model.dart';
import 'package:prana/features/happy_thoughts/shell_collection/widgets/shell_card.dart';
import 'package:prana/features/happy_thoughts/shell_collection/widgets/beach_preview.dart';
import 'package:prana/features/happy_thoughts/shell_collection/oceans_diary.dart';
import 'package:prana/features/happy_thoughts/shell_collection/services/story_generator.dart';
import 'package:prana/features/happy_thoughts/shell_collection/services/shell_discovery.dart';
import 'package:prana/features/happy_thoughts/shell_collection/beach_hunt_game.dart';
import 'package:prana/features/happy_thoughts/shell_collection/shell_story_reveal.dart';

class ShellCollectionHome extends StatefulWidget {
  @override
  _ShellCollectionHomeState createState() => _ShellCollectionHomeState();
}

class _ShellCollectionHomeState extends State<ShellCollectionHome> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _waveAnimation;
  List<Shell> shells = [];
  DateTime _lastDiscovery = DateTime.now().subtract(Duration(hours: 3));
  int _userLevel = 1;
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _waveAnimation = Tween<double>(
      begin: -20,
      end: 20,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
    
    _loadSampleShells();
  }
  
  void _loadSampleShells() {
    shells = [
      Shell(
        id: 'shell_001',
        name: 'Anchor Shell',
        emoji: '⚓',
        rarity: ShellRarity.RARE,
        category: ShellCategory.COURAGE,
        glowColor: Colors.blue,
        description: 'Found during exam stress. The ocean whispers: "Storms create survivors."',
        discoveredAt: DateTime.now().subtract(Duration(days: 2)),
        discoveredIn: 'Study Reset',
        gradientColors: [Colors.blue.shade300, Colors.blue.shade900],
        specialEffect: 'sparkle',
        size: 1.0,
      ),
      Shell(
        id: 'shell_002',
        name: 'Sunrise Shell',
        emoji: '🌅',
        rarity: ShellRarity.COMMON,
        category: ShellCategory.HOPE,
        glowColor: Colors.orange,
        description: 'Morning intention ritual. The ocean says: "Each dawn brings new possibilities."',
        discoveredAt: DateTime.now().subtract(Duration(days: 1)),
        discoveredIn: 'Sunrise Intentions',
        gradientColors: [Colors.orange, Colors.yellow],
        specialEffect: 'none',
        size: 1.0,
      ),
      Shell(
        id: 'shell_003',
        name: 'Tide Pool Shell',
        emoji: '💧',
        rarity: ShellRarity.EPIC,
        category: ShellCategory.WISDOM,
        glowColor: Colors.teal,
        description: 'Found during deep reflection. The ocean reveals: "Still waters hold deep truths."',
        discoveredAt: DateTime.now().subtract(Duration(days: 3)),
        discoveredIn: 'Tide Pool',
        gradientColors: [Colors.teal, Colors.cyan],
        specialEffect: 'pulse',
        size: 1.0,
      ),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2342),
      body: Stack(
        children: [
          // Animated wave background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _waveAnimation.value),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF0A2342),
                          Color(0xFF1B3B6F),
                          Color(0xFF2A9D8F).withOpacity(0.5),
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Floating elements
          _buildFloatingElements(),
          
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ocean\'s Treasures',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Pacifico',
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.blue.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${shells.length} shells collected',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      // Stats bubble
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.yellow, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Level $_userLevel',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Beach Preview
                  BeachPreview(shells: shells),
                  
                  SizedBox(height: 30),
                  
                  // Title with decorative line
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white.withOpacity(0.3),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Your Shell Collection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white.withOpacity(0.3),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Shell Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: shells.length + 3,
                      itemBuilder: (context, index) {
                        if (index < shells.length) {
                          return ShellCard(shell: shells[index]);
                        } else {
                          return _buildEmptySlot(index);
                        }
                      },
                    ),
                  ),
                  
                  // Bottom Navigation
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBottomNavItem(Icons.book, 'Diary', Colors.blue, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OceansDiary(shells: shells),
                            ),
                          );
                        }),
                        _buildBottomNavItem(Icons.games, 'Hunt', Colors.green, () {
                          _startBeachHuntGame();
                        }),
                        _buildBottomNavItem(Icons.auto_awesome, 'Discover', Colors.purple, () {
                          _simulateShellDiscovery();
                        }),
                        _buildBottomNavItem(Icons.share, 'Share', Colors.orange, () {
                          _shareCollection();
                        }),
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
  
  Widget _buildEmptySlot(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.question_mark,
              color: Colors.white.withOpacity(0.3),
              size: 30,
            ),
            SizedBox(height: 8),
            Text(
              'Empty',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomNavItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 20),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFloatingElements() {
    return Stack(
      children: [
        // Bubbles
        Positioned(
          top: 100,
          right: 30,
          child: _buildFloatingBubble(0),
        ),
        Positioned(
          top: 200,
          left: 20,
          child: _buildFloatingBubble(1),
        ),
        Positioned(
          bottom: 150,
          right: 40,
          child: _buildFloatingBubble(2),
        ),
        
        // Sea creatures
        Positioned(
          top: 300,
          left: 50,
          child: _buildFloatingCreature('🐠', 0),
        ),
        Positioned(
          bottom: 200,
          right: 20,
          child: _buildFloatingCreature('🐢', 1),
        ),
      ],
    );
  }
  
  Widget _buildFloatingBubble(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = sin(_controller.value * 2 * 3.14 + index) * 10;
        return Transform.translate(
          offset: Offset(0, offset),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildFloatingCreature(String emoji, int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = cos(_controller.value * 2 * 3.14 + index) * 15;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: Text(
            emoji,
            style: TextStyle(fontSize: 24),
          ),
        );
      },
    );
  }
  
  void _startBeachHuntGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedBeachHuntGame(
          playerLevel: _userLevel,
          onShellFound: (Shell shell) {
            // Add found shell to collection
            setState(() {
              shells.add(shell);
            });
            
            // Navigate to story reveal
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShellStoryReveal(
                  shell: shell,
                  story: shell.description,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  void _simulateShellDiscovery() {
    final shouldDiscover = ShellDiscovery.shouldDiscoverShell(
      feature: 'shell_collection',
      recentEmotions: ['curious', 'exploring'],
      lastDiscovery: _lastDiscovery,
      userLevel: _userLevel,
    );
    
    if (shouldDiscover) {
      _lastDiscovery = DateTime.now();
      
      final storyData = _generateStoryData();
      
      final newShell = Shell(
        id: 'shell_${DateTime.now().millisecondsSinceEpoch}',
        name: storyData['title'] ?? 'Mystery Shell',
        emoji: storyData['emoji'] ?? '🐚',
        rarity: _getRandomRarity(),
        category: _getRandomCategory(),
        glowColor: storyData['color'] ?? Colors.teal,
        description: storyData['story'] ?? 'A new shell discovered in your collection.',
        discoveredAt: DateTime.now(),
        discoveredIn: 'Shell Collection',
        gradientColors: storyData['gradient'] ?? [Colors.teal, Colors.cyan],
        specialEffect: 'sparkle',
        size: 1.0,
      );
      
      setState(() {
        shells.add(newShell);
      });
      
      _showDiscoveryAnimation(newShell, storyData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No new shells yet. Try exploring other features!'),
          backgroundColor: Colors.blue.withOpacity(0.8),
        ),
      );
    }
  }
  
  Map<String, dynamic> _generateStoryData() {
    final themes = ['exploration', 'curiosity', 'peace', 'joy', 'courage'];
    final theme = themes[_random.nextInt(themes.length)];
    
    final stories = {
      'exploration': {
        'title': 'Explorer Shell',
        'emoji': '🧭',
        'color': Colors.blue,
        'gradient': [Colors.blue, Colors.cyan],
        'story': 'Found while exploring new horizons. The ocean whispers: "Every journey begins with a single step into the unknown."',
      },
      'curiosity': {
        'title': 'Curiosity Shell',
        'emoji': '❓',
        'color': Colors.purple,
        'gradient': [Colors.purple, Colors.pink],
        'story': 'Discovered by asking questions. The sea says: "Wonder is the compass of the soul."',
      },
      'peace': {
        'title': 'Peace Shell',
        'emoji': '🕊️',
        'color': Colors.green,
        'gradient': [Colors.green, Colors.lightGreen],
        'story': 'Found in moments of stillness. The ocean murmurs: "In calm waters, we find our reflection."',
      },
      'joy': {
        'title': 'Joy Shell',
        'emoji': '😊',
        'color': Colors.yellow,
        'gradient': [Colors.yellow, Colors.orange],
        'story': 'Discovered with laughter. The waves sing: "Happiness rides the tides to shore."',
      },
      'courage': {
        'title': 'Courage Shell',
        'emoji': '🛡️',
        'color': Colors.red,
        'gradient': [Colors.red, Colors.orange],
        'story': 'Found facing fears. The ocean roars: "Bravery is the shell that protects the heart."',
      },
    };
    
    return stories[theme] ?? {
      'title': 'Mystery Shell',
      'emoji': '🐚',
      'color': Colors.teal,
      'gradient': [Colors.teal, Colors.cyan],
      'story': 'A mysterious shell with secrets yet to be discovered.',
    };
  }
  
  ShellRarity _getRandomRarity() {
    final roll = _random.nextDouble();
    if (roll < 0.5) return ShellRarity.COMMON;
    if (roll < 0.8) return ShellRarity.RARE;
    if (roll < 0.95) return ShellRarity.EPIC;
    if (roll < 0.98) return ShellRarity.LEGENDARY;
    return ShellRarity.MYTHICAL;
  }
  
  ShellCategory _getRandomCategory() {
    final categories = [
      ShellCategory.COURAGE,
      ShellCategory.HOPE,
      ShellCategory.WISDOM,
      ShellCategory.GRATITUDE,
      ShellCategory.PEACE,
      ShellCategory.JOY,
      ShellCategory.SEASHELL,
    ];
    return categories[_random.nextInt(categories.length)];
  }
  
  void _showDiscoveryAnimation(Shell shell, Map<String, dynamic> storyData) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 300,
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                shell.glowColor.withOpacity(0.8),
                shell.glowColor.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: shell.glowColor.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shell animation
              AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.elasticOut,
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: shell.gradientColors,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: shell.glowColor.withOpacity(0.8),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    shell.emoji,
                    style: TextStyle(fontSize: 50),
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              
              Text(
                '✨ New Shell Discovered! ✨',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 10),
              
              Text(
                shell.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                ),
              ),
              
              SizedBox(height: 20),
              
              // Story preview
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'The Ocean Whispers:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      shell.description.substring(0, 100) + '...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: shell.glowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShellStoryReveal(
                            shell: shell,
                            story: shell.description,
                          ),
                        ),
                      );
                    },
                    child: Text('Read Story', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _shareCollection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1B3B6F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Share Ocean Wisdom',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Share your favorite shell stories with friends!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Shared successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Share', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}