import 'package:flutter/material.dart';
import 'package:prana/features/happy_thoughts/shell_collection/widgets/story_display.dart';
import 'package:prana/features/happy_thoughts/shell_collection/widgets/ocean_voice_player.dart';
import 'package:prana/features/happy_thoughts/shell_collection/models/shell_model.dart';

class ShellStoryReveal extends StatefulWidget {
  final Shell shell;
  final String story;
  
  const ShellStoryReveal({
    Key? key,
    required this.shell,
    required this.story,
  }) : super(key: key);
  
  @override
  _ShellStoryRevealState createState() => _ShellStoryRevealState();
}

class _ShellStoryRevealState extends State<ShellStoryReveal> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _shellAnimation;
  late Animation<double> _textAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    _shellAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: Curves.elasticOut),
    ));
    
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 1.0, curve: Curves.easeIn),
    ));
    
    _controller.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2342),
      body: Stack(
        children: [
          // Animated background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.shell.glowColor.withOpacity(0.1),
                    Colors.transparent,
                    widget.shell.glowColor.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Animated shell
                  Center(
                    child: AnimatedBuilder(
                      animation: _shellAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _shellAnimation.value,
                          child: Transform.rotate(
                            angle: _shellAnimation.value * 6.28, // Full rotation
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: widget.shell.gradientColors.isNotEmpty
                                      ? widget.shell.gradientColors
                                      : [widget.shell.glowColor, widget.shell.glowColor.withOpacity(0.5)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.shell.glowColor.withOpacity(0.5),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  widget.shell.emoji,
                                  style: TextStyle(fontSize: 70),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Shell title
                  Center(
                    child: AnimatedBuilder(
                      animation: _textAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, 20 - (_textAnimation.value * 20)),
                            child: Column(
                              children: [
                                Text(
                                  widget.shell.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Pacifico',
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                        color: widget.shell.glowColor.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${widget.shell.rarityString} • ${widget.shell.categoryString}',
                                  style: TextStyle(
                                    color: widget.shell.glowColor,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Story display
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _textAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textAnimation.value,
                          child: child,
                        );
                      },
                      child: StoryDisplay(
                        story: widget.story,
                        title: 'Ocean\'s Message',
                        themeColor: widget.shell.glowColor,
                        showRevealAnimation: true,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Ocean voice player
                  AnimatedBuilder(
                    animation: _textAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textAnimation.value,
                        child: child,
                      );
                    },
                    child: OceanVoicePlayer(
                      text: widget.story,
                      themeColor: widget.shell.glowColor,
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            // TODO: Save to favorites
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Story saved to favorites!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: Icon(Icons.bookmark_border, size: 20),
                          label: Text('Save'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.shell.glowColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            _shareStory();
                          },
                          icon: Icon(Icons.share, size: 20),
                          label: Text('Share Wisdom'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _shareStory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1B3B6F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Share Ocean Wisdom',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share this beautiful message from the ocean:',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.shell.glowColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: widget.shell.glowColor.withOpacity(0.3)),
              ),
              child: Text(
                '"${_extractQuote(widget.story)}"',
                style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.shell.glowColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Story shared!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Share', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  String _extractQuote(String story) {
    final sentences = story.split('.');
    for (var sentence in sentences) {
      if (sentence.contains('Remember:') || 
          sentence.contains('The ocean') || 
          sentence.contains('waves')) {
        return sentence.trim();
      }
    }
    return "The ocean remembers your journey. 🌊";
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}