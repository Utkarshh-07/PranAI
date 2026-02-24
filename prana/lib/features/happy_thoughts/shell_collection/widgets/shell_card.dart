import 'package:flutter/material.dart';
import 'package:prana/features/happy_thoughts/shell_collection/models/shell_model.dart';
import 'package:prana/features/happy_thoughts/shell_collection/animations/shell_glow_animation.dart';

class ShellCard extends StatelessWidget {
  final Shell shell;
  final VoidCallback? onTap;
  
  const ShellCard({
    Key? key,
    required this.shell,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        _showShellDetails(context);
      },
      child: ShellGlowAnimation(
        glowColor: shell.glowColor,
        intensity: _getIntensityForRarity(shell.rarity),
        isPulsing: shell.specialEffect == 'pulse',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: shell.gradientColors.isNotEmpty
                ? LinearGradient(
                    colors: shell.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      shell.glowColor.withOpacity(0.3),
                      shell.glowColor.withOpacity(0.1),
                    ],
                  ),
            border: Border.all(
              color: shell.glowColor.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              // Shell emoji/icon
              Center(
                child: Text(
                  shell.emoji,
                  style: TextStyle(fontSize: 40),
                ),
              ),
              
              // Rarity indicator top right
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _getRaritySymbol(shell.rarity),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              // Shell name bottom center
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    shell.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  double _getIntensityForRarity(ShellRarity rarity) {
    switch (rarity) {
      case ShellRarity.COMMON: return 0.5;
      case ShellRarity.RARE: return 1.0;
      case ShellRarity.EPIC: return 1.5;
      case ShellRarity.LEGENDARY: return 2.0;
      case ShellRarity.MYTHICAL: return 2.5;
    }
  }
  
  String _getRaritySymbol(ShellRarity rarity) {
    switch (rarity) {
      case ShellRarity.COMMON: return '🌟';
      case ShellRarity.RARE: return '✨';
      case ShellRarity.EPIC: return '💎';
      case ShellRarity.LEGENDARY: return '👑';
      case ShellRarity.MYTHICAL: return '🌈';
    }
  }
  
  void _showShellDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A2342),
              Color(0xFF1B3B6F),
              Color(0xFF2A9D8F),
            ],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Shell display
              ShellGlowAnimation(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: shell.gradientColors.isNotEmpty
                          ? shell.gradientColors
                          : [shell.glowColor, shell.glowColor.withOpacity(0.5)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      shell.emoji,
                      style: TextStyle(fontSize: 70),
                    ),
                  ),
                ),
                glowColor: shell.glowColor,
                intensity: _getIntensityForRarity(shell.rarity) * 1.5,
              ),
              
              SizedBox(height: 20),
              
              // Shell name and rarity
              Text(
                shell.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                ),
              ),
              
              Text(
                '${_rarityToString(shell.rarity)} • ${_categoryToString(shell.category)}',
                style: TextStyle(
                  color: shell.glowColor,
                  fontSize: 14,
                ),
              ),
              
              SizedBox(height: 20),
              
              // Shell description
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'The Ocean\'s Whisper:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              shell.description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Discovery info
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white70, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Found in: ${shell.discoveredIn}',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Discovered: ${_formatDate(shell.discoveredAt)}',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                    label: Text('Close', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: shell.glowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Share shell story
                    },
                    icon: Icon(Icons.share, color: Colors.white),
                    label: Text('Share Wisdom', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _rarityToString(ShellRarity rarity) {
    return rarity.toString().split('.').last;
  }
  
  String _categoryToString(ShellCategory category) {
    return category.toString().split('.').last;
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}