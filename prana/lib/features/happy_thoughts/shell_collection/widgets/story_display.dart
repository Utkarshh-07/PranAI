import 'package:flutter/material.dart';
import 'package:prana/features/happy_thoughts/shell_collection/animations/story_reveal_animation.dart';

class StoryDisplay extends StatefulWidget {
  final String story;
  final String title;
  final Color themeColor;
  final bool showRevealAnimation;
  
  const StoryDisplay({
    Key? key,
    required this.story,
    required this.title,
    this.themeColor = Colors.blue,
    this.showRevealAnimation = true,
  }) : super(key: key);
  
  @override
  _StoryDisplayState createState() => _StoryDisplayState();
}

class _StoryDisplayState extends State<StoryDisplay> {
  bool _animationComplete = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.themeColor.withOpacity(0.1),
            widget.themeColor.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.themeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(Icons.auto_stories, color: widget.themeColor, size: 20),
              SizedBox(width: 10),
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.themeColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          // Story content
          Expanded(
            child: SingleChildScrollView(
              child: widget.showRevealAnimation && !_animationComplete
                  ? StoryRevealAnimation(
                      text: widget.story,
                      textStyle: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Georgia',
                      ),
                      onComplete: () {
                        setState(() {
                          _animationComplete = true;
                        });
                      },
                    )
                  : Text(
                      widget.story,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Georgia',
                      ),
                    ),
            ),
          ),
          
          // Interactive elements (when animation complete)
          if (_animationComplete)
            Column(
              children: [
                SizedBox(height: 20),
                Divider(color: widget.themeColor.withOpacity(0.3)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Listen button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.themeColor.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Text-to-speech
                      },
                      icon: Icon(Icons.volume_up, size: 18),
                      label: Text('Listen'),
                    ),
                    
                    // Save button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.themeColor.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Save to favorites
                      },
                      icon: Icon(Icons.bookmark, size: 18),
                      label: Text('Save'),
                    ),
                    
                    // Share button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Share story
                      },
                      icon: Icon(Icons.share, size: 18),
                      label: Text('Share'),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}