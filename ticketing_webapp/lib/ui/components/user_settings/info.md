# Come funzionano OverlayMenu e SwitchableIcon

Questo documento spiega in dettaglio due file più "tecnici" del pannello impostazioni: `overlay_menu.dart` (l'orchestratore di bottone + overlay) e `switchable_icon.dart` (l'animazione sole/luna).

---

## 1. `overlay_menu.dart`

### L'idea generale

`OverlayMenu` è un widget che **si comporta come un interruttore**: mostra un bottone (le freccette), e quando viene premuto fa comparire (o sparire) un pannello fluttuante, sganciato dal normale flusso del layout. È l'unico responsabile di tutto questo comportamento — chi lo usa (`CommonAppbar`) gli passa solo un'icona e non deve sapere nient'altro.

### I tre "pezzi di stato" che possiede

```dart
final GlobalKey _triggerKey = GlobalKey();
final GlobalKey _panelKey = GlobalKey();
OverlayEntry? _overlayEntry;
```

- **`_overlayEntry`**: è la variabile più importante. Finché è `null`, il pannello non esiste da nessuna parte. Quando non è `null`, il pannello è inserito nell'Overlay e visibile. `_isOpen` è solo una scorciatoia di lettura:
  ```dart
  bool get _isOpen => _overlayEntry != null;
  ```
- **`_triggerKey`** e **`_panelKey`**: due `GlobalKey`, cioè due "etichette" uniche in tutta l'app, agganciate rispettivamente al bottone che apre il pannello e al pannello stesso. Servono per una cosa sola: **ritrovare la posizione e le dimensioni reali** di quei due widget sullo schermo, in un momento successivo (quando arriva un click, per capire se è caduto dentro o fuori da uno di questi due). Un indice o un riferimento normale non basterebbe: una `GlobalKey` è pensata apposta per essere "cercata" da un punto qualsiasi dell'albero dei widget, anche lontano da dove è stata creata.

### Il toggle: `_toggle`, `_open`, `_close`

```dart
void _toggle() {
  if (_isOpen) {
    _close();
  } else {
    _open();
  }
}
```

Niente di complicato: guarda lo stato attuale e fa l'azione opposta. Questo è il cuore del comportamento "un click apre, un click richiude", di cui parlavamo prima.

### `_open()`: cosa viene effettivamente inserito nell'Overlay

```dart
_overlayEntry = OverlayEntry(
  builder: (context) => Stack(
    children: [
      Positioned.fill(
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: _handleOutsideTap,
        ),
      ),
      Positioned(
        top: 50,
        right: 65,
        child: Material(
          color: Colors.transparent,
          child: FadeIn(
            offset: const Offset(-50, 0),
            child: Container(
              width: 180,
              key: _panelKey,
              ...
              child: SettingsMenu(),
            ),
          ),
        ),
      ),
    ],
  ),
);

Overlay.of(context).insert(_overlayEntry!);
```

Un `OverlayEntry` non è un widget "già disegnato": è un **contenitore che sa come costruirsi**, tramite quel `builder`. Il `builder` viene richiamato quando l'entry viene inserita, e poi Flutter lo ricostruisce autonomamente solo se qualcosa al suo interno lo richiede (ad esempio, se un widget interno chiama un proprio `setState` — come fa `SettingsMenu`, che gestisce da solo `_isDarkMode`). L'entry esterna (`OverlayMenu`) non deve fare nulla per tenere aggiornato ciò che c'è dentro.

Dentro il builder trovi uno `Stack` con due elementi, nell'ordine in cui li vedi (l'ordine conta: in uno `Stack` chi viene dopo si disegna sopra a chi viene prima):

1. **Il "muro" invisibile** (`Positioned.fill` + `Listener`): l'abbiamo già discusso — copre tutto lo schermo, osserva i tocchi (`onPointerDown`) ma grazie a `HitTestBehavior.translucent` non li blocca, lasciandoli proseguire verso i widget sotto (compresi quelli fuori dall'Overlay stesso, come una voce del side menu nella pagina).
2. **Il pannello vero**, posizionato con `Positioned(top: 50, right: 65)` — coordinate fisse, non ancora agganciate dinamicamente alla posizione reale del bottone (per farlo servirebbero `CompositedTransformTarget`/`Follower`, di cui parlavamo prima, e che qui non sono ancora stati introdotti).

Dentro il pannello:

- **`Material(color: Colors.transparent)`**: necessario perché dentro c'è `SettingsMenu`, che a sua volta contiene `InkWell` (nei suoi `menu_item`). `InkWell` **richiede** un antenato `Material` per poter disegnare l'effetto ripple — senza, l'app darebbe un errore a runtime. Il colore è trasparente perché non vogliamo che `Material` aggiunga un suo sfondo: il colore reale del pannello lo dà il `Container` più interno.
- **`FadeIn(offset: Offset(-50, 0))`**: è un componente di animazione (dello stesso tipo di `FadeInDown`, che avevi già usato altrove) che fa comparire il suo `child` con una dissolvenza in ingresso, partendo spostato di 50 pixel verso sinistra (offset X negativo) e scivolando verso la sua posizione finale. Serve solo per l'entrata "morbida" del pannello, non per interazioni.
- **`Container(key: _panelKey, ...)`**: qui vive la `_panelKey` — è agganciata esattamente al contenitore che rappresenta i confini visivi reali del pannello, quello che vuoi escludere dall'auto-chiusura.

Infine, `Overlay.of(context).insert(_overlayEntry!)` inserisce fisicamente questo intero sottoalbero nel livello Overlay dell'app.

### `_isInsideBounds`: come si scopre se un punto è "dentro" un widget

```dart
bool _isInsideBounds(GlobalKey key, Offset globalPosition) {
  final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return false;

  final localPosition = renderBox.globalToLocal(globalPosition);
  final bounds = Offset.zero & renderBox.size;
  return bounds.contains(localPosition);
}
```

Passo per passo:

1. **`key.currentContext`**: dato che sia il bottone sia il pannello hanno una `GlobalKey`, possiamo risalire al loro `BuildContext` da un punto qualsiasi dell'app — anche da dentro il builder dell'`OverlayEntry`, che è "lontano" da dove quei widget sono stati dichiarati.
2. **`.findRenderObject()`**: da quel contesto, otteniamo l'oggetto che sa *davvero* dove si trova quel widget sullo schermo e quanto è grande — il `RenderObject`. Il cast a `RenderBox` è sicuro perché quasi tutti i widget visuali "normali" (container, testo, icone...) producono un `RenderBox`.
3. **`globalToLocal(globalPosition)`**: converte il punto del click (che arriva in coordinate "assolute", riferite a tutto lo schermo) in coordinate "relative" a quel singolo widget — cioè: "il click è arrivato a (x, y) dentro *questo specifico rettangolo*", con (0,0) nell'angolo in alto a sinistra del widget.
4. **`Offset.zero & renderBox.size`**: l'operatore `&` tra un `Offset` e una `Size` costruisce un `Rect` — qui, un rettangolo che va da (0,0) fino alla larghezza/altezza reali del widget. È il modo compatto di dire "il rettangolo del widget stesso, in coordinate locali".
5. **`bounds.contains(localPosition)`**: controllo geometrico banale, vero se il punto cade dentro quel rettangolo.

### `_handleOutsideTap`: la decisione finale

```dart
void _handleOutsideTap(PointerDownEvent event) {
  final isInsidePanel = _isInsideBounds(_panelKey, event.position);
  final isOnTrigger = _isInsideBounds(_triggerKey, event.position);

  if (!isInsidePanel && !isOnTrigger) {
    _close();
  }
}
```

Tre casi possibili per ogni click intercettato dal "muro":

- **Dentro il pannello**: non facciamo nulla qui — i controlli interni del pannello (i singoli `SettingsMenuItem`) gestiscono da soli il proprio `onTap`.
- **Sopra il bottone che ha aperto tutto**: non facciamo nulla nemmeno qui. Perché? Perché il bottone ha il suo **proprio** `onTap` (collegato a `_toggle`), che si occuperà lui di chiudere. Se chiudessimo *anche* da qui, il bottone si troverebbe a "toggleare" un overlay già chiuso, riaprendolo per errore — è esattamente il bug che avevi notato.
- **Ovunque altro**: chiudiamo. Punto.

### `dispose()`: la rete di sicurezza

```dart
@override
void dispose() {
  _overlayEntry?.remove();
  super.dispose();
}
```

Se `OverlayMenu` viene rimosso dall'albero dei widget (es. l'utente cambia schermata) mentre il pannello è ancora aperto, senza questa riga il pannello resterebbe "appeso" nell'Overlay — invisibile ma ancora tecnicamente presente, con riferimenti a un `context` ormai morto. Questa riga garantisce la pulizia, indipendentemente da come l'utente chiude o abbandona la schermata.

### `build()`: il bottone visibile

```dart
@override
Widget build(BuildContext context) {
  return SettingsButton(
    key: _triggerKey,
    iconPath: widget.iconPath,
    onTap: _toggle,
  );
}
```

Il `build()` di `OverlayMenu` non disegna il pannello — disegna **solo il bottone**. Il pannello vive nell'Overlay, un livello completamente separato dal normale albero della UI, quindi non compare qui. Nota che `_triggerKey` è assegnata proprio a questo `SettingsButton`: è il modo in cui, più tardi, `_isInsideBounds(_triggerKey, ...)` riesce a sapere "dove si trova esattamente questo bottone sullo schermo".

### Il flusso completo, in sintesi

```
Click sulle frecce
   │
   ▼
SettingsButton → onTap → _toggle()
   │
   ├─ se chiuso → _open() → crea OverlayEntry → Overlay.of(context).insert(...)
   │                          il pannello appare, con FadeIn
   │
   └─ se aperto → _close() → overlayEntry.remove() → il pannello sparisce

Click altrove (mentre il pannello è aperto)
   │
   ▼
Listener (translucent) intercetta → _handleOutsideTap
   │
   ├─ è dentro il pannello?  → non fare nulla
   ├─ è sul bottone?         → non fare nulla (ci pensa il suo onTap)
   └─ è altrove?             → _close()
```

---

## 2. `switchable_icon.dart`

### L'obiettivo

Mostrare due icone diverse (sole/luna) e passare dall'una all'altra con un'animazione di "salita/discesa" combinata a una dissolvenza — non un semplice taglio netto da un'immagine all'altra.

### Il widget centrale: `AnimatedSwitcher`

```dart
return AnimatedSwitcher(
  duration: duration,
  switchInCurve: Curves.easeOutCubic,
  switchOutCurve: Curves.easeInCubic,
  transitionBuilder: (child, animation) { ... },
  child: SvgPicture.asset(
    currentPath,
    key: ValueKey(currentPath),
    ...
  ),
);
```

`AnimatedSwitcher` è un widget che osserva il suo `child` nel tempo: quando rileva che il "figlio" è cambiato, non lo sostituisce di netto — anima l'uscita del vecchio e l'entrata del nuovo, **contemporaneamente**, usando la logica che gli passi in `transitionBuilder`.

### Il dettaglio più importante, e più facile da sbagliare: `ValueKey(currentPath)`

Questa è la vera chiave di volta del file, quella che probabilmente ti confonde di più. La domanda è: **come fa `AnimatedSwitcher` a sapere che il figlio "è cambiato"?**

Flutter, per decidere se un widget è "lo stesso di prima" (e quindi va solo aggiornato) oppure "un widget nuovo" (e quindi il vecchio va smontato e il nuovo montato da zero), guarda **due sole cose**: il tipo del widget (`runtimeType`) e la sua `key`. **Non** guarda in profondità tutti i parametri del costruttore.

Questo significa che due `SvgPicture.asset(...)` — uno con il percorso del sole, uno con quello della luna — sarebbero, agli occhi di Flutter, "lo stesso identico widget" (stesso tipo, nessuna key), anche se il parametro `currentPath` cambia internamente. `AnimatedSwitcher`, in quel caso, **non farebbe partire nessuna animazione**: aggiornerebbe silenziosamente l'icona esistente, sole e luna si scambierebbero di colpo, senza dissolvenza né movimento.

```dart
key: ValueKey(currentPath), // fondamentale per triggerare lo switch
```

Assegnando una `ValueKey` che dipende dal percorso dell'icona, stai dicendo esplicitamente a Flutter: "quando il percorso cambia, considera questo un widget **diverso**, non un aggiornamento dello stesso". Solo così `AnimatedSwitcher` si accorge del cambiamento e attiva la transizione.

### Il `transitionBuilder`: come si muovono le icone

```dart
transitionBuilder: (child, animation) {
  final slide = Tween<Offset>(
    begin: const Offset(0, 0.6),
    end: Offset.zero,
  ).animate(animation);

  return ClipRect(
    child: SlideTransition(
      position: slide,
      child: FadeTransition(opacity: animation, child: child),
    ),
  );
},
```

Punto concettuale chiave: questa funzione **non viene usata solo per l'icona che entra** — `AnimatedSwitcher` la applica anche all'icona che esce, ma le fa scorrere l'animazione **al contrario** (da 1 verso 0 invece che da 0 verso 1). Per questo un'unica definizione ti dà, gratis, sia l'effetto di entrata sia quello di uscita, simmetrici.

- **`Tween<Offset>(begin: Offset(0, 0.6), end: Offset.zero)`**: definisce uno spostamento verticale. In Flutter, le coordinate Y positive vanno verso il basso — quindi `Offset(0, 0.6)` significa "spostato in basso del 60% della propria altezza". L'icona in entrata parte da lì e sale fino a `Offset.zero` (posizione naturale): è il tuo effetto "sorge". L'icona in uscita fa lo stesso percorso **al contrario** (parte da `Offset.zero` e scivola verso il basso mentre sparisce): è il tuo effetto "tramonta".
- **`FadeTransition(opacity: animation, ...)`**: sovrappone una dissolvenza sincronizzata allo stesso movimento — l'icona non solo si sposta, ma appare/scompare gradualmente.
- **`ClipRect`**: durante lo scorrimento verso il basso, l'icona potrebbe temporaneamente "debordare" oltre lo spazio che le è stato assegnato. `ClipRect` taglia qualunque parte ecceda quello spazio, evitando che si veda un'icona sporgere fuori dai margini previsti durante l'animazione.

### Le curve: perché due diverse

```dart
switchInCurve: Curves.easeOutCubic,  // per chi entra
switchOutCurve: Curves.easeInCubic,  // per chi esce
```

Sono scelte deliberatamente diverse e complementari: `easeOutCubic` fa partire il movimento veloce e lo fa rallentare verso la fine (l'icona "atterra" morbidamente in posizione) — buono per un'entrata. `easeInCubic` fa l'opposto: parte lento e accelera (l'icona "si allontana" con slancio crescente) — buono per un'uscita. È una combinazione comune nelle linee guida di design per dare un senso di movimento naturale quando due elementi si scambiano di posto.

### Da dove arriva `showFirst`

```dart
final currentPath = showFirst ? firstIconPath : secondIconPath;
```

`SwitchableIcon` di per sé non sa nulla di "chiaro/scuro" — riceve solo un booleano (`showFirst`) e due percorsi, e decide quale mostrare. Nel tuo caso, `showFirst: !widget.isDarkMode` dentro `ThemeToggleMenuItem` collega quel booleano generico al concetto specifico di tema — `SwitchableIcon` resta un componente riutilizzabile, senza sapere nulla di temi o dark mode.

### Una nota per il futuro (non urgente ora)

`_isDarkMode` oggi vive come stato locale dentro `SettingsMenu` (`StatefulWidget` + `setState`), esattamente come abbiamo detto essere corretto per un toggle isolato, senza altri widget che devono saperlo. Se un domani il tema scuro dovesse davvero cambiare l'aspetto di **tutta** l'app (non solo di questo pannello), quel booleano andrebbe promosso a uno stato condiviso più in alto nell'albero — un Cubit/provider dedicato al tema, letto da `MaterialApp`. Per ora, così com'è, va benissimo: è lo stesso principio "stato locale finché resta locale" di cui abbiamo già parlato.
