import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// TextTheme principale dell'app
// Poppins w700   → titoli e intestazioni
// PlusJakartaSans w200 → corpo e testi secondari
// ---------------------------------------------------------------------------
const unissTextTheme = TextTheme(
  // Titolo principale — Poppins Bold
  headlineLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
  ),

  // Titolo secondario — Poppins Bold
  headlineMedium: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
  ),

  // Sottotitolo — Poppins Bold
  titleLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
  ),

  // Corpo principale — Plus Jakarta Sans ExtraLight
  bodyLarge: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w200,
    fontFamily: 'PlusJakartaSans',
  ),

  // Corpo secondario — Plus Jakarta Sans ExtraLight
  bodyMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  ),

  bodySmall: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  ),

  // Label — Plus Jakarta Sans ExtraLight
  labelLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w200,
    fontFamily: 'PlusJakartaSans',
  ),

  labelMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
  ),

  // Label piccola — Plus Jakarta Sans ExtraLight
  labelSmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w200,
    fontFamily: 'PlusJakartaSans',
  ),
);

// ---------------------------------------------------------------------------
// Enum dei tipi di testo usati nell'app
// ---------------------------------------------------------------------------
enum UnissTextType {
  headingLarge, // 32px Poppins Bold
  headingMedium, // 24px Poppins Bold
  titleLarge, // 20px Poppins Bold, // 14px Poppins Bold
  bodyLarge, // 24px Plus Jakarta Sans ExtraLight
  bodyMedium, // 20px Plus Jakarta Sans ExtraLight
  bodySmall, // 16px Poppins Bold
  labelLarge, // 14px Plus Jakarta Sans ExtraLight
  labelMedium, // 14px Poppins Bold
  labelSmall, // 12px Plus Jakarta Sans ExtraLight
}

// ---------------------------------------------------------------------------
// Getter — uso: getAppTextStyle(UnissTextType.headingLarge)
// ---------------------------------------------------------------------------
TextStyle? getAppTextStyle(UnissTextType type) {
  switch (type) {
    case UnissTextType.headingLarge:
      return unissTextTheme.headlineLarge;
    case UnissTextType.headingMedium:
      return unissTextTheme.headlineMedium;
    case UnissTextType.titleLarge:
      return unissTextTheme.titleLarge;
    case UnissTextType.bodyLarge:
      return unissTextTheme.bodyLarge;
    case UnissTextType.bodyMedium:
      return unissTextTheme.bodyMedium;
    case UnissTextType.bodySmall:
      return unissTextTheme.bodySmall;
    case UnissTextType.labelLarge:
      return unissTextTheme.labelLarge;
    case UnissTextType.labelMedium:
      return unissTextTheme.labelMedium;
    case UnissTextType.labelSmall:
      return unissTextTheme.labelSmall;
  }
}
