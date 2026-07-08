# Come funzionano insieme SideMenu, SlidingMenu e Cubit

Questo documento spiega come collaborano i file che gestiscono il menù in alto (`SlidingMenu`), il menù laterale (`SideMenu`) e il contenuto a destra, nella schermata `AdminManagerScreen`.

L'idea di fondo da tenere sempre a mente: **il Cubit è l'unica fonte di verità**, tutto il resto (config, widget) reagisce a quella verità senza mai decidere nulla per conto proprio.

---

## 1. `side_menu.dart`

### 1.1 `_SideMenuItem` — un singolo elemento del menù

Definisce la struttura di un singolo item del menù laterale. È uno `StatefulWidget` perché ogni item deve cambiare colore al passaggio del mouse (hover) — un dettaglio puramente visivo e locale, che non ha nulla a che fare con la logica applicativa. Per questo lo stato non serve nel Cubit: vive solo qui.

Attributi e costruttore:

```dart
class _SideMenuItem extends StatefulWidget {
  final String title;        // titolo dell'item
  final String iconPath;     // icona dell'item
  final int index;           // indice che identifica il singolo item
  final int currentIndex;    // indice dell'elemento attualmente attivo
  final VoidCallback onTap;  // funzione da eseguire al click
  ...
}
```

Due variabili chiave nello stato interno:

- **`isSelected`**: `true` quando `index == currentIndex`, cioè quando questo item è quello attivo secondo lo stato globale.
- **`_isHovered`**: `true` mentre il mouse è sopra l'item. È uno stato *locale* del widget (`setState`), non globale — per questo non serve passare da nessun Cubit.

```dart
final isSelected = widget.index == widget.currentIndex;
final isActive = isSelected || _isHovered;
```

Sia che l'item sia selezionato, sia che ci sia sopra il mouse, l'item si "attiva" (colore viola, sfondo colorato). Questa è pura logica di presentazione.

Il click è gestito con `GestureDetector`:

```dart
child: GestureDetector(
  onTap: widget.onTap,
  ...
)
```

Punto importante: `widget.onTap` è **la callback ricevuta dall'esterno**, non una funzione scritta qui dentro. `_SideMenuItem` non sa e non deve sapere cosa succede al click — si limita a eseguire quello che gli viene detto di eseguire. Infine, il widget viene disegnato restituendo un `InfoRow` con i parametri dell'item (titolo, icona, colore).

### 1.2 `SideMenu` — l'intera colonna del menù

`SideMenu` genera l'intera colonna, creando un `_SideMenuItem` per ogni voce con un ciclo `for`:

```dart
class SideMenu extends StatelessWidget {
  final List<SidebarItemData> items;
  final int selectedIndex;
  final Function(int) onMenuChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _SideMenuItem(
            title: items[i].title,
            iconPath: items[i].iconPath,
            index: i,
            currentIndex: selectedIndex,
            onTap: () => onMenuChanged(i),
          ),
          if (i != items.length - 1) const SizedBox(height: 5),
        ],
      ],
    );
  }
}
```

Tre attributi:

- **`items`**: la lista di titoli e icone da mostrare (una `List<SidebarItemData>`, vedi sezione 2).
- **`selectedIndex`**: un intero che dice quale item è selezionato *in questo momento*. Viene passato a ogni `_SideMenuItem` come `currentIndex`, così ognuno può calcolare da solo se `isSelected` è vero.
- **`onMenuChanged`**: una funzione (`Function(int)`) che `SideMenu` **riceve da fuori** e si limita a richiamare quando un item viene cliccato, passando l'indice cliccato — vedi `onTap: () => onMenuChanged(i)`.

Questo è il punto concettualmente più importante del file: **`SideMenu` non decide mai cosa fare al click**. Non seleziona nulla, non aggiorna nessuno stato interno. Dice solo "hanno cliccato l'indice i" e lascia che sia chi lo usa (`AdminManagerScreen`) a decidere il da farsi. È un widget "dumb" (nel senso buono): sa disegnare e notificare, non ragiona.

Piccola rifinitura: lo spazio `SizedBox(height: 5)` viene aggiunto solo `if (i != items.length - 1)`, cioè tra un item e l'altro ma non dopo l'ultimo, per non lasciare uno spazio vuoto in fondo alla lista.

---

## 2. `sidebar_item_data.dart` — il "cosa" separato dal "come"

```dart
class SidebarItemData {
  final String title;
  final String iconPath;

  const SidebarItemData({required this.title, required this.iconPath});
}
```

Solo un contenitore di dati: titolo + icona, nessuna logica, nessun widget. Ogni item del side menu ha bisogno di un titolo e un'icona, quindi ogni menù laterale ha bisogno di una *lista* di questi dati.

Perché questa classe esiste separata, invece di scrivere direttamente la lista dentro `side_menu.dart`? Perché quella lista deve **cambiare in base al tab selezionato**, e quel "cambiare in base al tab" è compito di un altro file — la config, vista subito sotto. `SideMenu` non deve sapere nulla di tab: riceve semplicemente la lista già pronta.

---

## 3. `admin_manager_menu_config.dart` — il catalogo statico

Risponde alla domanda: *"per il tab X, quali voci deve mostrare il side menu?"*

```dart
class AdminManagerMenuConfig {
  // La chiave è l'indice del tab in SlidingMenu:
  // 0 = Scadenze, 1 = Alla firma, 2 = Procedure aperte, 3 = Nuova procedura
  static const Map<int, List<SidebarItemData>> _sidebarItemsByTab = {
    0: [
      SidebarItemData(title: 'Tutte le scadenze', iconPath: MediaConstants.all),
      SidebarItemData(title: 'Borse di studio', iconPath: MediaConstants.schoolarship),
      // ...
    ],
    1: [ /* voci per "Alla firma" */ ],
    2: [ /* voci per "Procedure aperte" */ ],
    3: [ /* voci per "Nuova procedura" */ ],
  };

  static List<SidebarItemData> getSidebarItems(int tabIndex) {
    return _sidebarItemsByTab[tabIndex] ?? const [];
  }
}
```

È una semplice mappa: chiave = indice del tab, valore = lista di voci per quel tab. `getSidebarItems(tabIndex)` è un modo pulito per leggere la mappa senza esporla direttamente, gestendo anche il caso in cui il tab non esista (ritorna lista vuota invece di far crashare l'app).

Punto chiave: questo file è **statico** — `const`, calcolato una volta sola, non cambia mai durante l'esecuzione dell'app. Per questo non vive né nello stato né nel Cubit: non è un dato che cambia nel tempo, è configurazione fissa, come il menù di un ristorante scritto una volta per tutte. Quando si vuole aggiungere o modificare le voci di un tab, questo è l'unico file da toccare.

---

## 4. `admin_manager_state.dart` e `admin_manager_cubit.dart` — la verità che cambia

Qui vive tutto quello che **cambia davvero mentre l'utente usa l'app**:

```dart
class AdminManagerState {
  final int currentTabIndex;      // Menù in alto
  final int currentSidebarIndex;  // Menù laterale

  const AdminManagerState({
    this.currentTabIndex = 0,
    this.currentSidebarIndex = 0,
  });

  AdminManagerState copyWith({int? currentTabIndex, int? currentSidebarIndex}) {
    return AdminManagerState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      currentSidebarIndex: currentSidebarIndex ?? this.currentSidebarIndex,
    );
  }
}
```

Due soli numeri: quale tab è attivo, quale voce del side menu è attiva. Il Cubit espone due metodi, uno per ciascuna informazione:

```dart
class AdminManagerCubit extends Cubit<AdminManagerState> {
  AdminManagerCubit() : super(const AdminManagerState());

  void changeTab(int index) {
    emit(state.copyWith(currentTabIndex: index, currentSidebarIndex: 0));
  }

  void changeSidebarTab(int index) {
    emit(state.copyWith(currentSidebarIndex: index));
  }
}
```

Dettaglio importante in `changeTab`: quando cambi tab, `currentSidebarIndex` viene **resettato a 0**, non lasciato invariato. Perché? Perché le voci del side menu cambiano completamente da un tab all'altro (in base alla config vista sopra). Se non si resettasse l'indice, "l'indice 2" selezionato nel tab vecchio (es. "Procedure su MePa") resterebbe selezionato anche nel tab nuovo, dove "l'indice 2" potrebbe essere tutt'altra voce. Il reset garantisce coerenza tra selezione e contenuto mostrato.

`changeSidebarTab`, invece, cambia solo la voce laterale, lasciando il tab dov'è.

---

## 5. `admin_manager_content.dart` — cosa mostrare a destra

```dart
class AdminManagerContent extends StatelessWidget {
  final int tabIndex;
  final int sidebarIndex;

  @override
  Widget build(BuildContext context) {
    switch (tabIndex) {
      case 0: return _scadenzeContent(sidebarIndex);
      case 1: return _allaFirmaContent(sidebarIndex);
      case 2: return _procedureAperteContent(sidebarIndex);
      case 3: return _nuovaProceduraContent(sidebarIndex);
      default: return const SizedBox.shrink();
    }
  }

  Widget _scadenzeContent(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0: return const _Placeholder(text: 'Tutte le scadenze');
      case 1: return const _Placeholder(text: 'Scadenze borse di studio');
      default: return const SizedBox.shrink();
    }
  }
  // ... stessa logica per gli altri tab
}
```

Riceve i due indici (`tabIndex`, `sidebarIndex`) già pronti dallo `state` e decide cosa disegnare, tramite due `switch` annidati (prima sul tab, poi sulla voce del side menu). Non è collegato al Cubit in alcun modo diretto: riceve solo dati "già pronti", esattamente come `SideMenu` riceve `selectedIndex`.

**Perché un widget dedicato, invece di stati diversi nel Cubit?** Perché il Cubit deve rispondere solo a "qual è la verità in questo momento" (due numeri), non a "cosa disegno sullo schermo". Se il contenuto vivesse nello stato — ad esempio come `Widget` dentro lo `state`, o come una classe di stato diversa per ogni possibile voce — si perderebbero due cose: la possibilità di confrontare facilmente stati vecchio/nuovo (i `Widget` non si confrontano bene con `==`), e la semplicità di testare il Cubit senza tirare in ballo Flutter. Con la separazione attuale, `AdminManagerMenuConfig` e `AdminManagerContent` possono cambiare liberamente (nuove voci, nuovo layout) senza mai toccare il Cubit.

---

## 6. `admin_manager_screen.dart` — dove tutto si incontra

Questo file **collega** i pezzi visti finora, senza contenere logica propria. Non decide nulla: prende lo stato attuale, lo passa ai widget giusti, e collega i loro eventi al Cubit.

```dart
BlocProvider(
  create: (context) => AdminManagerCubit(),
  child: ...
    BlocBuilder<AdminManagerCubit, AdminManagerState>(
      builder: (context, state) {
        final sidebarItems = AdminManagerMenuConfig.getSidebarItems(
          state.currentTabIndex,
        );

        return Column(
          children: [
            SlidingMenu(
              selectedIndex: state.currentTabIndex,
              onMenuChanged: (index) =>
                  context.read<AdminManagerCubit>().changeTab(index),
            ),
            SideMenu(
              items: sidebarItems,
              selectedIndex: state.currentSidebarIndex,
              onMenuChanged: (index) =>
                  context.read<AdminManagerCubit>().changeSidebarTab(index),
            ),
            AdminManagerContent(
              tabIndex: state.currentTabIndex,
              sidebarIndex: state.currentSidebarIndex,
            ),
          ],
        );
      },
    ),
)
```

### Il flusso completo, passo passo

Quando l'utente clicca una voce del side menu:

1. `SideMenu` chiama `onMenuChanged(index)` (il "notifico e basta" di cui parlavamo).
2. Nello screen, quella callback è collegata così: `onMenuChanged: (index) => context.read<AdminManagerCubit>().changeSidebarTab(index)` — lo screen traduce "hanno cliccato l'indice X" in "Cubit, aggiorna lo stato".
3. Il Cubit emette un nuovo stato (`currentSidebarIndex` aggiornato).
4. Il `BlocBuilder` che avvolge tutto il layout si accorge del nuovo stato e **ricostruisce** i widget.
5. Durante la ricostruzione, `AdminManagerMenuConfig.getSidebarItems(state.currentTabIndex)` viene richiamato — nel caso del side menu la lista non cambia (stesso tab), ma `SideMenu` riceve il nuovo `selectedIndex` e ridisegna evidenziando la voce giusta. `AdminManagerContent` riceve il nuovo `sidebarIndex` e mostra il contenuto corrispondente.

Lo stesso flusso, identico nella forma, avviene con `SlidingMenu` in alto: click → `changeTab` → stato aggiornato → rebuild → stavolta **cambia anche** la lista passata a `SideMenu`, perché `getSidebarItems` viene richiamato con un `tabIndex` diverso, e `currentSidebarIndex` è stato resettato a 0.

---

## 7. `sliding_menu.dart` — stessa logica, un caso più semplice

`SlidingMenu` segue esattamente lo stesso schema di `SideMenu`: riceve `selectedIndex` e `onMenuChanged` da fuori, non decide nulla da solo, si limita a disegnare e notificare.

```dart
class SlidingMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onMenuChanged;
  ...
}
```

La differenza principale è che le sue 4 voci ("Scadenze", "Alla firma", "Procedure aperte", "Nuova procedura") sono **fisse**, scritte direttamente nel file:

```dart
final menuItems = [
  _buildMenuItem(0, 'Scadenze', MediaConstants.scadenze),
  _buildMenuItem(1, 'Alla firma', MediaConstants.signature),
  _buildMenuItem(2, 'Procedure aperte', MediaConstants.openProcedure),
  _buildMenuItem(3, 'Nuova procedura', MediaConstants.newProcedure),
];
```

Non serve una config esterna come `AdminManagerMenuConfig`, perché queste 4 voci non cambiano mai in base a nient'altro (a differenza delle voci del side menu, che dipendono dal tab). Se un giorno servisse rendere dinamiche anche queste voci, il pattern da applicare sarebbe lo stesso: creare un modello dati (magari riusando `SidebarItemData`) e una lista esterna, invece di scriverle a mano nel widget.

Un dettaglio in più rispetto a `SideMenu`: la parte animata. `_getAlignment` calcola dove posizionare l'indicatore scorrevole (il rettangolo bianco semi-trasparente) in base a `selectedIndex`, e cambia calcolo se il layout è orizzontale (desktop) o verticale (mobile):

```dart
Alignment _getAlignment(bool isDesktop) {
  final double position = -1.0 + (selectedIndex * (2 / 3));
  return isDesktop ? Alignment(position, 0.0) : Alignment(0.0, position);
}
```

Questo indicatore si muove con `AnimatedAlign`, che anima automaticamente la transizione ogni volta che `selectedIndex` cambia — nessuna gestione manuale dell'animazione, Flutter la calcola da solo confrontando la posizione vecchia e quella nuova.

---

## Il quadro d'insieme

```
click su una voce
        │
        ▼
Widget (SideMenu / SlidingMenu)
   "hanno cliccato l'indice X"  →  onMenuChanged(X)
        │
        ▼
AdminManagerScreen
   traduce il click in una chiamata al Cubit
        │
        ▼
AdminManagerCubit
   unica fonte di verità: aggiorna lo stato (emit)
        │
        ▼
AdminManagerState
   nuovo currentTabIndex / currentSidebarIndex
        │
        ▼
BlocBuilder si accorge del cambiamento → rebuild
        │
        ├──► AdminManagerMenuConfig.getSidebarItems(tabIndex)
        │        traduce l'indice del tab in una lista di voci
        │
        ├──► SideMenu / SlidingMenu
        │        ridisegnano evidenziando la voce corretta
        │
        └──► AdminManagerContent
                 traduce (tabIndex, sidebarIndex) nel contenuto da mostrare
```

Riassumendo in una frase: **il Cubit è l'unica fonte di verità** (due numeri), la **config è il catalogo statico** che traduce un numero in una lista di voci, e i **widget sono tutti "dumb"** — ricevono dati già pronti e li disegnano, senza mai decidere nulla da soli. Ogni click torna indietro fino al Cubit, che aggiorna la verità, e da lì tutto il resto si ridisegna a cascata.
