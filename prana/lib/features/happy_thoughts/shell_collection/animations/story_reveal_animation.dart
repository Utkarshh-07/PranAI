import 'package:flutter/material.dart';

class StoryRevealAnimation extends StatefulWidget {
  final String text;
  final int speed; // milliseconds per character
  final TextStyle textStyle;
  final Function() onComplete;
  
  const StoryRevealAnimation({
    Key? key,
    required this.text,
    this.speed = 50,
    required this.textStyle,
    required this.onComplete,
  }) : super(key: key);
  
  @override
  _StoryRevealAnimationState createState() => _StoryRevealAnimationState();
}

class _StoryRevealAnimationState extends State<StoryRevealAnimation> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<int> _textAnimation;
  String _displayText = "";
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * widget.speed),
      vsync: this,
    );
    
    _textAnimation = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(_controller);
    
    _controller.forward();
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    
    _controller.addListener(() {
      setState(() {
        _displayText = widget.text.substring(0, _textAnimation.value);
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Faded background text (for preview)
        Opacity(
          opacity: 0.1,
          child: Text(
            widget.text,
            style: widget.textStyle,
          ),
        ),
        
        // Revealing text
        Text(
          _displayText,
          style: widget.textStyle.copyWith(
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.blue.withOpacity(0.5),
              ),
            ],
          ),
        ),
        
        // Blinking cursor
        if (_controller.status != AnimationStatus.completed)
          Positioned(
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: (_controller.value * 10).floor() % 2 == 0 ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Container(
                width: 2,
                height: widget.textStyle.fontSize! * 1.5,
                color: Colors.blue,
              ),
            ),
          ),
      ],
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}