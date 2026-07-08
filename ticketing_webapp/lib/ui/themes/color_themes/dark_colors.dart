import 'package:flutter/material.dart';
import 'color_palette.dart';

class DarkColors extends UnissColors {
  const DarkColors();

  // ================== Gradients ==================
  // Non basta scurire gli alpha originali: quel gradiente ha centri quasi
  // bianchi (intrinsecamente chiari). Qui i centri diventano quasi neri,
  // mantenendo solo la tinta (teal/viola) agli angoli.
  @override
  LinearGradient get backgroundGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(47, 162, 189, 0.28),
      Color.fromRGBO(18, 18, 20, 0.9),
      Color.fromRGBO(14, 14, 16, 0.92),
      Color.fromRGBO(165, 31, 246, 0.25),
    ],
    stops: [0.0, 0.45, 0.55, 1.0],
  );

  @override
  LinearGradient get backgroundGradient2 => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF173B3B), // teal profondo
      Color(0xFF2A1F3D), // viola-navy profondo
      Color(0xFF3A1E33), // vinaccia profondo
    ],
    stops: [0.0, 0.6, 1.0],
  );

  // ================== Messages ==================
  @override
  Color get errorMessage => const Color.fromARGB(255, 195, 70, 63);
  @override
  Color get warningMessage => const Color(0xFFFFB74D);
  @override
  Color get succesMessage => const Color(0xFF81C784);

  // ================== Darker colors ==================
  // "black" qui è il ruolo "testo/icona primaria": in dark mode diventa
  // chiaro (leggermente caldo, per restare in tono con warmPaper scuro).
  @override
  Color get black => const Color(0xFFF2EFEA);

  // Le ombre nere restano nere: su un fondo scuro sono comunque poco
  // visibili, ma alziamo un po' l'alpha per dargli almeno una chance.
  // È un punto da rivedere seriamente quando affronterai l'elevazione
  // delle card in modo più strutturato (tipicamente: superfici più
  // chiare invece di ombre più scure).
  @override
  Color get blackAlpha015 => const Color(0xFF000000).withValues(alpha: 0.35);
  @override
  Color get blackAlpha01 => const Color(0xFF000000).withValues(alpha: 0.25);

  @override
  Color get loginButton => const Color(0xFFF5F0E8);
  // Alternativa se preferisci rinforzare il brand: Colors.deepPurple[200]
  // con testo scuro, invece di un pulsante chiaro neutro.

  @override
  Color get gray => const Color(0xFFA6A6A6);
  @override
  Color get lightGray => const Color(0xFFFFFFFF).withValues(alpha: 0.14);

  // ================== Lighter colors ==================
  // IMPORTANTE: "white" resta bianco puro anche qui. Non è un ruolo di
  // superficie (quello è warmPaper), è il pigmento usato per gli effetti
  // vetro/frosted — cambia solo l'intensità (vedi whiteAlphaXX sotto).
  @override
  Color get transparent => Colors.transparent;
  @override
  Color get white => const Color(0xFFFFFFFF);

  // Opacità più basse rispetto al chiaro: un bianco al 70% su uno sfondo
  // scuro sarebbe molto più accecante che sul pastello chiaro originale.
  @override
  Color get whiteAlpha03 => const Color(0xFFFFFFFF).withValues(alpha: 0.1);
  @override
  Color get whiteAlpha025 => const Color(0xFFFFFFFF).withValues(alpha: 0.08);
  @override
  Color get whiteAlpha035 => const Color(0xFFFFFFFF).withValues(alpha: 0.12);
  @override
  Color get whiteAlpha07 => const Color(0xFFFFFFFF).withValues(alpha: 0.16);

  @override
  Color get warmPaper => const Color(0xFF242019);

  @override
  Color get deepPurple => const Color(0xFFB39DDB); // deepPurple[200]
  @override
  Color get deepPurpleAlpha01 =>
      const Color(0xFFB39DDB).withValues(alpha: 0.16);

  @override
  Color get profileBackground => const Color(0xFF26A69A);
}
