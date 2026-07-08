import 'package:flutter/material.dart';
import 'color_palette.dart';

class LightColors extends UnissColors {
  const LightColors();

  // ================== Gradients ==================
  @override
  LinearGradient get backgroundGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(47, 162, 189, 0.4), // 0%
      Color.fromRGBO(255, 255, 255, 0.8), // 45%
      Color.fromRGBO(255, 255, 255, 0.9), // 55%
      Color.fromRGBO(165, 31, 246, 0.35), // 100%
    ],
    stops: [0.0, 0.45, 0.55, 1.0],
  );

  @override
  LinearGradient get backgroundGradient2 => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA8D8D8), // azzurro-teal, 0%
      Color(0xFFC8B4E8), // lavanda, 60%
      Color(0xFFE8B4D8), // rosa-lilla, 100%
    ],
    stops: [0.0, 0.6, 1.0],
  );

  // ================== Messages ==================
  @override
  Color get errorMessage => const Color(0xFFB3261E);
  @override
  Color get warningMessage => const Color(0xFFFFA500);
  @override
  Color get succesMessage => const Color(0xFF00FF00);
  // Nota: verde molto acceso, valore lasciato invariato per ora.
  // Se un giorno vuoi smorzarlo, questo è il posto dove farlo.

  // ================== Darker colors ==================
  @override
  Color get black => const Color(0xFF000000);
  @override
  Color get blackAlpha015 => const Color(0xFF000000).withValues(alpha: 0.15);
  @override
  Color get blackAlpha01 => const Color(0xFF000000).withValues(alpha: 0.1);
  @override
  Color get loginButton => const Color(0xFF1C1C1E);
  @override
  Color get gray => const Color(0xFF808080);
  @override
  Color get lightGray => const Color(0xFFC0C0C0);

  // ================== Lighter colors ==================
  @override
  Color get transparent => Colors.transparent;
  @override
  Color get white => const Color(0xFFFFFFFF);
  @override
  Color get whiteAlpha03 => const Color(0xFFFFFFFF).withValues(alpha: 0.3);
  @override
  Color get whiteAlpha025 => const Color(0xFFFFFFFF).withValues(alpha: 0.25);
  @override
  Color get whiteAlpha035 => const Color(0xFFFFFFFF).withValues(alpha: 0.35);
  @override
  Color get whiteAlpha07 => const Color(0xFFFFFFFF).withValues(alpha: 0.7);
  @override
  Color get warmPaper => const Color(0xFFFFFBF2);

  @override
  Color get deepPurple => Colors.deepPurple;
  @override
  Color get deepPurpleAlpha01 => Colors.deepPurple.withValues(alpha: 0.1);

  @override
  Color get profileBackground => Colors.teal;
}
