// lib/widgets/floating_cloud.dart
import 'package:flutter/material.dart';
import '../screens/chat/chat_list_screen.dart';

class FloatingCloud extends StatefulWidget {
  final int unreadCount;
  final bool hasUrgent;

  const FloatingCloud({
    super.key,
    required this.unreadCount,
    required this.hasUrgent,
  });

  @override
  State<FloatingCloud> createState() => _FloatingCloudState();
}

class _FloatingCloudState extends State<FloatingCloud>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: GestureDetector(
            onTap: () {
              // Navigate to chat
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatListScreen(), // ← REMOVED const
                ),
              );
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      '💭',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                  if (widget.unreadCount > 0)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: widget.hasUrgent ? Colors.red : const Color(0xFF7C9AFF),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 22,
                          minHeight: 22,
                        ),
                        child: Center(
                          child: Text(
                            widget.unreadCount > 9 ? '9+' : '${widget.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}