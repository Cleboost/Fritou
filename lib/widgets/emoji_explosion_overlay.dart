import 'dart:math' as math;
import 'package:flutter/material.dart';

class EmojiParticle {
  double x;
  double y;
  double vx;
  double vy;
  double rotation;
  double rotationSpeed;
  final double scale;
  final String emoji;

  EmojiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.rotation,
    required this.rotationSpeed,
    required this.scale,
    required this.emoji,
  });

  void update(double gravity) {
    x += vx;
    y += vy;
    vy += gravity;
    rotation += rotationSpeed;
  }
}

class EmojiExplosionOverlay extends StatefulWidget {
  final int triggerCount;
  final Widget child;

  const EmojiExplosionOverlay({
    super.key,
    required this.triggerCount,
    required this.child,
  });

  @override
  State<EmojiExplosionOverlay> createState() => _EmojiExplosionOverlayState();
}

class _EmojiExplosionOverlayState extends State<EmojiExplosionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<EmojiParticle> _particles = [];
  final math.Random _random = math.Random();
  double _screenWidth = 0.0;
  double _screenHeight = 0.0;

  final List<String> _emojis = ['🍟', '🍗', '🥨', '🔥', '✨', '😋', '🥔', '💥'];

  @override
  void initState() {
    super.initState();
    // 1.5 seconds animation duration
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _animationController.addListener(() {
      setState(() {
        for (final particle in _particles) {
          // Gravity pull down
          particle.update(0.5);
        }
        // Remove particles that fall off the bottom of the screen
        _particles.removeWhere((p) => p.y > _screenHeight + 100);
      });
    });
  }

  @override
  void didUpdateWidget(covariant EmojiExplosionOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.triggerCount > oldWidget.triggerCount) {
      _spawnExplosion();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _spawnExplosion() {
    if (_screenWidth == 0.0 || _screenHeight == 0.0) return;

    _particles.clear();

    // Spawn 15-20 particles from the left side (bottom-left area)
    final int leftCount = 18 + _random.nextInt(6);
    for (int i = 0; i < leftCount; i++) {
      _particles.add(
        EmojiParticle(
          x: -20.0, // Just off-screen left
          y: _screenHeight * 0.75,
          // Shoot up and right
          vx: 4.0 + _random.nextDouble() * 8.0,
          vy: -14.0 - _random.nextDouble() * 10.0,
          rotation: _random.nextDouble() * math.pi * 2,
          rotationSpeed: -0.1 + _random.nextDouble() * 0.2,
          scale: 0.7 + _random.nextDouble() * 0.6,
          emoji: _emojis[_random.nextInt(_emojis.length)],
        ),
      );
    }

    // Spawn 15-20 particles from the right side (bottom-right area)
    final int rightCount = 18 + _random.nextInt(6);
    for (int i = 0; i < rightCount; i++) {
      _particles.add(
        EmojiParticle(
          x: _screenWidth + 20.0, // Just off-screen right
          y: _screenHeight * 0.75,
          // Shoot up and left
          vx: -4.0 - _random.nextDouble() * 8.0,
          vy: -14.0 - _random.nextDouble() * 10.0,
          rotation: _random.nextDouble() * math.pi * 2,
          rotationSpeed: -0.1 + _random.nextDouble() * 0.2,
          scale: 0.7 + _random.nextDouble() * 0.6,
          emoji: _emojis[_random.nextInt(_emojis.length)],
        ),
      );
    }

    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _screenWidth = constraints.maxWidth;
        _screenHeight = constraints.maxHeight;

        return Stack(
          children: [
            widget.child,
            if (_particles.isNotEmpty)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: EmojiExplosionPainter(
                      particles: _particles,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class EmojiExplosionPainter extends CustomPainter {
  final List<EmojiParticle> particles;

  EmojiExplosionPainter({
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: particle.emoji,
          style: TextStyle(
            fontSize: 24.0 * particle.scale,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      // Translate to particle coordinates
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.rotation);
      
      // Paint centered
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant EmojiExplosionPainter oldDelegate) {
    return true; // Particles update position every frame
  }
}
