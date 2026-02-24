import 'package:flutter/material.dart';
import '../terms_screen.dart';
import 'level3_danger_zone.dart'; // ADD THIS IMPORT

class Level2WinterfellScreen extends StatefulWidget {
  final int pranksterScore;
  final int genuineScore;
  final String userPath; // 'exploring' or 'testing'
  
  const Level2WinterfellScreen({
    super.key,
    required this.pranksterScore,
    required this.genuineScore,
    required this.userPath,
  });

  @override
  State<Level2WinterfellScreen> createState() => _Level2WinterfellScreenState();
}

class _Level2WinterfellScreenState extends State<Level2WinterfellScreen> {
  bool _showConsequences = false;
  bool _hasRetreated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // WINTERFELL BACKGROUND
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0A1F35),
                    Color(0xFF1A365D),
                    Color(0xFF2A4B7A),
                  ],
                ),
              ),
            ),
          ),
          
          // SNOW ANIMATION
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                child: Stack(
                  children: List.generate(
                    20,
                    (index) => Positioned(
                      left: (index * 50) % MediaQuery.of(context).size.width,
                      top: (DateTime.now().millisecondsSinceEpoch / 20 + index * 30) %
                          MediaQuery.of(context).size.height,
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
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
                    const SizedBox(height: 20),
                    
                    // WINTERFELL BANNER
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF94A3B8),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '❄️ WINTERFELL\'S WARNING ❄️',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '"The Night King watches all tests of this app"',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Stark Score: ${widget.genuineScore}',
                                style: const TextStyle(
                                  color: Colors.cyan,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                'White Walker Score: ${widget.pranksterScore}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // MAIN WARNING
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '⚠️ WINTER IS COMING ⚠️',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Our system detected unusual activity. Testing mental health apps for fun has consequences:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          
                          // CONSEQUENCES
                          if (_showConsequences) ...[
                            _buildConsequenceItem('🏫 School Notification', 'Your principal will be informed'),
                            _buildConsequenceItem('👮 Police FIR', 'IPC 420 - 7 years jail + ₹10,000 fine'),
                            _buildConsequenceItem('💰 Pocket Money Loss', '₹5,000 = 5 months of your pocket money'),
                            _buildConsequenceItem('📱 Parent Call', 'Parents receive automated call about misuse'),
                            const SizedBox(height: 20),
                          ],
                          
                          // SHOW/HIDE CONSEQUENCES BUTTON
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showConsequences = !_showConsequences;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.withOpacity(0.3),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              _showConsequences ? 'Hide Consequences' : 'Show Consequences',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // PATH OPTIONS
                    if (widget.userPath == 'exploring') ...[
                      _buildOptionCard(
                        title: '🚶‍♂️ RETREAT TO SAFE PATH',
                        subtitle: 'Admit this was a mistake, continue gently',
                        color: Colors.green,
                        onTap: _retreatToSafePath,
                      ),
                      const SizedBox(height: 15),
                    ],
                    
                    _buildOptionCard(
                      title: widget.userPath == 'testing' 
                          ? '😈 CONTINUE TO DANGER ZONE'
                          : '🧊 PROCEED WITH WARNINGS',
                      subtitle: widget.userPath == 'testing'
                          ? 'Face the full consequences'
                          : 'Continue with limited warnings',
                      color: widget.userPath == 'testing' 
                          ? Colors.red 
                          : Colors.orange,
                      onTap: _proceedToNextLevel,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // BACK BUTTON
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '🏰 Return to Level 1',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    
                    // WINTERFELL FOOTER
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Text(
                        '"When the snows fall and the white winds blow,\n'
                        'the lone wolf dies but the pack survives."',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
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
  
  Widget _buildConsequenceItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.red, size: 20),
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
  
  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: Icon(
                    color == Colors.green ? Icons.arrow_back : Icons.arrow_forward,
                    color: Colors.white,
                    size: 24,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _retreatToSafePath() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TermsScreen(
          isPotentialPrankster: false,
          pranksterScore: widget.pranksterScore,
          genuineScore: widget.genuineScore,
        ),
      ),
    );
  }
  
  void _proceedToNextLevel() {
    // FIXED NAVIGATION: Go to Level 3
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Level3DangerZoneScreen(
          pranksterScore: widget.pranksterScore,
          genuineScore: widget.genuineScore,
          userPath: widget.userPath,
        ),
      ),
    );
  }
}