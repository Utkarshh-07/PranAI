// lib/screens/mindfulness/happy_thoughts/happy_thoughts_home.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Import the Shell Collection feature
import 'package:prana/features/happy_thoughts/shell_collection/shell_collection_home.dart';

class HappyThoughtsHome extends StatefulWidget {
  const HappyThoughtsHome({super.key});

  @override
  State<HappyThoughtsHome> createState() => _HappyThoughtsHomeState();
}

class _HappyThoughtsHomeState extends State<HappyThoughtsHome> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isLoading = true;
  late String _currentVideoPath;
  late String _timeGreeting;
  late Color _primaryColor;
  late bool _isNightMode;

  @override
  void initState() {
    super.initState();
    _setVideoBasedOnTime();
    _initializeVideo();
  }

  void _setVideoBasedOnTime() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 11) {
      _currentVideoPath = 'assets/videos/morning_beach.mp4';
      _timeGreeting = 'Good Morning! ☀️';
      _primaryColor = Color(0xFFFFD166); // Sand yellow
      _isNightMode = false;
    } else if (hour >= 11 && hour < 16) {
      _currentVideoPath = 'assets/videos/midday_beach.mp4';
      _timeGreeting = 'Hello! 🌊';
      _primaryColor = Color(0xFF4CC9F0); // Ocean blue
      _isNightMode = false;
    } else if (hour >= 16 && hour < 20) {
      _currentVideoPath = 'assets/videos/evening_beach.mp4';
      _timeGreeting = 'Good Evening! 🌇';
      _primaryColor = Color(0xFFFF6B6B); // Sunset coral
      _isNightMode = false;
    } else {
      _currentVideoPath = 'assets/videos/night_beach.mp4';
      _timeGreeting = 'Good Night! 🌙';
      _primaryColor = Color(0xFF9D4EDD); // Twilight purple
      _isNightMode = true; // NIGHT MODE ENABLED
    }
  }

  Future<void> _initializeVideo() async {
    try {
      if (_videoController != null) {
        await _videoController!.dispose();
      }
      
      _videoController = VideoPlayerController.asset(_currentVideoPath);
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play();
      
      setState(() {
        _isVideoInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading video: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // VIDEO BACKGROUND
          if (_isVideoInitialized && _videoController != null)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            )
          else
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
              child: Center(
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam_off, color: Colors.white, size: 50),
                          SizedBox(height: 20),
                          Text(
                            'Loading beach scene...',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
              ),
            ),

          // MORE TRANSPARENT GLASS CONTENT
          SafeArea(
            child: Column(
              children: [
                // MORE TRANSPARENT HEADER
                _buildTransparentHeader(isMobile),
                
                // MORE TRANSPARENT FEATURE CARDS
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: isMobile ? 8 : 15,
                      left: isMobile ? 8 : 15,
                      right: isMobile ? 8 : 15,
                      bottom: isMobile ? 8 : 15,
                    ),
                    child: _buildFeatureGrid(isMobile, isTablet),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransparentHeader(bool isMobile) {
    return Container(
      margin: EdgeInsets.all(isMobile ? 10 : 16),
      padding: EdgeInsets.all(isMobile ? 14 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // More transparent back button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(width: 12),
              // Title with more transparency
              Expanded(
                child: Text(
                  '🏖️ Sunset Beach Journal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 20 : 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 12,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // More transparent time chip
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _primaryColor.withOpacity(0.4),
                    width: 1,
                  ),
                  // SUBTLE GLOW ONLY FOR NIGHT MODE
                  boxShadow: _isNightMode ? [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ] : [],
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time_filled_rounded, 
                         color: Colors.white, size: 14),
                    SizedBox(width: 6),
                    Text(
                      '${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 10 : 14),
          // More transparent greeting card
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                    // SUBTLE GLOW ONLY FOR NIGHT MODE
                    boxShadow: _isNightMode ? [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.25),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ] : [],
                  ),
                  child: Text(
                    _getTimeEmoji(),
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _timeGreeting,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 18 : 22,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 6,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        _getTimeDescription(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: isMobile ? 12 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(bool isMobile, bool isTablet) {
    final features = [
      {
        'title': 'Message in Bottle',
        'emoji': '💌',
        'color': Color(0xFF4CC9F0),
        'description': 'Write secret notes to the sea',
        'detailed': '• Write heartfelt messages\n• Seal them in virtual bottles\n• Watch them float away\n• Release worries with the tide',
        'icon': Icons.send_rounded,
        'onTap': () {
          _showComingSoonDialog('Message in Bottle', '💌', Color(0xFF4CC9F0));
        },
      },
      {
        'title': 'Sand Writing',
        'emoji': '✏️',
        'color': Color(0xFFFFD166),
        'description': 'Draw dreams that waves erase',
        'detailed': '• Write temporary thoughts\n• Watch waves wash them away\n• Practice letting go\n• Ephemeral art therapy',
        'icon': Icons.edit_rounded,
        'onTap': () {
          _showComingSoonDialog('Sand Writing', '✏️', Color(0xFFFFD166));
        },
      },
      {
        'title': 'Shell Collection',
        'emoji': '🐚',
        'description': 'Magical stories from the ocean',
        'color': Color(0xFFFF6B6B),
        'detailed': '• Collect magical shells\n• Each with personalized stories\n• AI-powered ocean wisdom\n• Build your beach treasure',
        'icon': Icons.workspace_premium_rounded,
        'onTap': () {
          // NAVIGATE TO SHELL COLLECTION FEATURE
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShellCollectionHome(),
            ),
          );
        },
      },
      {
        'title': 'Tide Pool',
        'emoji': '💧',
        'description': 'Reflect in calm waters',
        'color': Color(0xFF06D6A0),
        'detailed': '• Mirror-like reflections\n• Peaceful water therapy\n• Emotional depth checking\n• Calm mind exercises',
        'icon': Icons.water_drop_rounded,
        'onTap': () {
          _showComingSoonDialog('Tide Pool', '💧', Color(0xFF06D6A0));
        },
      },
      {
        'title': 'Beach Art',
        'emoji': '🎨',
        'description': 'Create colorful memories',
        'color': Color(0xFF9D4EDD),
        'detailed': '• Digital sand art canvas\n• Color therapy with waves\n• Creative expression\n• Pattern making therapy',
        'icon': Icons.palette_rounded,
        'onTap': () {
          _showComingSoonDialog('Beach Art', '🎨', Color(0xFF9D4EDD));
        },
      },
      {
        'title': 'Lighthouse',
        'emoji': '🗼',
        'description': 'Guide your journey forward',
        'color': Color(0xFFFFB347),
        'detailed': '• Track progress milestones\n• Set wellness goals\n• Navigate emotions\n• Find your direction',
        'icon': Icons.light_mode_rounded,
        'onTap': () {
          _showComingSoonDialog('Lighthouse', '🗼', Color(0xFFFFB347));
        },
      },
      {
        'title': 'Sunrise Intentions',
        'emoji': '🌅',
        'description': 'Set your daily goals',
        'color': Color(0xFFFF9A76),
        'detailed': '• Morning goal setting\n• Sunrise meditation\n• Daily intentions\n• Positive day planning',
        'icon': Icons.lightbulb_rounded,
        'onTap': () {
          _showComingSoonDialog('Sunrise Intentions', '🌅', Color(0xFFFF9A76));
        },
      },
      {
        'title': 'Star Map',
        'emoji': '⭐',
        'description': 'Chart your night sky',
        'color': Color(0xFFA78BFA),
        'detailed': '• Nighttime reflections\n• Starry sky journal\n• Dream mapping\n• Celestial guidance',
        'icon': Icons.nightlight_round,
        'onTap': () {
          _showComingSoonDialog('Star Map', '⭐', Color(0xFFA78BFA));
        },
      },
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : (isTablet ? 3 : 4),
        childAspectRatio: isMobile ? 0.75 : 0.85,
        crossAxisSpacing: isMobile ? 10 : 14,
        mainAxisSpacing: isMobile ? 10 : 14,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildTransparentFeatureCard(
          title: feature['title'] as String,
          emoji: feature['emoji'] as String,
          color: feature['color'] as Color,
          description: feature['description'] as String,
          detailed: feature['detailed'] as String,
          icon: feature['icon'] as IconData,
          onTap: feature['onTap'] as Function(),
        );
      },
    );
  }

  Widget _buildTransparentFeatureCard({
    required String title,
    required String emoji,
    required Color color,
    required String description,
    required String detailed,
    required IconData icon,
    required Function onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTap(),
        child: Transform.translate(
          offset: Offset(0, 0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.black.withOpacity(0.15),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ColorFilter.mode(
                  Colors.white.withOpacity(0.05),
                  BlendMode.overlay,
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Emoji circle with NIGHT MODE GLOW
                      Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color.withOpacity(0.12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                            // SUBTLE GLOW ONLY FOR NIGHT MODE
                            boxShadow: _isNightMode ? [
                              BoxShadow(
                                color: color.withOpacity(0.2), // SUBTLE GLOW
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ] : [],
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  emoji,
                                  style: TextStyle(fontSize: 28),
                                ),
                              ),
                              // Shiny effect - ENHANCED FOR NIGHT MODE
                              if (_isNightMode)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.6), // BRIGHTER FOR NIGHT
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.4),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                      // Title with very subtle background and NIGHT MODE GLOW
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          // SUBTLE GLOW ONLY FOR NIGHT MODE
                          boxShadow: _isNightMode ? [
                            BoxShadow(
                              color: color.withOpacity(0.15), // VERY SUBTLE GLOW
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ] : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon, 
                              color: Colors.white.withOpacity(0.9), 
                              size: 16,
                              // ICON GLOW ONLY FOR NIGHT MODE
                              shadows: _isNightMode ? [
                                Shadow(
                                  color: color.withOpacity(0.5),
                                  blurRadius: 4,
                                ),
                              ] : [],
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                  // TEXT GLOW ONLY FOR NIGHT MODE
                                  shadows: _isNightMode ? [
                                    Shadow(
                                      color: color.withOpacity(0.4), // SUBTLE GLOW
                                      blurRadius: 6,
                                      offset: Offset(0, 0),
                                    ),
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 8,
                                      offset: Offset(1, 1),
                                    ),
                                  ] : [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 6,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      // Short description
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          height: 1.3,
                          // DESCRIPTION GLOW ONLY FOR NIGHT MODE
                          shadows: _isNightMode ? [
                            Shadow(
                              color: color.withOpacity(0.2), // VERY SUBTLE GLOW
                              blurRadius: 4,
                              offset: Offset(0, 0),
                            ),
                          ] : [],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),
                      // Detailed description (bullet points preview)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 0.8,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Features:',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    // FEATURES LABEL GLOW ONLY FOR NIGHT MODE
                                    shadows: _isNightMode ? [
                                      Shadow(
                                        color: color.withOpacity(0.2),
                                        blurRadius: 3,
                                      ),
                                    ] : [],
                                  ),
                                ),
                                SizedBox(height: 4),
                                ..._getFeaturePreviewLines(detailed).map((line) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 8, bottom: 3),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '•',
                                          style: TextStyle(
                                            color: color.withOpacity(0.7),
                                            fontSize: 10,
                                            // BULLET GLOW ONLY FOR NIGHT MODE
                                            shadows: _isNightMode ? [
                                              Shadow(
                                                color: color.withOpacity(0.4),
                                                blurRadius: 3,
                                              ),
                                            ] : [],
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            line,
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: 10,
                                              height: 1.3,
                                              // BULLET TEXT GLOW ONLY FOR NIGHT MODE
                                              shadows: _isNightMode ? [
                                                Shadow(
                                                  color: color.withOpacity(0.15),
                                                  blurRadius: 2,
                                                ),
                                              ] : [],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      // Very transparent tap hint WITH NIGHT MODE GLOW
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 0.8,
                            ),
                            // TAP HINT GLOW ONLY FOR NIGHT MODE
                            boxShadow: _isNightMode ? [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ] : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Tap to explore',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  // TEXT GLOW ONLY FOR NIGHT MODE
                                  shadows: _isNightMode ? [
                                    Shadow(
                                      color: Colors.white.withOpacity(0.3),
                                      blurRadius: 3,
                                    ),
                                  ] : [],
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.touch_app_rounded,
                                color: Colors.white.withOpacity(0.7),
                                size: 12,
                                // ICON GLOW ONLY FOR NIGHT MODE
                                shadows: _isNightMode ? [
                                  Shadow(
                                    color: Colors.white.withOpacity(0.4),
                                    blurRadius: 4,
                                  ),
                                ] : [],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getFeaturePreviewLines(String detailed) {
    // Take first 2-3 bullet points for preview
    final lines = detailed.split('\n');
    return lines.take(3).map((line) {
      // Remove bullet if present
      return line.replaceFirst('• ', '');
    }).toList();
  }

  void _showComingSoonDialog(String title, String emoji, Color color) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              // DIALOG GLOW ONLY FOR NIGHT MODE
              boxShadow: _isNightMode ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ] : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with NIGHT MODE GLOW
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    // HEADER GLOW ONLY FOR NIGHT MODE
                    boxShadow: _isNightMode ? [
                      BoxShadow(
                        color: color.withOpacity(0.25),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ] : [],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          // EMOJI CIRCLE GLOW ONLY FOR NIGHT MODE
                          boxShadow: _isNightMode ? [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 3,
                            ),
                          ] : [],
                        ),
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            // TITLE GLOW ONLY FOR NIGHT MODE
                            shadows: _isNightMode ? [
                              Shadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 10,
                              ),
                            ] : [],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Detailed content
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What you can do:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          // SUBTITLE GLOW ONLY FOR NIGHT MODE
                          shadows: _isNightMode ? [
                            Shadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 6,
                            ),
                          ] : [],
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '• Write heartfelt messages to the sea\n• Seal them in virtual bottles\n• Watch them float away with the tide\n• Release worries and find peace',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          height: 1.4,
                          // DETAIL TEXT GLOW ONLY FOR NIGHT MODE
                          shadows: _isNightMode ? [
                            Shadow(
                              color: color.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ] : [],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '🎉 Already Available:',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          shadows: _isNightMode ? [
                            Shadow(
                              color: Colors.greenAccent.withOpacity(0.4),
                              blurRadius: 8,
                            ),
                          ] : [],
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShellCollectionHome(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF6B6B).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color(0xFFFF6B6B),
                              width: 2,
                            ),
                            boxShadow: _isNightMode ? [
                              BoxShadow(
                                color: Color(0xFFFF6B6B).withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ] : [],
                          ),
                          child: Row(
                            children: [
                              Text(
                                '🐚',
                                style: TextStyle(fontSize: 30),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Shell Collection',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Magical AI-powered ocean stories',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Close button with NIGHT MODE GLOW
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text('Maybe Later'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShellCollectionHome(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF6B6B),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // BUTTON GLOW ONLY FOR NIGHT MODE
                            shadowColor: _isNightMode ? Color(0xFFFF6B6B).withOpacity(0.5) : null,
                            elevation: _isNightMode ? 10 : 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Try Shell Collection'),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward, size: 18),
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
      },
    );
  }

  String _getTimeDescription() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 11) return 'Start your day with peaceful beach vibes 🌅';
    if (hour >= 11 && hour < 16) return 'Perfect time for sun and sand fun 🏖️';
    if (hour >= 16 && hour < 20) return 'Golden hour reflections by the sea 🌇';
    return 'Starry night magic awaits 🌌';
  }

  String _getTimeEmoji() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 11) return '🌅';
    if (hour >= 11 && hour < 16) return '🏖️';
    if (hour >= 16 && hour < 20) return '🌇';
    return '🌌';
  }
}