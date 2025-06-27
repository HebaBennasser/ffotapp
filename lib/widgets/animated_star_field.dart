
// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class AnimatedStarField extends StatefulWidget {
  const AnimatedStarField({super.key});

  @override
  State<AnimatedStarField> createState() => _AnimatedStarFieldState();
}

class _AnimatedStarFieldState extends State<AnimatedStarField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    for (int i = 0; i < 200; i++) {
      _stars.add(Star(
        offset: Offset(
          Random().nextDouble() * 1.5,
          Random().nextDouble(),
        ),
        size: Random().nextDouble() * 2 + 1,
        speed: Random().nextDouble() * 0.2 + 0.05,
        alpha: Random().nextInt(155) + 100,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarPainter(stars: _stars, animationValue: _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Star {
  final Offset offset;
  final double size;
  final double speed;
  final int alpha;

  Star({
    required this.offset,
    required this.size,
    required this.speed,
    required this.alpha,
  });
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final star in stars) {
      final x = (star.offset.dx + animationValue * star.speed) % 1.5;
      final y = star.offset.dy;
      final alpha = star.alpha;

      paint.color = Colors.white.withAlpha(alpha);
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}