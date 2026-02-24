import 'package:flutter/material.dart';

class Level1WarningScreen extends StatefulWidget {
  final int pranksterScore;
  final int genuineScore;
  
  const Level1WarningScreen({
    super.key,
    required this.pranksterScore,
    required this.genuineScore,
  });

  @override
  State<Level1WarningScreen> createState() => _Level1WarningScreenState();
}

class _Level1WarningScreenState extends State<Level1WarningScreen> {
  String? _selectedPath;
  bool _showScoreDetails = false;
  bool _pulseAnimation = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _pulseAnimation = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ============ DARK GAME OF THRONES + STRANGER THINGS THEME ============
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0A0A23), // Midnight sky
                    Color(0xFF1A1A3A), // Deep purple
                    Color(0xFF2A0A45), // Stranger Things purple
                    Color(0xFF1E0B2E), // Game of Thrones dark
                  ],
                ),
              ),
              child: CustomPaint(
                painter: _StarsPainter(),
              ),
            ),
          ),
          
          // ============ PULSING RED ALERT GLOW ============
          if (_pulseAnimation)
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.5 + (DateTime.now().millisecond % 1000) / 2000,
                    colors: [
                      const Color(0xFFE63946).withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          
          // ============ STRANGER THINGS TEXT EFFECT ============
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _pulseAnimation ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: const Text(
                'STRANGER DANGER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.red,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    
                    // Game of Thrones icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('🐺', style: TextStyle(fontSize: 28)),
                        Text('👑', style: TextStyle(fontSize: 28)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    
                    // ============ EPIC HEADER ============
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            const Color(0xFF2A0A45).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE63946),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '⚔️ PRANKSTER DETECTED ⚔️',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '"The Night is Dark and Full of Tests"',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // SCORE DISPLAY
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showScoreDetails = !_showScoreDetails;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE63946).withOpacity(0.5),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            '🐬 GENUINE',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.cyan,
                                            ),
                                          ),
                                          Text(
                                            '${widget.genuineScore}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.cyan,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 2,
                                        height: 25,
                                        color: Colors.white30,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            '🦈 PRANKSTER',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFFE63946),
                                            ),
                                          ),
                                          Text(
                                            '${widget.pranksterScore}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFFE63946),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  
                                  if (_showScoreDetails) ...[
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        '+3 genuine 🐬 | +3 prankster 🦈 | +1 neutral 🐠',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // ============ DRAMATIC MAIN MESSAGE ============
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.amber,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🎮 CHOOSE YOUR FATE 🎮',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Our system detected potential testing behavior.\n\n'
                            'Select your true intent carefully:',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: const Text(
                              'Choose wisely. Paths have consequences.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // ============ PATH OPTIONS ============
                    // PATH A: GENUINE USER
                    _buildPathOption(
                      title: 'PATH A: "I seek mental wellness"',
                      subtitle: 'Continue to safe, gentle onboarding',
                      icon: '🛡️',
                      color: Colors.green,
                      description: 'For genuine users seeking support',
                      isSelected: _selectedPath == 'genuine',
                      onTap: () => _selectPath('genuine'),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // PATH B: EXPLORING
                    _buildPathOption(
                      title: 'PATH B: "Just exploring"',
                      subtitle: 'Continue with stern warnings',
                      icon: '🔍',
                      color: Colors.orange,
                      description: 'For curious users who may be testing',
                      isSelected: _selectedPath == 'exploring',
                      onTap: () => _selectPath('exploring'),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // PATH C: TESTING
                    _buildPathOption(
                      title: 'PATH C: "Testing the app"',
                      subtitle: 'Enter full danger zone',
                      icon: '⚠️',
                      color: Colors.red,
                      description: 'For users testing with prank intent',
                      isSelected: _selectedPath == 'testing',
                      onTap: () => _selectPath('testing'),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // ============ CONTINUE BUTTON ============
                    if (_selectedPath != null)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: _selectedPath == 'testing'
                                ? const LinearGradient(
                                    colors: [Colors.red, Colors.orange],
                                  )
                                : _selectedPath == 'exploring'
                                    ? const LinearGradient(
                                        colors: [Colors.orange, Colors.amber],
                                      )
                                    : const LinearGradient(
                                        colors: [Colors.green, Colors.lightGreen],
                                      ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _continueToNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedPath == 'genuine'
                                      ? '🛡️ '
                                      : _selectedPath == 'exploring'
                                          ? '🔍 '
                                          : '⚠️ ',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedPath == 'genuine'
                                      ? 'Continue to Safe Onboarding'
                                      : 'Proceed to Level 2',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: _selectedPath == 'testing'
                                        ? Colors.red
                                        : _selectedPath == 'exploring'
                                            ? Colors.orange
                                            : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    
                    // ============ EXIT OPTION ============
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 14),
                      label: const Text(
                        'Return to Screening',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    
                    // ============ FOOTER QUOTE ============
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Text(
                        '"When you play games with mental health,\n'
                        'you awaken consequences you cannot put to sleep."',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white30,
                          fontSize: 9,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPathOption({
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isSelected
                  ? [
                      color.withOpacity(0.3),
                      color.withOpacity(0.1),
                      Colors.black.withOpacity(0.8),
                    ]
                  : [
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.3),
                    ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? color : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // ICON CONTAINER
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : color.withOpacity(0.5),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: TextStyle(
                      fontSize: isSelected ? 26 : 22,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // TEXT CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? color : Colors.white,
                      ),
                    ),
                    
                    // SUBTITLE
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    
                    // DESCRIPTION
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // ARROW INDICATOR
              Icon(
                Icons.arrow_forward_ios,
                color: isSelected ? color : Colors.grey,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _selectPath(String path) {
    setState(() {
      _selectedPath = path;
    });
  }
  
  void _continueToNext() {
    if (_selectedPath == 'genuine') {
      // Go to gentle terms
      Navigator.pushNamed(
        context,
        '/terms',
        arguments: {
          'isPotentialPrankster': false,
          'pranksterScore': widget.pranksterScore,
          'genuineScore': widget.genuineScore,
        },
      );
    } else {
      // Go to Level 2: Winterfell Warning
      Navigator.pushNamed(
        context,
        '/level2_winterfell',
        arguments: {
          'pranksterScore': widget.pranksterScore,
          'genuineScore': widget.genuineScore,
          'userPath': _selectedPath!,
        },
      );
    }
  }
}

// ============ SIMPLIFIED STARS BACKGROUND PAINTER ============
class _StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    // Use a simple deterministic algorithm for stars
    for (int i = 0; i < 50; i++) {
      // Create deterministic positions based on i
      final x = (i * 137) % size.width.toInt();
      final y = (i * 173) % size.height.toInt();
      final radius = (i % 3 + 1) * 0.5;
      
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}