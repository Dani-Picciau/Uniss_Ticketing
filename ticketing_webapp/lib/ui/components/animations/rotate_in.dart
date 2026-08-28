import 'dart:math' as math;

import 'package:flutter/material.dart';

class RotateIn extends StatelessWidget {
  final Widget child;
  final double spins; // 1.0 = 360 gradi
  final Duration duration;

  const RotateIn({
    super.key,
    required this.child,
    this.spins = 2.0, // Di default farà due giri completi
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    // Calcoliamo i radianti totali in base ai giri scelti
    final initialAngle =
        -spins * 2 * math.pi; // '-' per invertire il senso della rotazione

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutQuart,
      builder: (context, value, childWidget) {
        // Calcolo dell'angolo: parte dai giri totali e si azzera
        final currentAngle = initialAngle * (1 - value);

        // Applica solo ed esclusivamente la rotazione
        return Transform.rotate(angle: currentAngle, child: childWidget);
      },
      child: child,
    );
  }
}
