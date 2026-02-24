// lib/screens/terms_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';

const Color deepOcean = Color(0xFF0A2463);
const Color oceanBlue = Color(0xFF1E3A8A);  
const Color seaTeal = Color(0xFF06D6A0);
const Color coral = Color(0xFFFF6B6B);
const Color waveColor = Color(0xFF219EBC);
const Color cardColor = Color(0xFF162447);
const Color pirateGold = Color(0xFFFFC107);
const Color pirateBrown = Color(0xFF795548);
const Color oceanParchment = Color(0xFFE3F2FD);

class TermsScreen extends StatefulWidget {
  final bool isPotentialPrankster;
  final int pranksterScore;
  final int genuineScore;
  
  const TermsScreen({
    super.key,
    required this.isPotentialPrankster,
    required this.pranksterScore,
    required this.genuineScore,
  });

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;
  bool _hasScrolledToEnd = false;
  bool _showContinueButton = false;
  List<Offset?> _signaturePoints = [];
  bool _hasSigned = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollProgress);
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollProgress);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _updateScrollProgress() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    setState(() {
      _scrollProgress = maxScroll > 0 ? currentScroll / maxScroll : 0.0;
      _hasScrolledToEnd = currentScroll >= maxScroll - 50;
      if (!_showContinueButton && _scrollProgress >= 0.8) {
        _showContinueButton = true;
      }
    });
  }
  
  void _handleContinue() {
    if (!_hasScrolledToEnd) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      return;
    }
    
    if (!_hasSigned) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sign the Ocean Pirate Contract! 🏴‍☠️'),
          backgroundColor: seaTeal,
        ),
      );
      return;
    }
    
    _proceedToMandatoryParentVerification();
  }
  
  void _proceedToMandatoryParentVerification() {
    Navigator.pushReplacementNamed(
      context,
      '/parent_contact',
      arguments: {
        'isPrankster': widget.isPotentialPrankster,
        'pranksterScore': widget.pranksterScore,
        'userType': widget.isPotentialPrankster ? 'Prankster' : 'Genuine',
      },
    );
  }
  
  void _clearSignature() {
    setState(() {
      _signaturePoints.clear();
      _hasSigned = false;
    });
  }
  
  void _completeSignature() {
    if (_signaturePoints.length > 5) {
      setState(() {
        _hasSigned = true;
      });
    }
  }
  
  List<Offset?> _generateOceanPirateSignature() {
    final List<Offset?> points = [];
    final width = MediaQuery.of(context).size.width - 120;
    final height = 80;
    
    for (double t = 0; t <= 1; t += 0.02) {
      final x = width * t;
      final y = 20 + 20 * sin(t * 4 * 3.14159);
      points.add(Offset(x + 20, y + 40));
    }
    
    points.add(null);
    
    for (double t = 0; t <= 1; t += 0.05) {
      final x = width * t;
      final y = height * t;
      points.add(Offset(x + 20, y + 20));
    }
    
    points.add(null);
    
    for (double t = 0; t <= 1; t += 0.05) {
      final x = width * t;
      final y = height * (1 - t);
      points.add(Offset(x + 20, y + 20));
    }
    
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ocean background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [deepOcean, oceanBlue],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(top: 100, left: 50, child: _buildBubble(20)),
                  Positioned(top: 200, right: 80, child: _buildBubble(15)),
                  Positioned(top: 300, left: 100, child: _buildBubble(25)),
                  Positioned(top: 400, right: 120, child: _buildBubble(18)),
                  
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
              ),
            ),
          ),
          
          // Pirate ship sailing
          Positioned(
            top: 80,
            left: 20 + (_scrollProgress * 250),
            child: Transform.rotate(
              angle: 0.1,
              child: const Text(
                '⛵',
                style: TextStyle(fontSize: 50),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  // Ocean Pirate Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [deepOcean, oceanBlue],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: seaTeal.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: seaTeal.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [seaTeal, waveColor],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: pirateGold, width: 2),
                          ),
                          child: const Center(
                            child: Text(
                              '🏴‍☠️',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ocean Pirate Contract',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Sail the seas of wellness responsibly',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: seaTeal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: deepOcean.withOpacity(0.6),
                            shape: BoxShape.circle,
                            border: Border.all(color: seaTeal, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              '${(_scrollProgress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Mandatory Parent Warning
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [coral.withOpacity(0.8), coral.withOpacity(0.6)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.red, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.white, size: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '⚠️ MANDATORY REQUIREMENT',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Parent/Guardian contact is COMPULSORY for all sailors',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Next: Parent Verification → Dashboard',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.9),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          // Section 1: Ocean Crew Rules
                          _buildHybridSection(
                            title: '🌊 Ocean Crew Rules',
                            icon: '🐚',
                            points: [
                              'Your privacy is our buried treasure',
                              'AI first mate guides your journey',
                              'Storm alerts only for real emergencies',
                              'Respect the sea and fellow sailors',
                            ],
                            color: seaTeal,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Section 2: Mandatory Parent Lighthouse
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cardColor.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.red, width: 2),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '🚨',
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '🏮 MANDATORY Parent Lighthouse',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.red,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildMandatoryPoint('COMPULSORY parent/guardian contact'),
                                          _buildMandatoryPoint('OTP verification required'),
                                          _buildMandatoryPoint('Emergency notification setup'),
                                          _buildMandatoryPoint('No dashboard access without verification'),
                                          _buildMandatoryPoint('Safety requirement for ALL sailors'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Section 3: Treasure Chest Privacy
                          _buildHybridSection(
                            title: '💰 Treasure Chest Privacy',
                            icon: '🔒',
                            points: [
                              'Your secrets are locked in Davy Jones\' Locker',
                              'No selling maps to merchants',
                              'Old logs sink after 30 days',
                              'You hold the key to your chest',
                            ],
                            color: pirateGold,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Section 4: Lifeboat Safety
                          _buildHybridSection(
                            title: '🛶 Lifeboat Safety',
                            icon: '⛑️',
                            points: [
                              'Lifeboats ready for true emergencies',
                              'Port directory for expert sailors',
                              'Daily navigation exercises',
                              '24/7 safe harbor available',
                            ],
                            color: coral,
                          ),
                          
                          // Indian Context Section
                          Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: pirateBrown.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: pirateGold, width: 2),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '🇮🇳 Indian Student Context',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildIndianPoint('Pocket money calculator: ₹5,000 = 5 months'),
                                _buildIndianPoint('School PTM (Parent-Teacher Meeting) integration'),
                                _buildIndianPoint('Indian education system consequences'),
                                _buildIndianPoint('Cultural relevance in support system'),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Pirate-Ocean Signature
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cardColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _hasSigned ? pirateGold : seaTeal,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: seaTeal.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [seaTeal, waveColor],
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: pirateGold, width: 2),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '✍️',
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Pirate Captain\'s Mark',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            _hasSigned ? 'X marks the spot! 🎯' : 'Draw your captain\'s mark',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: seaTeal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_hasSigned)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: pirateGold.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: pirateGold),
                                        ),
                                        child: const Text(
                                          'SEALED',
                                          style: TextStyle(
                                            color: pirateGold,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Ocean-themed signature canvas
                                Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        oceanParchment.withOpacity(0.3),
                                        oceanParchment.withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: seaTeal.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 20,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                waveColor.withOpacity(0.2),
                                                seaTeal.withOpacity(0.1),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      GestureDetector(
                                        onPanStart: (details) {
                                          setState(() {
                                            _signaturePoints.add(details.localPosition);
                                          });
                                        },
                                        onPanUpdate: (details) {
                                          setState(() {
                                            _signaturePoints.add(details.localPosition);
                                          });
                                        },
                                        onPanEnd: (details) {
                                          _signaturePoints.add(null);
                                          _completeSignature();
                                        },
                                        child: CustomPaint(
                                          painter: OceanPirateSignaturePainter(_signaturePoints),
                                          child: Center(
                                            child: _signaturePoints.isEmpty
                                                ? Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Text(
                                                        '🏴‍☠️',
                                                        style: TextStyle(fontSize: 40),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        'Draw your mark here',
                                                        style: TextStyle(
                                                          color: seaTeal.withOpacity(0.8),
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : null,
                                          ),
                                        ),
                                      ),
                                      
                                      Positioned(
                                        top: 5,
                                        left: 5,
                                        child: Transform.rotate(
                                          angle: -0.2,
                                          child: Text(
                                            '⚓',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: seaTeal.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Transform.rotate(
                                          angle: 0.2,
                                          child: Text(
                                            '🌊',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: waveColor.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        left: 5,
                                        child: Transform.rotate(
                                          angle: 0.2,
                                          child: Text(
                                            '💰',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: pirateGold.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        right: 5,
                                        child: Transform.rotate(
                                          angle: -0.2,
                                          child: Text(
                                            '🐬',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: seaTeal.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 15),
                                
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: _clearSignature,
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: deepOcean.withOpacity(0.5),
                                          foregroundColor: waveColor,
                                          side: BorderSide(color: waveColor),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text('Clear Mark'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _signaturePoints = _generateOceanPirateSignature();
                                            _hasSigned = true;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: pirateGold,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Draw Pirate X'),
                                            SizedBox(width: 8),
                                            Text('🏴‍☠️'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Continue button
          if (_showContinueButton)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: AnimatedOpacity(
                opacity: _showContinueButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleContinue,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _hasScrolledToEnd && _hasSigned
                              ? [seaTeal, waveColor]
                              : [deepOcean, oceanBlue],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: seaTeal.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _hasScrolledToEnd && _hasSigned
                                ? Icons.family_restroom
                                : Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _hasScrolledToEnd && _hasSigned
                                ? 'Proceed to Parent Verification 👨‍👩‍👧‍👦'
                                : 'Scroll to continue 📜',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildHybridSection({
    required String title,
    required String icon,
    required List<String> points,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...points.map((point) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_right, color: color, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildMandatoryPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIndianPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, color: pirateGold, size: 8),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: seaTeal.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: seaTeal.withOpacity(0.3), width: 1),
      ),
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

class OceanPirateSignaturePainter extends CustomPainter {
  final List<Offset?> points;
  
  OceanPirateSignaturePainter(this.points);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = seaTeal
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(OceanPirateSignaturePainter oldDelegate) =>
      oldDelegate.points != points;
}