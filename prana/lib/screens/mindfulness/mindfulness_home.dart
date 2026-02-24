// lib/screens/mindfulness/mindfulness_home.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MindfulnessHomeScreen extends StatelessWidget {
  const MindfulnessHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    return Scaffold(
      backgroundColor: const Color(0xFF0A2463),
      body: Stack(
        children: [
          // Animated Ocean Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0A2463),
                    const Color(0xFF1E3A8A),
                    const Color(0xFF219EBC),
                    const Color(0xFF06D6A0).withOpacity(0.7),
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: CustomPaint(
                painter: OceanPainter(),
              ),
            ),
          ),

          // Floating Ocean Creatures
          _buildFloatingFish(50, 100, screenWidth * 0.3, true),
          _buildFloatingFish(200, 150, screenWidth * 0.2, false),
          _buildBubble(100, 300, 20),
          _buildBubble(300, 200, 15),
          _buildBubble(150, 400, 25),
          _buildCoral(50, 500),
          _buildCoral(screenWidth - 100, 450),

          // Main Content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ============ OCEAN HEADER ============
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: isDesktop ? null : Container(
                    margin: EdgeInsets.only(left: 16, top: 8),
                    child: Material(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white.withOpacity(0.15),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  expandedHeight: 140,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(left: 20, bottom: 12),
                    title: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF06D6A0).withOpacity(0.9),
                            const Color(0xFF4CC9F0).withOpacity(0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF06D6A0).withOpacity(0.4),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🐬', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 10),
                          Text(
                            'Ocean Calm',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('🌊', style: TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF0A2463).withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ============ WELCOME CARD WITH DAILY TARGETS ============
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1E3A8A).withOpacity(0.8),
                          const Color(0xFF162447).withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 25,
                          offset: Offset(0, 12),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFF4CC9F0).withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.waves, color: Color(0xFF4CC9F0), size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Dive into Deep Calm',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.water_drop, color: Color(0xFF06D6A0), size: 28),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Let ocean waves wash away your stress 🌊',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),

                        // ============ DAILY TARGETS SECTION ============
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color(0xFF9D4EDD).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color(0xFF9D4EDD).withOpacity(0.4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.flag, color: Color(0xFF9D4EDD), size: 22),
                                  SizedBox(width: 10),
                                  Text(
                                    '🎯 Daily Targets',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '3/5 Complete',
                                    style: TextStyle(
                                      color: Color(0xFF06D6A0),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              // Progress Bar
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: 0.6, // 3/5 = 60%
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF9D4EDD), Color(0xFF7209B7)],
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              // Target List
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _buildTargetItem('🧘 5-min meditation', true),
                                  _buildTargetItem('📝 Journal entry', true),
                                  _buildTargetItem('🌅 Sunrise intention', true),
                                  _buildTargetItem('🌙 Evening reflection', false),
                                  _buildTargetItem('💧 Drink 8 glasses', false),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Stats
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                          children: [
                            _buildStatCard('7', 'Day Streak', Icons.local_fire_department, Color(0xFFFF6B6B)),
                            _buildStatCard('45', 'Minutes', Icons.timer, Color(0xFF06D6A0)),
                            _buildStatCard('5', 'Badges', Icons.emoji_events, Color(0xFFFFD166)),
                            _buildStatCard('60%', 'Targets', Icons.flag, Color(0xFF9D4EDD)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ============ QUICK ACTIONS HEADER ============
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF4CC9F0).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color(0xFF4CC9F0).withOpacity(0.5)),
                          ),
                          child: Icon(Icons.bolt, color: Color(0xFFFFD166), size: 24),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'QUICK ACTIONS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tap any card to begin your journey',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ============ ALL 6 ACTION CARDS ============
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isPhone ? 2 : isTablet ? 3 : 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: _getAspectRatio(screenWidth),
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final actions = [
                          {
                            'title': '5-Min Breathing',
                            'icon': Icons.waves,
                            'color': Color(0xFF06D6A0),
                            'emoji': '🐋',
                            'route': '/breathing_exercise',
                            'description': 'Deep calm breathing',
                          },
                          {
                            'title': 'Power Nap',
                            'icon': Icons.nightlight,
                            'color': Color(0xFF7209B7),
                            'emoji': '⭐',
                            'route': '/power_nap',
                            'description': 'Space energy recharge',
                          },
                          {
                            'title': 'Study Reset',
                            'icon': Icons.school,
                            'color': Color(0xFFF72585),
                            'emoji': '🧠',
                            'route': '/study_reset',
                            'description': 'Clear mental fatigue',
                          },
                          {
                            'title': 'Evening Wind',
                            'icon': Icons.spa,
                            'color': Color(0xFF4CC9F0),
                            'emoji': '🌙',
                            'route': '/evening_wind',
                            'description': 'Sunset relaxation',
                          },
                          {
                            'title': 'Happy Thoughts',
                            'icon': Icons.emoji_emotions,
                            'color': Color(0xFFFFD166),
                            'emoji': '🌈',
                            'route': '/happy_thoughts',
                            'description': 'Sunset beach journal',
                          },
                          {
                            'title': 'AI Chat Buddy',
                            'icon': Icons.chat,
                            'color': Color(0xFF9D4EDD),
                            'emoji': '🤖',
                            'route': '/character_selection',
                            'description': 'Talk about feelings',
                          },
                        ];
                        return _buildActionCard(context, actions[index]);
                      },
                      childCount: 6, // Always show 6 features!
                    ),
                  ),
                ),

                // ============ OCEAN QUOTE ============
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF4CC9F0).withOpacity(0.2),
                            Color(0xFF06D6A0).withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.anchor, color: Color(0xFF4CC9F0), size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Ocean Wisdom',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.water, color: Color(0xFF06D6A0), size: 20),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            '"The ocean stirs the heart, inspires the imagination and brings eternal joy to the soul."',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ============ BOTTOM SPACER ============
                SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ],
      ),

      // ============ FLOATING ACTION BUTTON ============
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, '/breathing_exercise'),
          backgroundColor: Color(0xFF06D6A0),
          foregroundColor: Colors.white,
          elevation: 12,
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow, size: 24),
          ),
          label: Text(
            'Start Breathing',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.white.withOpacity(0.3), width: 2),
          ),
          heroTag: 'ocean_fab',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ============ NEW: TARGET ITEM BUILDER ============
  Widget _buildTargetItem(String text, bool completed) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: completed ? Color(0xFF06D6A0).withOpacity(0.2) : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: completed ? Color(0xFF06D6A0) : Colors.white.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Color(0xFF06D6A0) : Colors.white.withOpacity(0.5),
            size: 16,
          ),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: completed ? Colors.white : Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============ OCEAN DECORATIONS ============

  Widget _buildFloatingFish(double top, double left, double width, bool facingRight) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: width,
        height: width * 0.4,
        child: CustomPaint(
          painter: FishPainter(facingRight: facingRight),
        ),
      ),
    );
  }

  Widget _buildBubble(double top, double left, double size) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color(0xFF4CC9F0).withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFF4CC9F0).withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF4CC9F0).withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoral(double left, double top) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 40,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFF72585)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
      ),
    );
  }

  // ============ HELPER FUNCTIONS ============

  double _getAspectRatio(double screenWidth) {
    if (screenWidth < 400) return 0.9; // Very small phones
    if (screenWidth < 600) return 1.0; // Regular phones
    if (screenWidth < 900) return 1.1; // Tablets
    return 1.2; // Desktop
  }

  Widget _buildActionCard(BuildContext context, Map<String, dynamic> action) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, action['route']),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              action['color'].withOpacity(0.3),
              action['color'].withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: action['color'].withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color: action['color'].withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: action['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: action['color'].withOpacity(0.4)),
                      ),
                      child: Icon(action['icon'], color: Colors.white, size: 22),
                    ),
                    Text(action['emoji'], style: TextStyle(fontSize: 28)),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  action['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                Text(
                  action['description'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.play_circle_fill, color: Colors.white.withOpacity(0.9), size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Tap to start',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============ OCEAN PAINTER ============

class OceanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw ocean floor gradient
    final floorGradient = LinearGradient(
      colors: [
        Color(0xFF0A2463).withOpacity(0.8),
        Color(0xFF1E3A8A).withOpacity(0.6),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final floorRect = Rect.fromLTRB(0, size.height * 0.7, size.width, size.height);
    paint.shader = floorGradient.createShader(floorRect);
    canvas.drawRect(floorRect, paint);

    // Draw waves
    paint.color = Color(0xFF219EBC).withOpacity(0.15);
    for (int i = 0; i < 3; i++) {
      final path = Path();
      final waveHeight = 20.0;
      final yOffset = size.height * 0.6 + (i * 30);

      path.moveTo(0, yOffset);
      for (double x = 0; x < size.width; x += 5) {
        final y = yOffset + math.sin(x * 0.01 + i * 2) * waveHeight;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }

    // Draw sea plants
    paint.color = Color(0xFF06D6A0).withOpacity(0.3);
    for (int i = 0; i < 10; i++) {
      final x = size.width * (i / 10);
      final plantHeight = 30.0 + math.Random().nextDouble() * 20;
      final plantPath = Path()
        ..moveTo(x, size.height - 50)
        ..quadraticBezierTo(x - 10, size.height - 50 - plantHeight, x, size.height - 50 - plantHeight * 2)
        ..quadraticBezierTo(x + 10, size.height - 50 - plantHeight, x, size.height - 50);
      canvas.drawPath(plantPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============ FISH PAINTER ============

class FishPainter extends CustomPainter {
  final bool facingRight;

  FishPainter({required this.facingRight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFFFD166)
      ..style = PaintingStyle.fill;

    final bodyPath = Path();
    if (facingRight) {
      // Fish facing right
      bodyPath
        ..moveTo(size.width * 0.2, size.height * 0.5)
        ..quadraticBezierTo(size.width * 0.4, 0, size.width * 0.8, size.height * 0.5)
        ..quadraticBezierTo(size.width * 0.4, size.height, size.width * 0.2, size.height * 0.5)
        ..close();
      
      // Tail
      paint.color = Color(0xFFFF6B6B);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, size.height * 0.3, size.width * 0.2, size.height * 0.4),
          Radius.circular(5),
        ),
        paint,
      );
      
      // Eye
      paint.color = Colors.white;
      canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.4), size.height * 0.1, paint);
      paint.color = Colors.black;
      canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.4), size.height * 0.05, paint);
    } else {
      // Fish facing left
      bodyPath
        ..moveTo(size.width * 0.8, size.height * 0.5)
        ..quadraticBezierTo(size.width * 0.6, 0, size.width * 0.2, size.height * 0.5)
        ..quadraticBezierTo(size.width * 0.6, size.height, size.width * 0.8, size.height * 0.5)
        ..close();
      
      // Tail
      paint.color = Color(0xFFFF6B6B);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.8, size.height * 0.3, size.width * 0.2, size.height * 0.4),
          Radius.circular(5),
        ),
        paint,
      );
      
      // Eye
      paint.color = Colors.white;
      canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.4), size.height * 0.1, paint);
      paint.color = Colors.black;
      canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.4), size.height * 0.05, paint);
    }

    paint.color = Color(0xFFFFD166);
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}