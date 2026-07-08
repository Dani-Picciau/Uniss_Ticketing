import 'package:flutter/material.dart';

class FadeIn extends StatelessWidget {
  final Widget child; //Il widget che si vuole animare
  final Offset offset; // Definisce sia la direzione di partenza che la distanza

  // Parametri opzionali per personalizzare l'animazione se serve
  final Duration duration;
  final double initialOpacity;

  const FadeIn({
    super.key,
    required this.child,
    required this.offset,

    // Valori di default
    this.duration = const Duration(milliseconds: 250),
    this.initialOpacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutQuart,
      builder: (context, value, childWidget) {
        final currentOpacity =
            initialOpacity + (value * (1.0 - initialOpacity));

        return Transform.translate(
          offset: offset * (1 - value),
          child: Opacity(opacity: currentOpacity, child: childWidget),
        );
      },

      child:
          child, // Passiamo il widget originale qui per ottimizzare le performance
    );
  }
}
