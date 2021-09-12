import 'dart:math' as math;

import 'package:flutter/material.dart';

class RainPainter extends CustomPainter {
  final List<Drop> drops;
  final AnimationController listenable;

  RainPainter(this.drops, this.listenable) : super(repaint: listenable);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlueAccent.shade200
      ..style = PaintingStyle.fill;

    final dropsMap = {};

    for (final drop in drops) {
      drop.increment();
      if (drop.y > size.height) {
        drop.reset();
      }
      final key = drop.blur.toString();
      if (dropsMap[key] == null) {
        dropsMap[key] = [drop];
      } else {
        dropsMap[key].add(drop);
      }
    }

    for (final elements in dropsMap.values) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, elements.first.blur);
      final path = Path();
      for (final drop in elements) {
        path.moveTo(drop.x - 2, drop.y);
        path.lineTo(drop.x, drop.y - drop.dropSize);
        path.lineTo(drop.x + 2, drop.y);
        path.addArc(
          Rect.fromCircle(center: Offset(drop.x, drop.y), radius: 1),
          0,
          math.pi,
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(RainPainter oldDelegate) {
    return oldDelegate.listenable.value != listenable.value;
  }
}

class Drop {
  final double x;
  final double _originalY;
  final double _originalSpeed;
  final int dropSize;
  final double blur;
  double _currentY;
  double _currentSpeed;

  Drop({
    required this.x,
    required double y,
    required double speed,
    required this.dropSize,
    required this.blur,
  })  : _originalY = y,
        _currentY = y,
        _originalSpeed = speed,
        _currentSpeed = speed;

  void increment() {
    _currentSpeed += 0.05;
    _currentY += _currentSpeed;
  }

  void reset() {
    _currentY = _originalY;
    _currentSpeed = _originalSpeed;
  }

  double get y => _currentY;
  double get speed => _currentSpeed;
}
