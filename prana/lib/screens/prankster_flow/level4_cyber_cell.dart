import 'package:flutter/material.dart';

class Level4CyberCellScreen extends StatefulWidget {
  final int pranksterScore;
  final int genuineScore;
  final String userPath;
  final int fakeCrisisCount;
  final int calculatedFine;
  final String fineLevel;
  
  const Level4CyberCellScreen({
    super.key,
    required this.pranksterScore,
    required this.genuineScore,
    required this.userPath,
    required this.fakeCrisisCount,
    required this.calculatedFine,
    required this.fineLevel,
  });

  @override
  State<Level4CyberCellScreen> createState() => _Level4CyberCellScreenState();
}

class _Level4CyberCellScreenState extends State<Level4CyberCellScreen> with SingleTickerProviderStateMixin {
  String _terminalText = '';
  bool _showFIR = false;
  bool _showLocation = false;
  bool _showFineDetails = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _startTerminalAnimation();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startTerminalAnimation() {
    final messages = [
      '> Initializing Cyber Cell Terminal...',
      '> Accessing user database...',
      '> Analyzing prankster behavior...',
      '> Fine Level: ${widget.fineLevel}',
      '> Fine Amount: ₹${widget.calculatedFine}',
      '> Connecting to police servers...',
      '> SYSTEM READY',
    ];

    _typeWriterEffect(messages, 0);
  }

  void _typeWriterEffect(List<String> messages, int index) {
    if (index >= messages.length) {
      setState(() {
        _terminalText += '\n> Enter "help" for commands';
      });
      return;
    }

    String message = messages[index];
    for (int i = 0; i < message.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) {
          setState(() {
            _terminalText += message[i];
          });
          if (i == message.length - 1) {
            setState(() {
              _terminalText += '\n';
            });
            _typeWriterEffect(messages, index + 1);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ============ MATRIX CODE RAIN BACKGROUND ============
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: CustomPaint(
                painter: MatrixRainPainter(
                  animation: _animationController,
                  textLength: 50,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
          // ============ GREEN TINT OVERLAY ============
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF00FF00).withOpacity(0.05),
                    const Color(0xFF00FF00).withOpacity(0.02),
                  ],
                ),
              ),
            ),
          ),
          
          // ============ SCAN LINE EFFECT ============
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        const Color(0xFF00FF00).withOpacity(0.1),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 0.5, 0.55, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ============ CYBER CELL HEADER ============
                    Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        border: Border.all(
                          color: const Color(0xFF00FF00),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00FF00).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🚨 CYBER CELL TERMINAL 🚨',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF00FF00),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: _getFineColor().withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _getFineColor()),
                            ),
                            child: Text(
                              '${widget.fineLevel} OFFENSE - ₹${widget.calculatedFine} FINE',
                              style: TextStyle(
                                color: _getFineColor(),
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // ============ TERMINAL OUTPUT ============
                    Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        border: Border.all(color: const Color(0xFF00FF00)),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00FF00).withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _terminalText,
                              style: const TextStyle(
                                color: Color(0xFF00FF00),
                                fontSize: 14,
                                fontFamily: 'Courier',
                                letterSpacing: 0.5,
                              ),
                            ),
                            
                            // CURSOR BLINK
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _animationController.value < 0.5 ? 1.0 : 0.0,
                                  child: const Text(
                                    '_',
                                    style: TextStyle(
                                      color: Color(0xFF00FF00),
                                      fontSize: 14,
                                      fontFamily: 'Courier',
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            if (_showFIR) ...[
                              const SizedBox(height: 20),
                              _buildFIRSection(),
                            ],
                            
                            if (_showFineDetails) ...[
                              const SizedBox(height: 20),
                              _buildFineDistributionSection(),
                            ],
                            
                            if (_showLocation) ...[
                              const SizedBox(height: 20),
                              _buildLocationSection(),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    // ============ ACTION BUTTONS ============
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          // FIR BUTTON
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showFIR = !_showFIR;
                                if (_showFIR) _showFineDetails = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.3),
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.red.withOpacity(0.5)),
                              ),
                            ),
                            icon: const Icon(Icons.gavel, size: 18),
                            label: const Text('SHOW FIR & FINE'),
                          ),
                          
                          // FINE DISTRIBUTION BUTTON
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showFineDetails = !_showFineDetails;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.withOpacity(0.3),
                              foregroundColor: const Color(0xFF00FF00),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: const Color(0xFF00FF00).withOpacity(0.5)),
                              ),
                            ),
                            icon: const Icon(Icons.pie_chart, size: 18),
                            label: const Text('FINE DISTRIBUTION'),
                          ),
                          
                          // LOCATION BUTTON
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showLocation = !_showLocation;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.withOpacity(0.3),
                              foregroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.blue.withOpacity(0.5)),
                              ),
                            ),
                            icon: const Icon(Icons.location_on, size: 18),
                            label: const Text('TRACKING'),
                          ),
                        ],
                      ),
                    ),
                    
                    // ============ MANDATORY PARENT VERIFICATION BUTTON ============
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton.icon(
                        onPressed: _proceedToParentScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.7),
                          foregroundColor: const Color(0xFF00FF00),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFF00FF00), width: 2),
                          ),
                          elevation: 5,
                          shadowColor: const Color(0xFF00FF00).withOpacity(0.5),
                        ),
                        icon: const Icon(Icons.family_restroom, size: 24),
                        label: const Text(
                          '✅ PROCEED TO MANDATORY PARENT VERIFICATION',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    
                    // ============ LEGAL WARNING ============
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '⚠️ MANDATORY PARENT VERIFICATION',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Parent contact is COMPULSORY for ALL users\n'
                            '• Emergency support system\n'
                            '• Crisis notification protocol\n'
                            '• Legal requirement for minors\n'
                            '• School safety integration',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Cannot proceed to dashboard without parent verification',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red[200],
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
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
  
  Color _getFineColor() {
    if (widget.calculatedFine == 2000) return Colors.yellow;
    if (widget.calculatedFine == 5000) return Colors.orange;
    if (widget.calculatedFine == 10000) return Colors.red;
    return Colors.purple;
  }
  
  Widget _buildFIRSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📄 POLICE FIR DETAILS',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 15),
          
          Text(
            'FIR No: CC/${DateTime.now().year}/${widget.calculatedFine ~/ 1000}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          
          Text(
            'Station: Cyber Crime Cell, New Delhi\n'
            'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}\n'
            'Time: ${DateTime.now().hour}:${DateTime.now().minute} IST\n'
            'Fine Amount: ₹${widget.calculatedFine}\n'
            'Offense Level: ${widget.fineLevel}\n'
            'Status: PENDING APPROVAL',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          
          const SizedBox(height: 15),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '⚖️ APPLICABLE LAWS:',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• IPC 182: False Information (6 months/fine)\n'
                  '• IPC 420: Cheating (7 years + fine)\n'
                  '• IT Act 2000 Section 66D: Cheating by personation\n'
                  '• Juvenile Justice Act 2015 (if minor)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFineDistributionSection() {
    int fine = widget.calculatedFine;
    Map<String, int> distribution = {
      'Police Training': (fine * 0.4).toInt(),
      'Free Therapy': (fine * 0.4).toInt(),
      'Server Costs': (fine * 0.12).toInt(),
      'Legal Fees': (fine * 0.08).toInt(),
    };
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: const Color(0xFF00FF00), width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💰 FINE DISTRIBUTION ANALYSIS',
            style: TextStyle(
              color: Color(0xFF00FF00),
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 15),
          
          Text(
            'Where your ₹${widget.calculatedFine} fine goes:',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          
          // DISTRIBUTION ITEMS
          ...distribution.entries.map((entry) {
            int index = distribution.keys.toList().indexOf(entry.key);
            List<Color> colors = [
              const Color(0xFF2196F3),
              const Color(0xFF4CAF50),
              const Color(0xFF00BCD4),
              const Color(0xFF9C27B0),
            ];
            
            double percentage = (entry.value / fine * 100);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors[index],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors[index].withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        '₹${entry.value}',
                        style: TextStyle(
                          color: colors[index],
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: percentage / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors[index],
                              colors[index].withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: colors[index].withOpacity(0.8),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          
          const SizedBox(height: 20),
          
          // 80% HELPS SOCIETY BANNER
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF00FF00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00FF00).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified,
                  color: Color(0xFF00FF00),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✅ 80% HELPS SOCIETY',
                        style: TextStyle(
                          color: Color(0xFF00FF00),
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                          children: [
                            TextSpan(text: '• Police: Better training & investigation\n'),
                            TextSpan(text: '• Society: Free therapy for underprivileged\n'),
                            TextSpan(text: '• Operations: Server costs & legal fees'),
                          ],
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
  
  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📍 LOCATION TRACKING SYSTEM',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 15),
          
          Row(
            children: [
              const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated Location:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      '28.6139° N, 77.2090° E',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'New Delhi, India',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: 0.8,
                      backgroundColor: Colors.black,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Accuracy: 80% (School Wi-Fi detected)',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔒 PRIVACY NOTICE',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Location tracking is ONLY activated when:\n'
                  '• Fake crisis is reported\n'
                  '• Severe misuse is detected\n'
                  '• Police investigation is requested\n\n'
                  '✅ Normal usage respects complete privacy\n'
                  '❌ Misuse triggers tracking for safety',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _proceedToParentScreen() {
    Navigator.pushNamed(
      context,
      '/parent_contact',
      arguments: {
        'isPrankster': true,
        'pranksterScore': widget.pranksterScore,
        'userType': 'MANDATORY VERIFICATION',
        'fakeCrisisCount': widget.fakeCrisisCount,
        'calculatedFine': widget.calculatedFine,
        'fineLevel': widget.fineLevel,
      },
    );
  }
}

// ============ MATRIX RAIN ANIMATION PAINTER ============
class MatrixRainPainter extends CustomPainter {
  final Animation<double> animation;
  final int textLength;
  final double fontSize;
  
  MatrixRainPainter({
    required this.animation,
    this.textLength = 30,
    this.fontSize = 16,
  }) : super(repaint: animation);
  
  final List<String> characters = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z',
    '!', '@', '#', '\$', '%', '^', '&', '*', '(', ')',
    '-', '_', '=', '+', '[', ']', '{', '}', '|', '\\',
    ';', ':', '"', "'", '<', '>', ',', '.', '?', '/',
    'α', 'β', 'γ', 'δ', 'ε', 'ζ', 'η', 'θ', 'ι', 'κ',
    'λ', 'μ', 'ν', 'ξ', 'ο', 'π', 'ρ', 'σ', 'τ', 'υ',
    'φ', 'χ', 'ψ', 'ω'
  ];
  
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    
    // Draw matrix rain drops
    for (int i = 0; i < 100; i++) {
      final column = random.nextInt((size.width / fontSize).floor());
      final speed = 1 + random.nextInt(5);
      final y = (animation.value * speed * size.height) % size.height;
      final charIndex = random.nextInt(characters.length);
      final brightness = 0.2 + random.nextDouble() * 0.8;
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: characters[charIndex],
          style: TextStyle(
            color: Color(0xFF00FF00).withOpacity(brightness),
            fontSize: fontSize,
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      
      final x = column * fontSize;
      
      // Draw character
      textPainter.paint(canvas, Offset(x, y));
      
      // Draw trailing characters with fading opacity
      for (int j = 1; j < 10; j++) {
        final trailingY = y - j * fontSize;
        if (trailingY > 0) {
          final trailingCharIndex = (charIndex + j) % characters.length;
          final trailingOpacity = 1.0 - (j * 0.1);
          
          final trailingPainter = TextPainter(
            text: TextSpan(
              text: characters[trailingCharIndex],
              style: TextStyle(
                color: Color(0xFF00FF00).withOpacity(brightness * trailingOpacity * 0.5),
                fontSize: fontSize,
                fontFamily: 'Courier',
                fontWeight: FontWeight.normal,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          
          trailingPainter.paint(canvas, Offset(x, trailingY));
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(MatrixRainPainter oldDelegate) => true;
}

// Simple random number generator
class Random {
  final int seed;
  int _state;
  
  Random(this.seed) : _state = seed;
  
  int nextInt(int max) {
    _state = (_state * 1103515245 + 12345) & 0x7fffffff;
    return _state % max;
  }
  
  double nextDouble() {
    return nextInt(1000) / 1000.0;
  }
}