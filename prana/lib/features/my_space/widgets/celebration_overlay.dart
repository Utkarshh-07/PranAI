// lib/features/my_space/widgets/celebration_overlay.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import '../../../widgets/ultimate_emoji.dart';

class CelebrationOverlay extends StatefulWidget {
  final VoidCallback onComplete;
  final String eventTitle;
  final String eventEmoji;
  final String eventCategory;
  final Color categoryColor;

  const CelebrationOverlay({
    super.key,
    required this.onComplete,
    required this.eventTitle,
    required this.eventEmoji,
    required this.eventCategory,
    required this.categoryColor,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Auto dismiss after animation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),

        // Confetti blast from bottom
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiBlastPainter(
                    progress: _controller.value,
                    categoryColor: widget.categoryColor,
                  ),
                );
              },
            ),
          ),
        ),

        // Celebration card showing what user chose
        Center(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        widget.categoryColor.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: widget.categoryColor.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.categoryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Big emoji
                      UltimateEmoji(
                        emoji: widget.eventEmoji,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      
                      // Event title
                      Text(
                        '"${widget.eventTitle}"',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3E50),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      
                      // Category
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.categoryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.eventCategory.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: widget.categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Time info
                      Text(
                        'Added to your calendar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // OK button
                      ElevatedButton(
                        onPressed: widget.onComplete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.categoryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('✨ OK ✨'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Confetti blast painter - colored based on category
class ConfettiBlastPainter extends CustomPainter {
  final double progress;
  final Color categoryColor;
  final List<ConfettiParticle> _particles = [];

  ConfettiBlastPainter({required this.progress, required this.categoryColor}) {
    if (_particles.isEmpty) {
      final random = Random();
      for (int i = 0; i < 60; i++) {
        _particles.add(ConfettiParticle(random));
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final paint = Paint();

    // Create color variations based on category color
    final colors = [
      categoryColor,
      categoryColor.withBlue((categoryColor.blue + 50).clamp(0, 255)),
      categoryColor.withRed((categoryColor.red + 50).clamp(0, 255)),
      categoryColor.withGreen((categoryColor.green + 50).clamp(0, 255)),
      Colors.white,
    ];

    for (int i = 0; i < _particles.length; i++) {
      final particle = _particles[i];

      // Start from bottom, move upward
      double x = particle.startX * size.width;
      double y = size.height - (particle.startY * size.height * progress * 3);

      // Add some horizontal drift
      x += particle.directionX * size.width * progress * 0.5;

      // Only draw if visible
      if (y >= 0 && y <= size.height) {
        final particleSize = 4.0 * (1 - progress * 0.3);
        final opacity = (1 - progress * 0.5).clamp(0.3, 1.0);

        paint.color = colors[i % colors.length].withOpacity(opacity);
        canvas.drawCircle(Offset(x, y), particleSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ConfettiParticle {
  final double startX;
  final double startY;
  final double directionX;

  ConfettiParticle(Random random)
      : startX = random.nextDouble(),
        startY = random.nextDouble(),
        directionX = (random.nextDouble() - 0.5) * 2.0;
}