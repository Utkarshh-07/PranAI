// lib/screens/student_dashboard.dart
import 'package:flutter/material.dart';
import 'dart:math';
import '../features/my_space/my_space_screen.dart';
import '../widgets/floating_cloud.dart';
// REMOVE old chat import
// import 'chat/chat_list_screen.dart';
// ADD new AI chat import
import 'ai_chat/ai_home_screen.dart';

// ============ OCEAN COLOR SCHEME ============
const Color deepOcean = Color(0xFF0A2463);
const Color oceanBlue = Color(0xFF1E3A8A);
const Color seaTeal = Color(0xFF06D6A0);
const Color coral = Color(0xFFFF6B6B);
const Color sand = Color(0xFFF4A261);
const Color bubbleBlue = Color(0xFF90E0EF);
const Color cardColor = Color(0xFF162447);
const Color waveColor = Color(0xFF219EBC);

// ============ OCEAN BACKGROUND ============
class OceanBackground extends StatelessWidget {
  const OceanBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [deepOcean, oceanBlue],
            ),
          ),
        ),
        Positioned(top: 100, left: 50, child: _buildBubble(20)),
        Positioned(top: 200, right: 80, child: _buildBubble(15)),
        Positioned(top: 300, left: 100, child: _buildBubble(25)),
        Positioned(top: 400, right: 120, child: _buildBubble(18)),
        Positioned(top: 500, left: 150, child: _buildBubble(22)),
        Positioned(bottom: 100, left: 30, child: _buildSeaweed()),
        Positioned(bottom: 150, right: 40, child: _buildSeaweed()),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  waveColor.withOpacity(0.1),
                  waveColor.withOpacity(0.2),
                ],
              ),
            ),
            child: CustomPaint(
              painter: _WavePainter(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bubbleBlue.withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(color: bubbleBlue.withOpacity(0.5), width: 1),
      ),
    );
  }

  Widget _buildSeaweed() {
    return Column(
      children: [
        Container(
          width: 30,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [seaTeal.withOpacity(0.3), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Container(
          width: 40,
          height: 10,
          decoration: BoxDecoration(
            color: seaTeal.withOpacity(0.4),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.5, size.width * 0.5, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9, size.width, size.height * 0.7);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============ OCEAN CIRCULAR STAT CARD ============
class OceanCircularStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String mainValue;
  final String subValue;
  final double progress;
  final Color progressColor;

  const OceanCircularStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.mainValue,
    required this.subValue,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bubbleBlue.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: progressColor.withOpacity(0.3), width: 1),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        mainValue,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "progress",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subValue,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Total count",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============ OCEAN SQUARE CARD ============
class OceanSquareCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color accentColor;
  final String creature;

  const OceanSquareCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accentColor,
    this.creature = "🐠",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bubbleBlue.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(0.3),
                          accentColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  Text(
                    creature,
                    style: const TextStyle(fontSize: 30),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============ PARENT STATUS CARD ============
class ParentStatusCard extends StatelessWidget {
  final Map<String, dynamic>? parentData;

  const ParentStatusCard({super.key, required this.parentData});

  @override
  Widget build(BuildContext context) {
    if (parentData == null) {
      return _buildNoParentCard(context);
    }
    
    bool isPrankster = parentData!['userType'].toString().toLowerCase().contains('prankster');
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isPrankster ? Colors.red.withOpacity(0.1) : seaTeal.withOpacity(0.1),
            isPrankster ? Colors.black.withOpacity(0.2) : oceanBlue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrankster ? Colors.red.withOpacity(0.3) : seaTeal.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isPrankster ? Colors.red : seaTeal).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isPrankster ? Colors.red.withOpacity(0.2) : seaTeal.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: isPrankster ? Colors.red : seaTeal,
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                isPrankster ? Icons.verified_user : Icons.family_restroom,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPrankster ? '✅ Verified Student' : '👨‍👩‍👧‍👦 Parent Support Active',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isPrankster 
                    ? 'Police notification system disabled'
                    : 'Connected to ${parentData!['parentName']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isPrankster ? Colors.green.withOpacity(0.3) : seaTeal.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: isPrankster ? Colors.green : seaTeal, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified,
                  color: isPrankster ? Colors.green : Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'VERIFIED',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isPrankster ? Colors.green[200] : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoParentCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.withOpacity(0.1), Colors.red.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.warning,
                color: Colors.orange,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '⚠️ Parent Support Inactive',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Add parent contacts for emergency support',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/parent_contact',
                      arguments: {
                        'isPrankster': false,
                        'pranksterScore': 0,
                        'userType': 'Genuine',
                      },
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.orange, size: 16),
                  label: const Text(
                    'Add Contacts Now',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============ OCEAN HEADER ============
class OceanHeader extends StatelessWidget {
  const OceanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [deepOcean, oceanBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [seaTeal, waveColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: seaTeal.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "🧠",
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Prana Ocean",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Deep dive into mental wellness",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_active, color: Colors.white, size: 28),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 25),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: bubbleBlue.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [bubbleBlue, waveColor],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "MJ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Mark Johnson",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Dive deep, breathe easy • Since 2024",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
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
}

// ============ OCEAN QUICK ACTIONS ============
class OceanQuickActions extends StatelessWidget {
  final Map<String, dynamic>? parentData;
  
  const OceanQuickActions({super.key, required this.parentData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: bubbleBlue.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.waves, color: waveColor, size: 28),
              SizedBox(width: 12),
              Text(
                "Quick Dives",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Explore ocean of mental wellness",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // AI CHAT BUTTON - REPLACED THE OLD CHAT BUTTON
              _buildQuickAction(
                context: context,
                icon: Icons.smart_toy,
                label: 'AI Friends',
                creature: '🤖',
                color: seaTeal,
                onTap: () {
                  // Navigate to AI Home screen
                  Navigator.pushNamed(context, '/ai_home');
                },
              ),
              
              _buildQuickAction(
                context: context,
                icon: Icons.self_improvement,
                label: 'Mindful',
                creature: '🐢',
                color: waveColor,
                onTap: () {
                  Navigator.pushNamed(context, '/mindfulness_home');
                },
              ),
              
              _buildQuickAction(
                context: context,
                icon: Icons.calendar_month,
                label: 'My Space',
                creature: '🌊',
                color: Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MySpaceScreen(parentData: parentData),
                    ),
                  );
                },
              ),
              
              _buildQuickAction(
                context: context,
                icon: Icons.location_on,
                label: 'Directory',
                creature: '🦀',
                color: sand,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Directory feature coming soon!'),
                      backgroundColor: sand,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickAction({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String creature,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.6)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                Text(
                  creature,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ============ OCEAN FOOTER ============
class OceanFooter extends StatelessWidget {
  const OceanFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bubbleBlue.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🌊", style: TextStyle(fontSize: 24)),
              SizedBox(width: 10),
              Text(
                "Prana Ocean",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Text("🌊", style: TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Mental wellness meets oceanic calm",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Made with ❤️ in India • Version 1.0.0",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🐬", style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text("🐠", style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text("🐢", style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text("🦈", style: TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}

// ============ MENTAL WELLNESS STATS CARD ============
class MentalWellnessCard extends StatelessWidget {
  const MentalWellnessCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: seaTeal.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.psychology, color: seaTeal, size: 28),
              SizedBox(width: 12),
              Text(
                "Mental Wellness Stats",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMentalStat("Stress Level", "32%", "😌", seaTeal),
              _buildMentalStat("Sleep Score", "78/100", "😴", waveColor),
              _buildMentalStat("Mindfulness", "14 days", "🧘", coral),
              _buildMentalStat("Mood", "Positive", "😊", sand),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMentalStat(String label, String value, String emoji, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

// ============ MAIN STUDENT DASHBOARD ============
class StudentDashboard extends StatefulWidget {
  final Map<String, dynamic>? parentData;

  const StudentDashboard({super.key, required this.parentData});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardContent(), // 0: Dashboard
    const PlaceholderScreen(title: 'AI Chat'), // 1: AI Chat (placeholder)
    const PlaceholderScreen(title: 'Mindful'), // 2: Mindful
    const PlaceholderScreen(title: 'My Space'), // 3: My Space
    const PlaceholderScreen(title: 'Profile'), // 4: Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const OceanBackground(),
          _screens[_selectedIndex],
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: deepOcean.withOpacity(0.9),
          border: Border(
            top: BorderSide(color: waveColor.withOpacity(0.3), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.dashboard, "Dashboard", "🌊", 0),
            _buildNavItem(Icons.smart_toy, "AI Chat", "🤖", 1), // Changed from chat to AI
            _buildNavItem(Icons.self_improvement, "Mindful", "🧘", 2),
            _buildNavItem(Icons.calendar_month, "My Space", "📅", 3),
            _buildNavItem(Icons.person, "Profile", "👤", 4),
          ],
        ),
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 70, right: 16),
        child: FloatingCloud(
          unreadCount: 3,
          hasUrgent: true,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildNavItem(IconData icon, String label, String emoji, int index) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        
        if (index == 1) {
          // Navigate to AI Home screen
          Navigator.pushNamed(context, '/ai_home');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/mindfulness_home');
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MySpaceScreen(parentData: widget.parentData),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: isActive 
                  ? const LinearGradient(
                      colors: [seaTeal, waveColor],
                    )
                  : null,
              color: isActive ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              border: isActive 
                  ? Border.all(color: seaTeal.withOpacity(0.5), width: 2)
                  : Border.all(color: Colors.transparent),
            ),
            child: Center(
              child: isActive
                  ? Text(emoji, style: const TextStyle(fontSize: 22))
                  : Icon(icon, color: Colors.white70, size: 24),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? seaTeal : Colors.white70,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ============ DASHBOARD CONTENT ============
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = context.findAncestorWidgetOfExactType<StudentDashboard>();
    final parentData = dashboard?.parentData;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const OceanHeader(),
            ParentStatusCard(parentData: parentData),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OceanCircularStatCard(
                    icon: Icons.emoji_emotions,
                    title: "Mood Tracking",
                    mainValue: "85%",
                    subValue: "Positive",
                    progress: 0.85,
                    progressColor: seaTeal,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OceanCircularStatCard(
                    icon: Icons.nightlight_round,
                    title: "Sleep Quality",
                    mainValue: "72%",
                    subValue: "Good",
                    progress: 0.72,
                    progressColor: waveColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OceanSquareCard(
                    icon: Icons.self_improvement,
                    title: "Meditation Streak",
                    value: "14 days",
                    subtitle: "Personal best!",
                    accentColor: coral,
                    creature: "🦈",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OceanSquareCard(
                    icon: Icons.psychology,
                    title: "AI Sessions",
                    value: "52",
                    subtitle: "This month",
                    accentColor: waveColor,
                    creature: "🐬",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OceanSquareCard(
                    icon: Icons.health_and_safety,
                    title: "Stress Level",
                    value: "32%",
                    subtitle: "Low",
                    accentColor: sand,
                    creature: "🐢",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            OceanQuickActions(parentData: parentData),
            const SizedBox(height: 25),
            const MentalWellnessCard(),
            const SizedBox(height: 25),
            const OceanFooter(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ============ PLACEHOLDER SCREEN ============
class PlaceholderScreen extends StatelessWidget {
  final String title;
  
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$title Screen - Coming Soon!',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}