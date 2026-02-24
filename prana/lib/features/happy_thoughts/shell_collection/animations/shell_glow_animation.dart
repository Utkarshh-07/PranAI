import 'package:flutter/material.dart';

class ShellGlowAnimation extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double intensity;
  final bool isPulsing;
  
  const ShellGlowAnimation({
    Key? key,
    required this.child,
    required this.glowColor,
    this.intensity = 1.0,
    this.isPulsing = true,
  }) : super(key: key);
  
  @override
  _ShellGlowAnimationState createState() => _ShellGlowAnimationState();
}

class _ShellGlowAnimationState extends State<ShellGlowAnimation> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: widget.isPulsing ? [
              BoxShadow(
                color: widget.glowColor.withOpacity(_glowAnimation.value * 0.5),
                blurRadius: 20 * widget.intensity,
                spreadRadius: 5 * widget.intensity,
              ),
              BoxShadow(
                color: widget.glowColor.withOpacity(_glowAnimation.value * 0.3),
                blurRadius: 40 * widget.intensity,
                spreadRadius: 10 * widget.intensity,
              ),
            ] : null,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}