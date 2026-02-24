// lib/screens/parent_contact_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';

// ============ COLOR CONSTANTS ============
const Color navyDark = Color(0xFF1E3A8A);
const Color navyMedium = Color(0xFF4A6FA5);
const Color beaconYellow = Color(0xFFFFD166);
const Color accentTeal = Color(0xFF06D6A0);
const Color stormDark = Color(0xFF152642);

// ============ WAVE PAINTER CLASS ============
class WavePainter extends CustomPainter {
  final Color waveColor;
  
  WavePainter({required this.waveColor});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;
    
    final path1 = Path();
    path1.moveTo(0, size.height * 0.8);
    path1.quadraticBezierTo(
      size.width * 0.25, size.height * 0.6,
      size.width * 0.5, size.height * 0.8,
    );
    path1.quadraticBezierTo(
      size.width * 0.75, size.height * 1.0,
      size.width, size.height * 0.8,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    
    final path2 = Path();
    path2.moveTo(0, size.height * 0.9);
    path2.quadraticBezierTo(
      size.width * 0.3, size.height * 0.7,
      size.width * 0.6, size.height * 0.9,
    );
    path2.quadraticBezierTo(
      size.width * 0.8, size.height * 1.1,
      size.width, size.height * 0.9,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint..color = waveColor.withOpacity(0.7));
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============ LIGHTHOUSE HARBOR BACKGROUND ============
class LighthouseHarborBackground extends StatelessWidget {
  final bool isPrankster;
  final Animation<double> beaconAnimation;
  
  const LighthouseHarborBackground({
    Key? key,
    required this.isPrankster,
    required this.beaconAnimation,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isPrankster
              ? [
                  const Color(0xFF0A0F1C),
                  const Color(0xFF152642),
                  const Color(0xFF1E3A5F),
                ]
              : [
                  const Color(0xFF0A2463),
                  const Color(0xFF1E3A8A),
                  const Color(0xFF4A6FA5),
                  const Color(0xFF6B9AC4),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Ocean Waves Pattern
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              child: CustomPaint(
                painter: WavePainter(
                  waveColor: isPrankster 
                      ? const Color(0xFF1E3A5F).withOpacity(0.4)
                      : const Color(0xFF4A6FA5).withOpacity(0.3),
                ),
              ),
            ),
          ),
          
          // Lighthouse
          Positioned(
            right: 20,
            bottom: 100,
            child: Container(
              width: 100,
              height: 200,
              child: Stack(
                children: [
                  // Lighthouse Tower
                  Container(
                    width: 30,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFC0C0C0),
                          Color(0xFFA0A0A0),
                          Color(0xFF808080),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  
                  // Lighthouse Base
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 50,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4513),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  
                  // Lighthouse Top
                  Positioned(
                    top: 10,
                    left: -10,
                    child: Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  
                  // Beacon Light (Animated)
                  Positioned(
                    top: 25,
                    left: 25,
                    child: AnimatedBuilder(
                      animation: beaconAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            beaconAnimation.value * 200 - 100,
                            0,
                          ),
                          child: Container(
                            width: 300,
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.yellow.withOpacity(0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Window
                  Positioned(
                    top: 80,
                    left: 5,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD700),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Harbor Rocks
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF5D4037),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: SizedBox()),
                  _buildRock(40, 60),
                  const SizedBox(width: 30),
                  _buildRock(50, 70),
                  const SizedBox(width: 40),
                  _buildRock(35, 55),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
          
          // Ocean Bubbles
          Positioned(bottom: 80, left: 50, child: _buildBubble(20)),
          Positioned(bottom: 120, right: 100, child: _buildBubble(15)),
          Positioned(bottom: 200, left: 150, child: _buildBubble(25)),
          Positioned(bottom: 180, right: 200, child: _buildBubble(18)),
          
          // Boats
          if (!isPrankster)
            Positioned(
              bottom: 150,
              left: 80,
              child: Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B4513),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2691E),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
          
          // Seagulls
          if (!isPrankster) ...[
            Positioned(top: 100, left: 100, child: const Text("🕊️", style: TextStyle(fontSize: 24))),
            Positioned(top: 120, left: 150, child: const Text("🕊️", style: TextStyle(fontSize: 20))),
          ],
        ],
      ),
    );
  }
  
  Widget _buildRock(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF6D4C41),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
  
  Widget _buildBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF90E0EF).withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF90E0EF).withOpacity(0.3),
          width: 1,
        ),
      ),
    );
  }
}

// ============ MAIN PARENT CONTACT SCREEN ============
class ParentContactScreen extends StatefulWidget {
  final bool isPrankster;
  final int pranksterScore;
  final String userType;
  final int? fakeCrisisCount;
  final int? calculatedFine;
  final String? fineLevel;
  
  const ParentContactScreen({
    Key? key,
    required this.isPrankster,
    required this.pranksterScore,
    required this.userType,
    this.fakeCrisisCount,
    this.calculatedFine,
    this.fineLevel,
  }) : super(key: key);

  @override
  State<ParentContactScreen> createState() => _ParentContactScreenState();
}

class _ParentContactScreenState extends State<ParentContactScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Text Controllers
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController parentPhoneController = TextEditingController();
  final TextEditingController parentEmailController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController additionalContactController = TextEditingController();
  
  // Additional Contacts
  final List<String> additionalContacts = [];
  
  // Permission Switches
  bool notifyForStress = true;
  bool notifyForCrisis = true;
  bool allowDirectContact = false;
  bool shareConversationTips = true;
  
  // OTP Verification
  bool otpSent = false;
  String otpCode = '';
  final TextEditingController otpController = TextEditingController();
  
  // Animation
  late AnimationController _animationController;
  late Animation<double> _beaconAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _beaconAnimation = Tween<double>(begin: -0.2, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _sendOTP() {
    otpCode = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    setState(() => otpSent = true);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.send, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text('Beacon code $otpCode sent to ${parentPhoneController.text}')),
          ],
        ),
        backgroundColor: accentTeal,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // FIXED: no const needed here
      ),
    );
  }
  
  void _resendOTP() {
    otpCode = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.refresh, color: Colors.white),
            const SizedBox(width: 10),
            Text('New beacon code $otpCode sent'),
          ],
        ),
        backgroundColor: navyMedium,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // FIXED: no const needed here
      ),
    );
  }
  
  void _verifyOTP() {
    if (otpController.text == otpCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.verified, color: Colors.white),
              SizedBox(width: 10),
              Text('Beacon verified successfully!'),
            ],
          ),
          backgroundColor: accentTeal,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))), // FIXED: use const
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 10),
              Text('Invalid beacon code. Please try again.'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))), // FIXED: use const
        ),
      );
    }
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.isPrankster && !otpSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Beacon verification is mandatory'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }
      
      final parentData = {
        'parentName': parentNameController.text,
        'parentPhone': parentPhoneController.text,
        'parentEmail': parentEmailController.text,
        'relationship': relationshipController.text,
        'additionalContacts': additionalContacts,
        'permissions': {
          'notifyForStress': notifyForStress,
          'notifyForCrisis': notifyForCrisis,
          'allowDirectContact': allowDirectContact,
          'shareConversationTips': shareConversationTips,
        },
        'phoneVerified': otpSent && otpController.text == otpCode,
        'verifiedAt': DateTime.now().toIso8601String(),
        'userType': widget.userType,
        'pranksterScore': widget.pranksterScore,
        'fakeCrisisCount': widget.fakeCrisisCount ?? 0,
        'calculatedFine': widget.calculatedFine ?? 0,
        'fineLevel': widget.fineLevel ?? 'NONE',
      };
      
      _showSuccessDialog(parentData);
    }
  }
  
  void _showSuccessDialog(Map<String, dynamic> parentData) {
    Color dialogColor = widget.isPrankster ? stormDark.withOpacity(0.95) : navyDark.withOpacity(0.95);
    Color textColor = widget.isPrankster ? const Color(0xFFE0E0E0) : const Color(0xFFF0F8FF);
    
    String title = widget.isPrankster ? '⚓ HARBOR SECURED' : '🗼 LIGHTHOUSE ACTIVE';
    String message = widget.isPrankster
      ? '✅ Stormy seas calmed. Harbor secured!\n\n'
        '• Beacon verification complete\n'
        '• Emergency contacts anchored\n'
        '• Safe navigation enabled\n\n'
        'Remember: The lighthouse guides even in stormy weather.'
      : '🐬 Lighthouse beacon activated!\n\n'
        '• Safe harbor established\n'
        '• Clever tips will guide your parents\n'
        '• Emergency support available\n'
        '• Privacy protected with anonymous insights\n\n'
        'You\'re now ready to explore the ocean safely!';
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: dialogColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: beaconYellow, width: 2.5),
        ),
        elevation: 20,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [beaconYellow, accentTeal],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: beaconYellow.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  widget.isPrankster ? Icons.anchor : Icons.lightbulb,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                message,
                style: TextStyle(
                  fontSize: 13.5,
                  color: textColor.withOpacity(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                      context,
                      '/student_dashboard',
                      arguments: parentData,
                    );
                  },
                  icon: const Icon(Icons.sailing, size: 20),
                  label: const Text(
                    'SET SAIL TO DASHBOARD',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: beaconYellow.withOpacity(0.95),
                    foregroundColor: navyDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = widget.isPrankster ? stormDark.withOpacity(0.85) : navyDark.withOpacity(0.85);
    final Color borderColor = widget.isPrankster ? Colors.red.withOpacity(0.5) : beaconYellow.withOpacity(0.5);
    final Color textColor = widget.isPrankster ? const Color(0xFFE0E0E0) : const Color(0xFFF0F8FF);
    
    return Scaffold(
      body: Stack(
        children: [
          LighthouseHarborBackground(
            isPrankster: widget.isPrankster,
            beaconAnimation: _beaconAnimation,
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(textColor),
                    const SizedBox(height: 20),
                    if (widget.isPrankster) _buildWarningBanner(),
                    const SizedBox(height: 20),
                    _buildMandatoryNotice(textColor, backgroundColor, borderColor),
                    const SizedBox(height: 20),
                    _buildContactForm(textColor, backgroundColor, borderColor),
                    const SizedBox(height: 30),
                    _buildAdditionalContacts(textColor, backgroundColor, borderColor),
                    const SizedBox(height: 30),
                    _buildPermissionsSection(textColor, backgroundColor, borderColor),
                    const SizedBox(height: 30),
                    if (otpSent) _buildOTPVerification(textColor, backgroundColor, borderColor),
                    const SizedBox(height: 40),
                    _buildSubmitButton(textColor, backgroundColor, borderColor),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeaderSection(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: beaconYellow.withOpacity(0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: beaconYellow,
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isPrankster ? '⚓ HARBOR VERIFICATION' : '🗼 LIGHTHOUSE HARBOR',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.isPrankster 
                        ? 'Safe passage requires proper verification'
                        : 'Your guiding light in mental wellness journey',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildMandatoryNotice(Color textColor, Color backgroundColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            beaconYellow.withOpacity(0.15),
            Colors.white.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: beaconYellow,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [beaconYellow, Color(0xFFFFB347)],
              ),
            ),
            child: const Icon(Icons.error_outline, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '⚠️ ',
                      style: TextStyle(fontSize: 22, color: beaconYellow),
                    ),
                    const Text(
                      'MANDATORY REQUIREMENT',
                      style: TextStyle(
                        color: beaconYellow,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Parent/Guardian contact is REQUIRED\n'
                  '• Cannot proceed without verification\n'
                  '• Emergency support system\n'
                  '• Crisis notification protocol\n'
                  '• Legal requirement for minors',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF330000),
            Color(0xFF660000),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 3,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(0.2),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '⚠️ FINAL WARNING - STORMY SEAS AHEAD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lighthouse verification required for safe passage.\n'
                  'Fake information will trigger emergency protocols.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactForm(Color textColor, Color backgroundColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: beaconYellow.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: borderColor.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: beaconYellow.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: beaconYellow.withOpacity(0.4), width: 1.5),
                    ),
                    child: const Icon(Icons.person, color: beaconYellow, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Primary Parent/Guardian Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Required for emergency contact and support',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            _buildTransparentFormField(
              label: 'Parent/Guardian Name',
              isRequired: true,
              hint: 'Enter full name',
              controller: parentNameController,
              icon: Icons.person,
              textColor: textColor,
              borderColor: borderColor,
              validator: (value) {
                if (value == null || value.isEmpty) return 'This field is required';
                return null;
              },
            ),
            
            const SizedBox(height: 18),
            
            _buildTransparentFormField(
              label: 'Mobile Number',
              isRequired: true,
              hint: 'Enter 10-digit mobile number',
              controller: parentPhoneController,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              textColor: textColor,
              borderColor: borderColor,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Phone number is required';
                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) return 'Enter valid Indian mobile number';
                return null;
              },
            ),
            
            const SizedBox(height: 18),
            
            _buildTransparentFormField(
              label: 'Email Address',
              isRequired: false,
              hint: 'parent@example.com',
              controller: parentEmailController,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              textColor: textColor,
              borderColor: borderColor,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Enter valid email address';
                  }
                }
                return null;
              },
            ),
            
            const SizedBox(height: 18),
            
            _buildTransparentFormField(
              label: 'Relationship',
              isRequired: true,
              hint: 'Mother / Father / Guardian / Other',
              controller: relationshipController,
              icon: Icons.family_restroom,
              textColor: textColor,
              borderColor: borderColor,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please specify relationship';
                return null;
              },
            ),
            
            const SizedBox(height: 25),
            
            if (!otpSent && parentPhoneController.text.length == 10)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _sendOTP,
                  icon: const Icon(Icons.verified_user, size: 20),
                  label: const Text(
                    'SEND VERIFICATION BEACON',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: beaconYellow.withOpacity(0.9),
                    foregroundColor: navyDark,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: beaconYellow, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTransparentFormField({
    required String label,
    required bool isRequired,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required Color textColor,
    required Color borderColor,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: beaconYellow,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(width: 6),
            if (isRequired)
              const Text(
                '*',
                style: TextStyle(
                  color: beaconYellow,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: textColor,
            fontSize: 15.5,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 14.5,
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(
                icon,
                color: beaconYellow,
                size: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: beaconYellow, width: 2),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: validator,
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }
  
  Widget _buildAdditionalContacts(Color textColor, Color backgroundColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: borderColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: accentTeal.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accentTeal.withOpacity(0.4), width: 1.5),
                  ),
                  child: const Icon(Icons.anchor, color: accentTeal, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Additional Anchors (Optional)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.isPrankster
                          ? 'Trusted contacts who can help guide you to safety'
                          : 'Friends, relatives, or mentors who can support you',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: borderColor.withOpacity(0.5)),
                  ),
                  child: TextFormField(
                    controller: additionalContactController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Enter name and phone number',
                      hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                      prefixIcon: const Icon(Icons.contact_phone, color: beaconYellow, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [accentTeal, accentTeal],
                  ),
                  border: Border.all(color: beaconYellow, width: 1.5),
                ),
                child: IconButton(
                  onPressed: () {
                    if (additionalContactController.text.isNotEmpty) {
                      setState(() {
                        additionalContacts.add(additionalContactController.text);
                        additionalContactController.clear();
                      });
                    }
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (additionalContacts.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anchors Set:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                ...additionalContacts.map((contact) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: accentTeal.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: accentTeal.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: accentTeal.withOpacity(0.3)),
                          ),
                          child: const Icon(Icons.person_pin_circle, color: accentTeal, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            contact,
                            style: TextStyle(
                              fontSize: 14.5,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, size: 20),
                          color: Colors.red[300],
                          onPressed: () => setState(() => additionalContacts.remove(contact)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }
  
  Widget _buildPermissionsSection(Color textColor, Color backgroundColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: borderColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: beaconYellow.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: beaconYellow.withOpacity(0.4), width: 1.5),
                  ),
                  child: const Icon(Icons.lightbulb, color: beaconYellow, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lighthouse Beacon Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Customize how your lighthouse guides you',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          
          _buildTransparentPermissionSwitch(
            title: 'Beacon for high stress',
            subtitle: 'Send guiding light when you\'re overwhelmed',
            icon: Icons.waves,
            value: notifyForStress,
            textColor: textColor,
            borderColor: borderColor,
            onChanged: (value) => setState(() => notifyForStress = value),
          ),
          
          _buildTransparentDivider(textColor),
          
          _buildTransparentPermissionSwitch(
            title: 'Storm warning notification',
            subtitle: 'Immediate contact in critical situations',
            icon: Icons.warning,
            value: notifyForCrisis,
            textColor: textColor,
            borderColor: borderColor,
            onChanged: (value) => setState(() => notifyForCrisis = value),
          ),
          
          _buildTransparentDivider(textColor),
          
          _buildTransparentPermissionSwitch(
            title: 'Share ocean insights',
            subtitle: 'Anonymous tips about your well-being',
            icon: Icons.insights,
            value: shareConversationTips,
            textColor: textColor,
            borderColor: borderColor,
            onChanged: (value) => setState(() => shareConversationTips = value),
          ),
          
          _buildTransparentDivider(textColor),
          
          _buildTransparentPermissionSwitch(
            title: 'Allow direct lighthouse contact',
            subtitle: widget.isPrankster 
              ? 'Parents can guide you through app (Recommended OFF)'
              : 'Parents can reach out directly when needed',
            icon: Icons.phone,
            value: allowDirectContact,
            textColor: textColor,
            borderColor: borderColor,
            onChanged: (value) => setState(() => allowDirectContact = value),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTransparentPermissionSwitch({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Color textColor,
    required Color borderColor,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: beaconYellow.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor.withOpacity(0.3)),
            ),
            child: Icon(icon, color: beaconYellow, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: beaconYellow,
            activeTrackColor: beaconYellow.withOpacity(0.4),
            inactiveThumbColor: textColor.withOpacity(0.5),
            inactiveTrackColor: textColor.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTransparentDivider(Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        color: textColor.withOpacity(0.2),
        height: 1,
      ),
    );
  }
  
  Widget _buildOTPVerification(Color textColor, Color backgroundColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: beaconYellow, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: beaconYellow.withOpacity(0.15),
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
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [accentTeal, beaconYellow],
                  ),
                ),
                child: const Icon(Icons.verified, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BEACON VERIFICATION',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Secure your lighthouse connection',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Enter 6-digit beacon code sent to ${parentPhoneController.text}',
            style: TextStyle(
              fontSize: 14,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: beaconYellow.withOpacity(0.5)),
            ),
            child: TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: const TextStyle(
                fontSize: 26,
                letterSpacing: 12,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                counterText: '',
                hintText: '••••••',
                hintStyle: TextStyle(
                  letterSpacing: 12,
                  color: Colors.white54,
                  fontWeight: FontWeight.w800,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 0),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: _resendOTP,
                icon: const Icon(Icons.refresh, color: beaconYellow, size: 18),
                label: const Text(
                  'Resend Beacon Code',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: beaconYellow,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _verifyOTP,
                icon: const Icon(Icons.verified, size: 18),
                label: const Text(
                  'VERIFY BEACON',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: beaconYellow.withOpacity(0.9),
                  foregroundColor: navyDark,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSubmitButton(Color textColor, Color backgroundColor, Color borderColor) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _submitForm,
        icon: const Icon(Icons.anchor, size: 24),
        label: Text(
          widget.isPrankster ? 'ANCHOR IN HARBOR' : 'SET LIGHTHOUSE BEACON',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: beaconYellow.withOpacity(0.95),
          foregroundColor: navyDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: beaconYellow, width: 2),
        ),
      ),
    );
  }
}