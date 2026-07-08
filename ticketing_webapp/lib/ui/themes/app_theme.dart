// Questo è l'unico file che ha bisogno di conoscere sia color_themes sia
// text_themes: il suo compito è unirli in un ThemeData completo, pronto
// per essere passato a MaterialApp(theme:, darkTheme:).
//
// NOTA sul testo: se uniss_text_theme.dart espone già i propri stili in
// modo indipendente da Theme.of(context) (com'è probabile, visto il
// pattern con enum UnissTextType), non serve toccarlo qui — i colori sono
// l'unica cosa che varia col tema, per ora. Se un giorno vorrai rendere
// anche la tipografia theme-aware, questo è il punto dove agganciarla.

import 'package:flutter/material.dart';
import 'color_themes/color_palette.dart';
import 'color_themes/light_colors.dart';
import 'color_themes/dark_colors.dart';

abstract final class AppTheme {
  static const LightColors _lightColors = LightColors();
  static const DarkColors _darkColors = DarkColors();

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightColors.warmPaper,
    extensions: const <ThemeExtension<UnissColors>>[_lightColors],
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkColors.warmPaper,
    extensions: const <ThemeExtension<UnissColors>>[_darkColors],
  );
}
