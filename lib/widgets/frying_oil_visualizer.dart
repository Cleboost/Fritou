import 'dart:math' as math;
import 'package:flutter/material.dart';

class FryingOilVisualizer extends StatefulWidget {
  final int bathCount;
  final Color oilColor;

  const FryingOilVisualizer({
    super.key,
    required this.bathCount,
    required this.oilColor,
  });

  @override
  State<FryingOilVisualizer> createState() => _FryingOilVisualizerState();
}

class _FryingOilVisualizerState extends State<FryingOilVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isToxic = widget.bathCount >= 10;
    final bool isWarning = widget.bathCount >= 8 && widget.bathCount < 10;

    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1E1C1F),
        border: Border.all(
          color: isToxic
              ? Colors.redAccent
              : isWarning
                  ? const Color(0xFFFF7043)
                  : const Color(0xFFFFB74D).withOpacity(0.5),
          width: 6,
        ),
        boxShadow: [
          BoxShadow(
            color: (isToxic
                    ? Colors.redAccent
                    : isWarning
                        ? const Color(0xFFFF7043)
                        : const Color(0xFFFFB74D))
                .withOpacity(0.2),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          children: [
            // Oil background matching usage status
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                color: widget.oilColor,
              ),
            ),
            // Animated Bubbles
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _bubbleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: OilBubblesPainter(
                      progress: _bubbleController.value,
                      intensity: widget.bathCount,
                      isToxic: isToxic,
                    ),
                  );
                },
              ),
            ),
            // Center circular container with Fry details
            Center(
              child: Container(
                width: 146,
                height: 146,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0F0E0F).withOpacity(0.85),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isToxic ? Icons.warning_rounded : Icons.local_fire_department,
                      size: isToxic ? 36 : 30,
                      color: isToxic ? Colors.redAccent : const Color(0xFFFFB74D),
                    ),
                    const SizedBox(height: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        final scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
                          ),
                        );
                        final slideAnimation = Tween<Offset>(
                          begin: const Offset(0.0, 0.4),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
                          ),
                        );
                        return ScaleTransition(
                          scale: scaleAnimation,
                          child: SlideTransition(
                            position: slideAnimation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        '${widget.bathCount} / 10',
                        key: ValueKey<int>(widget.bathCount),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isToxic
                              ? Colors.redAccent
                              : isWarning
                                  ? const Color(0xFFFF7043)
                                  : Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      widget.bathCount > 1 ? 'bains' : 'bain',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter to draw bubbles in the oil
class OilBubblesPainter extends CustomPainter {
  final double progress;
  final int intensity;
  final bool isToxic;

  OilBubblesPainter({
    required this.progress,
    required this.intensity,
    required this.isToxic,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // The number of bubbles increases with intensity
    final int bubbleCount = 8 + (intensity * 2);
    final math.Random random = math.Random(42); // Seeded random for consistent layout

    for (int i = 0; i < bubbleCount; i++) {
      // Calculate animated vertical position
      final double speed = 0.5 + random.nextDouble() * 1.5;
      final double offset = (progress * speed) % 1.0;
      final double y = size.height * (1.0 - offset);

      // Horizontal position
      final double x = size.width * random.nextDouble();

      // Bubble size
      final double radius = 3.0 + random.nextDouble() * (isToxic ? 12.0 : 7.0);

      // Bubble color
      if (isToxic) {
        paint.color = Colors.greenAccent.withOpacity(0.25 + (random.nextDouble() * 0.25));
      } else {
        paint.color = Colors.white.withOpacity(0.15 + (random.nextDouble() * 0.2));
      }

      // Draw bubble outline & center highlight
      canvas.drawCircle(Offset(x, y), radius, paint);

      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          Offset(x - radius * 0.3, y - radius * 0.3), radius * 0.25, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant OilBubblesPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.intensity != intensity ||
        oldDelegate.isToxic != isToxic;
  }
}
