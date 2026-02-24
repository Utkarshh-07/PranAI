import 'package:flutter/material.dart';
import 'dart:ui';

class ParentDashboard extends StatefulWidget {
  final String parentEmail;
  final String studentCode;
  
  const ParentDashboard({
    Key? key,
    required this.parentEmail,
    required this.studentCode,
  }) : super(key: key);
  
  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Draw waves
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(
        Offset(i, size.height * 0.3),
        Offset(i + 15, size.height * 0.28),
        paint,
      );
    }
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i, size.height * 0.5),
        Offset(i + 20, size.height * 0.48),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ParentDashboardState extends State<ParentDashboard> {
  // Sample data
  Map<String, dynamic> childData = {
    'name': 'Alex',
    'currentMood': 'Calm & Happy',
    'moodEmoji': '😊',
    'stressLevel': 3,
    'sleepQuality': 'Excellent',
    'streak': '7 days',
    'activities': 'Meditation, AI Chat',
  };
  
  // Updated HOUSE HARBOR COLOR PALETTE
  final Color harborBlue = Color(0xFF2C5282);
  final Color warmBrown = Color(0xFF975A16);
  final Color cozyOrange = Color(0xFFDD6B20);
  final Color gardenGreen = Color(0xFF38A169);
  final Color softCream = Color(0xFFFEF3C7);
  final Color warmRed = Color(0xFFE53E3E);
  final Color skyBlue = Color(0xFF63B3ED);
  final Color waterBlue = Color(0xFF4299E1);
  final Color lightWood = Color(0xFFED8936);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🏡 BEAUTIFUL ANIMATED HOUSE HARBOR BACKGROUND
          _buildAnimatedHarborBackground(),
          
          // 📱 MAIN CONTENT (REDUCED BLUR)
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  // 🏠 CREATIVE HEADER
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          harborBlue.withOpacity(0.9),
                          waterBlue.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: softCream.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 25,
                          spreadRadius: 3,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: softCream.withOpacity(0.2),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back, color: softCream),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: cozyOrange.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: cozyOrange.withOpacity(0.5)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.home_filled, color: softCream, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'House Harbor',
                                    style: TextStyle(
                                      color: softCream,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: cozyOrange.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: cozyOrange.withOpacity(0.5)),
                              ),
                              child: Center(
                                child: Text(
                                  '🏡',
                                  style: TextStyle(fontSize: 28),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome to House Harbor',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: softCream,
                                      height: 1.1,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${childData['name']}\'s wellness sanctuary',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: softCream.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // 🌟 TODAY'S MOOD - CREATIVE DESIGN
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite, color: cozyOrange, size: 24),
                            SizedBox(width: 10),
                            Text(
                              "Today's Emotional Weather",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: softCream,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        
                        // CREATIVE MOOD DISPLAY
                        Container(
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                gardenGreen.withOpacity(0.3),
                                skyBlue.withOpacity(0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: gardenGreen.withOpacity(0.4)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                childData['moodEmoji'],
                                style: TextStyle(fontSize: 60),
                              ),
                              SizedBox(height: 10),
                              Text(
                                childData['currentMood'],
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: softCream,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildMoodIndicator('Stress', '${childData['stressLevel']}/10', gardenGreen),
                                  _buildMoodIndicator('Sleep', childData['sleepQuality'], skyBlue),
                                  _buildMoodIndicator('Streak', childData['streak'], cozyOrange),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // SMALL PROGRESS BARS
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Weekly Progress',
                                    style: TextStyle(
                                      color: softCream.withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: 0.7,
                                    backgroundColor: Colors.white.withOpacity(0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(gardenGreen),
                                    borderRadius: BorderRadius.circular(10),
                                    minHeight: 8,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                color: gardenGreen.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: gardenGreen.withOpacity(0.5)),
                              ),
                              child: Text(
                                '↑ 25%',
                                style: TextStyle(
                                  color: softCream,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // 🎯 QUICK INSIGHTS - COMPACT GRID
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: harborBlue.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: softCream.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.insights, color: cozyOrange),
                            SizedBox(width: 10),
                            Text(
                              'Quick Insights',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: softCream,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.2, // Better aspect ratio
                          children: [
                            _buildInsightCard(
                              icon: Icons.psychology,
                              title: 'AI Session',
                              value: '45 min',
                              color: skyBlue,
                              progress: 0.8,
                            ),
                            _buildInsightCard(
                              icon: Icons.self_improvement,
                              title: 'Meditation',
                              value: 'Daily',
                              color: gardenGreen,
                              progress: 1.0,
                            ),
                            _buildInsightCard(
                              icon: Icons.nightlight_round,
                              title: 'Sleep',
                              value: '8.2 hrs',
                              color: waterBlue,
                              progress: 0.9,
                            ),
                            _buildInsightCard(
                              icon: Icons.trending_up,
                              title: 'Improvement',
                              value: '30%',
                              color: cozyOrange,
                              progress: 0.7,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // 🗓️ WEEKLY MOOD TRACKER - HORIZONTAL
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: warmBrown.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: cozyOrange.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: softCream),
                            SizedBox(width: 10),
                            Text(
                              'Weekly Mood Journey',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: softCream,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              _buildDayCard('Mon', '😊', 0.9, gardenGreen),
                              _buildDayCard('Tue', '😐', 0.6, cozyOrange),
                              _buildDayCard('Wed', '😊', 0.8, gardenGreen),
                              _buildDayCard('Thu', '😟', 0.4, warmRed),
                              _buildDayCard('Fri', '😊', 0.9, gardenGreen),
                              _buildDayCard('Sat', '😄', 1.0, gardenGreen),
                              _buildDayCard('Sun', '😊', 0.8, gardenGreen),
                              SizedBox(width: 5),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 15),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: gardenGreen.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: gardenGreen.withOpacity(0.5)),
                            ),
                            child: Text(
                              'Most Positive: Saturday! 🌟',
                              style: TextStyle(
                                color: softCream,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 💡 FAMILY ACTIVITIES - COMPACT
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: harborBlue.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: gardenGreen.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.family_restroom, color: gardenGreen),
                            SizedBox(width: 10),
                            Text(
                              'Family Harbor Activities',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: softCream,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        
                        _buildActivityTile(
                          emoji: '🌳',
                          title: 'Garden Stroll',
                          time: 'Today 6 PM',
                          color: gardenGreen,
                        ),
                        _buildActivityTile(
                          emoji: '🎨',
                          title: 'Creative Time',
                          time: 'Tomorrow 4 PM',
                          color: skyBlue,
                        ),
                        _buildActivityTile(
                          emoji: '🍕',
                          title: 'Family Dinner',
                          time: 'Friday 7 PM',
                          color: cozyOrange,
                        ),
                      ],
                    ),
                  ),
                  
                  // 🚨 SAFETY QUICK ACCESS
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: warmRed.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: warmRed.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.security, color: softCream),
                            SizedBox(width: 10),
                            Text(
                              'Harbor Safety',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: softCream,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildSafetyButton('Emergency Call', Icons.emergency),
                            _buildSafetyButton('School Contact', Icons.school),
                            _buildSafetyButton('Family Alert', Icons.family_restroom),
                            _buildSafetyButton('Quick Help', Icons.help),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // 🏡 FLOATING HARBOR BUTTON
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: harborBlue.withOpacity(0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: cozyOrange, width: 2),
                ),
                title: Text(
                  'Send Harbor Love 🏡',
                  style: TextStyle(color: softCream, fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Your loving message will reach your child instantly, strengthening your family harbor.',
                  style: TextStyle(color: softCream.withOpacity(0.9)),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Later', style: TextStyle(color: softCream.withOpacity(0.7))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Family love sent! Your harbor grows stronger 💖'),
                          backgroundColor: gardenGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: Text('Send Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cozyOrange,
                      foregroundColor: softCream,
                    ),
                  ),
                ],
              ),
            );
          },
          icon: Icon(Icons.home, color: softCream),
          label: Text('Family Harbor', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: harborBlue,
          elevation: 6,
        ),
      ),
    );
  }
  
  // 🏡 ANIMATED HARBOR BACKGROUND
  Widget _buildAnimatedHarborBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4C51BF), // Deep purple-blue sky
            Color(0xFF2D3748), // Dark blue mountains
            Color(0xFF2C5282), // Harbor water
          ],
        ),
      ),
      child: Stack(
        children: [
          // DISTANT MOUNTAINS
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.5,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2D3748).withOpacity(0.8),
                    Color(0xFF4A5568).withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
              ),
            ),
          ),
          
          // HARBOR WATER
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2C5282).withOpacity(0.7),
                    Color(0xFF2B6CB0).withOpacity(0.8),
                  ],
                ),
              ),
              child: CustomPaint(
                painter: _WavePainter(),
              ),
            ),
          ),
          
          // HOUSE (RIGHT SIDE)
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.3,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 100,
              height: 120,
              child: Stack(
                children: [
                  // House body
                  Container(
                    decoration: BoxDecoration(
                      color: warmBrown,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ),
                  // Roof
                  Positioned(
                    top: -20,
                    left: -10,
                    right: -10,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: cozyOrange,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  // Windows
                  Positioned(
                    top: 30,
                    left: 20,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: softCream,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 20,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: softCream,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Door
                  Positioned(
                    bottom: 0,
                    left: 40,
                    child: Container(
                      width: 20,
                      height: 40,
                      decoration: BoxDecoration(
                        color: warmRed,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // BIG TREE (LEFT SIDE)
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.35,
            left: MediaQuery.of(context).size.width * 0.15,
            child: Column(
              children: [
                // Tree leaves
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: gardenGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                // Tree trunk
                Container(
                  width: 20,
                  height: 60,
                  decoration: BoxDecoration(
                    color: warmBrown,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
          
          // SMALL BOAT
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.3,
            child: Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: harborBlue,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    color: softCream,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          
          // SUN
          Positioned(
            top: 80,
            right: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    cozyOrange.withOpacity(0.8),
                    cozyOrange.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // BIRDS
          Positioned(
            top: 150,
            left: 50,
            child: Text('^^', style: TextStyle(fontSize: 40, color: softCream.withOpacity(0.8))),
          ),
          Positioned(
            top: 130,
            left: 100,
            child: Text('^^', style: TextStyle(fontSize: 40, color: softCream.withOpacity(0.8))),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMoodIndicator(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: softCream,
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: softCream.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildInsightCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required double progress,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: softCream.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: softCream,
              ),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(5),
              minHeight: 6,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDayCard(String day, String mood, double progress, Color color) {
    return Container(
      width: 70,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: softCream,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Text(
            mood,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 8),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityTile({
    required String emoji,
    required String title,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: softCream,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: softCream.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: color, size: 16),
        ],
      ),
    );
  }
  
  Widget _buildSafetyButton(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: warmRed.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: warmRed.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: softCream),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: softCream,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}