import 'package:flutter/material.dart';
import 'level4_cyber_cell.dart'; // ADD THIS IMPORT

class Level3DangerZoneScreen extends StatefulWidget {
  final int pranksterScore;
  final int genuineScore;
  final String userPath;
  
  const Level3DangerZoneScreen({
    super.key,
    required this.pranksterScore,
    required this.genuineScore,
    required this.userPath,
  });

  @override
  State<Level3DangerZoneScreen> createState() => _Level3DangerZoneScreenState();
}

class _Level3DangerZoneScreenState extends State<Level3DangerZoneScreen> {
  int _fakeCrisisCounter = 0;
  bool _showDemogorgon = false;
  bool _pulseRed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _pulseRed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // TEWAIMI RED/BLACK THEME
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A0000),
                    Color(0xFF330000),
                    Color(0xFF4D0000),
                    Color(0xFF000000),
                  ],
                ),
              ),
            ),
          ),
          
          // PULSING RED GLOW
          if (_pulseRed)
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.5 + (DateTime.now().millisecond % 1000) / 2000,
                    colors: [
                      Colors.red.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          
          // TEWAIMI BANNER TEXT
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                border: Border.all(color: Colors.red, width: 3),
              ),
              child: const Text(
                'TEWAIMI\nCOMING VERY SOON!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                  letterSpacing: 3,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.red,
                      blurRadius: 15,
                    ),
                    Shadow(
                      color: Colors.black,
                      blurRadius: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // DEMOGORGON IMAGE
          if (_showDemogorgon)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '👹',
                        style: TextStyle(fontSize: 100),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                        child: const Text(
                          'DEMOGORGON ACTIVATED!\nStranger Danger Detected!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
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
                    const SizedBox(height: 100),
                    
                    // DANGER ZONE HEADER
                    Container(
                      padding: const EdgeInsets.all(25),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFFFF0000),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '⚠️ DANGER ZONE - LEVEL 3 ⚠️',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '"Testing mental health apps has real consequences"',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          
                          // SCORE DISPLAY
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Genuine Score',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.cyan,
                                      ),
                                    ),
                                    Text(
                                      '${widget.genuineScore}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.cyan,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: Colors.white30,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Prank Score',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      '${widget.pranksterScore}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // SCARE METER
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red, width: 2),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🎮 SCARE METER ACTIVATED 🎮',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: widget.pranksterScore / 9,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.red, Colors.orange],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Prank Score: ${widget.pranksterScore}/9 (${((widget.pranksterScore / 9) * 100).toStringAsFixed(0)}%)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // POCKET MONEY CALCULATOR
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '💰 INDIAN POCKET MONEY CALCULATOR 💰',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 15),
                          
                          _buildMoneyRow('Monthly Pocket Money', '₹1,000', Colors.white),
                          _buildMoneyRow('Fine for Misuse', '₹5,000', Colors.red),
                          _buildMoneyRow('Months of Money Lost', '5 months', Colors.red),
                          
                          const SizedBox(height: 15),
                          
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red),
                            ),
                            child: const Text(
                              '💸 "Beta, teri pocket money 5 mahine ke liye gayi!"\n(Son, your pocket money is gone for 5 months!)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // SCHOOL CONSEQUENCES
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.yellow, width: 2),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🏫 SCHOOL CONSEQUENCES 🏫',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.yellow,
                            ),
                          ),
                          const SizedBox(height: 15),
                          
                          _buildSchoolConsequence('Principal Meeting', 'Mandatory PTM with parents'),
                          _buildSchoolConsequence('Academic Suspension', '7-14 days suspension'),
                          _buildSchoolConsequence('Permanent Record', 'Mark on behavioral record'),
                          _buildSchoolConsequence('College Impact', 'Affects recommendation letters'),
                          
                          const SizedBox(height: 15),
                          
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.yellow.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.yellow),
                            ),
                            child: const Text(
                              '📞 "Principal ne bulaya hai tujhe, beta!"\n(Principal has called you, son!)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // ACTION BUTTONS
                    // DEMOGORGON BUTTON
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showDemogorgon = true;
                            _fakeCrisisCounter++;
                          });
                          
                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              _showDemogorgon = false;
                            });
                            
                            if (_fakeCrisisCounter >= 3) {
                              _showCrisisAlert();
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '👹 ',
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              'TRIGGER DEMOGORGON (${_fakeCrisisCounter}/3)',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // PROCEED TO CYBER CELL BUTTON
                    ElevatedButton(
                      onPressed: _proceedToCyberCell,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                            color: Colors.red,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '🖥️ ',
                            style: TextStyle(fontSize: 24),
                          ),
                          const Text(
                            'ENTER CYBER CELL TERMINAL',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // WARNING FOOTER
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.red.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '⚠️ FINAL WARNING ⚠️',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Fake crisis triggers: $_fakeCrisisCounter/3\n'
                            'Next level: Cyber Cell with police FIR preview',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
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
  
  Widget _buildMoneyRow(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSchoolConsequence(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.yellow.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.yellow, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showCrisisAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text(
              '🚨 FAKE CRISIS ALERT 🚨',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        content: const Text(
          'You triggered 3 fake crisis alerts!\n\n'
          'This will result in:\n'
          '• Immediate Police FIR\n'
          '• ₹10,000 fine\n'
          '• School suspension\n'
          '• Parent notification\n\n'
          '⚠️ This is your final warning!',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _proceedToCyberCell();
            },
            child: const Text(
              'UNDERSTOOD - CONTINUE',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
  
  void _proceedToCyberCell() {
    // Calculate fine based on fake crisis count
    int calculatedFine = _fakeCrisisCounter >= 1 ? 10000 : 5000;
    String fineLevel = _fakeCrisisCounter >= 1 ? 'SEVERE' : 'MEDIUM';
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Level4CyberCellScreen(
          pranksterScore: widget.pranksterScore,
          genuineScore: widget.genuineScore,
          userPath: widget.userPath,
          fakeCrisisCount: _fakeCrisisCounter,
          calculatedFine: calculatedFine,
          fineLevel: fineLevel,
        ),
      ),
    );
  }
}