// L'interfaccia che definisce TUTTI i ruoli di colore dell'app.
// Non contiene valori: è solo il "contratto" che sia LightColors sia
// DarkColors devono rispettare, ognuna con i propri valori concreti.
//
// Estende ThemeExtension<UnissColors>: è il meccanismo NATIVO di Flutter
// per registrare dati custom (non solo colori Material standard) dentro
// un ThemeData, e recuperarli più tardi con Theme.of(context).
//
// Nota sui nomi dei campi: li ho mantenuti IDENTICI a quelli del vecchio
// UnissColors, apposta. Così il refactor nei widget esistenti si riduce a
// "static → istanza" (es. UnissColors.black diventa colors.black), senza
// dover anche ripensare il significato di ogni nome.

import 'package:flutter/material.dart';

abstract class UnissColors extends ThemeExtension<UnissColors> {
  const UnissColors();

  // ================== Gradients ==================
  LinearGradient get backgroundGradient; // Login page
  LinearGradient get backgroundGradient2; // Users/pagine interne

  // ================== Messages ==================
  Color get errorMessage;
  Color get warningMessage;
  Color get succesMessage;

  // ================== Darker colors ==================
  Color get black; // Ruolo: testo/icona primaria
  Color get blackAlpha015; // Ruolo: ombra
  Color get blackAlpha01; // Ruolo: ombra più leggera
  Color get loginButton;
  Color get gray;
  Color get lightGray;

  // ================== Lighter colors ==================
  Color get transparent;
  Color get white; // Ruolo: pigmento puro, usato SOLO per overlay "vetro"
  Color get whiteAlpha03; // Ruolo: intensità dell'overlay vetro (variante 1)
  Color get whiteAlpha025; // Ruolo: intensità dell'overlay vetro (variante 2)
  Color get whiteAlpha035; // Ruolo: intensità dell'overlay vetro (variante 3)
  Color get whiteAlpha07; // Ruolo: intensità dell'overlay vetro (variante 4)
  Color get warmPaper; // Ruolo: superficie/card

  Color get deepPurple; // Ruolo: accento/selezione
  Color get deepPurpleAlpha01; // Ruolo: sfondo della selezione

  Color get profileBackground;

  // ThemeExtension richiede questi due metodi. Non ci servono davvero,
  // perché le due palette sono blocchi fissi e coerenti (non componiamo
  // colori "a metà" tra le due) — quindi restano implementazioni banali,
  // valide per entrambe le sottoclassi senza doverle ripetere.
  @override
  UnissColors copyWith() => this;

  @override
  UnissColors lerp(ThemeExtension<UnissColors>? other, double t) {
    // Niente dissolvenza granulare: il cambio tema è un interruttore
    // netto, non un'animazione di colori intermedi.
    if (other is! UnissColors) return this;
    return t < 0.5 ? this : other;
  }
}

// Scorciatoia per leggere la palette attiva da qualsiasi widget, senza
// scrivere ogni volta Theme.of(context).extension<UnissColors>()!.
//
// Uso: colors.black invece di UnissColors.black (statico).
extension UnissColorsContext on BuildContext {
  UnissColors get colors => Theme.of(this).extension<UnissColors>()!;
}
