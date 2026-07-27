# Come funzionano insieme SideMenu, SlidingMenu, Cubit e i dati del menù laterale

Questo documento spiega come collaborano i file che gestiscono il menù in alto (`SlidingMenu`), il menù laterale ad albero (`SideMenu`), il contenuto a destra e il Cubit, nella schermata `AdminManagerScreen`.

L'idea di fondo da tenere sempre a mente: **il Cubit è l'unica fonte di verità**, tutto il resto (config, widget) reagisce a quella verità senza mai decidere nulla per conto proprio.

> Nota sull'ordine: rispetto alla versione precedente di questo documento, ho riordinato le sezioni per seguire il flusso naturale dei dati — prima il *dato* (`SidebarItemData`), poi la *configurazione* che lo produce, poi il *widget* che lo disegna, poi il *contenuto* che reagisce alla selezione. La sezione su `sliding_menu.dart` resta identica a prima, in fondo.

---

## 1. `sidebar_item_data.dart` — il dato, ora ad albero

```dart
class SidebarItemData {
  final int id;
  final String title;
  final String iconPath;
  final List<SidebarItemData>? subItems;

  const SidebarItemData({
    required this.id,
    required this.title,
    required this.iconPath,
    this.subItems,
  });
}
```

Rispetto a prima, due cambiamenti:

- **`id` è un `int` esplicito**, non più un indice di posizione dedotto dalla lista (`i` in un ciclo `for`). Serve perché con un albero l'indice di posizione non basta più a identificare una voce in modo univoco — una voce annidata non ha una "posizione" sensata nella lista principale.
- **`subItems`** è una `List<SidebarItemData>?` — la stessa classe, dentro se stessa. Questo è ciò che rende la struttura un **albero**: ogni voce può avere altre voci "figlie", che a loro volta potrebbero (in teoria) averne altre. `subItems` è nullable e di default `null`: una voce senza figli si comporta come una foglia semplice, esattamente come prima.

---

## 2. `admin_manager_menu_config.dart` — il catalogo statico, ora ramificato

Stessa funzione di prima — risponde a *"per il tab X, quali voci mostro?"* — ma ora ogni voce può portarsi dietro un intero sotto-albero:

```dart
2: [
  SidebarItemData(id: 0, title: 'Tutte le procedure', iconPath: MediaConstants.all),
  SidebarItemData(id: 1, title: 'Borse di studio', iconPath: MediaConstants.schoolarship),
  SidebarItemData(
    id: 2,
    title: 'Procedure su MePa',
    iconPath: MediaConstants.arrowDown,
    subItems: [
      SidebarItemData(id: 21, title: 'Beni di consumo', iconPath: MediaConstants.consumerGoods),
      SidebarItemData(id: 22, title: 'Attrezzature', iconPath: MediaConstants.equipment),
    ],
  ),
  // ...
],
```

La convenzione che hai usato per gli id è leggibile: le voci di primo livello usano numeri piccoli (0, 1, 2, 3...), le sotto-voci "ereditano" la cifra del genitore come decina (21, 22 sotto il genitore 2; 31, 32 sotto il genitore 3). È solo una convenzione tua, però — **Dart non la impone né la verifica**: nulla vieta di sbagliare un numero, ed è esattamente quello che è successo in un punto del file.

---

## 3. `side_menu.dart` — riga per riga

### 3.1 `SideMenu` — il punto di ingresso

```dart
class SideMenu extends StatelessWidget {
  final List<SidebarItemData> items;
  final int selectedIndex;
  final Function(int) onMenuChanged;

  const SideMenu({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onMenuChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: _SideMenuItem(
            item: item,
            currentIndex: selectedIndex,
            onMenuChanged: onMenuChanged,
          ),
        );
      }).toList(),
    );
  }
}
```

- **`items.map((item) { ... }).toList()`**: per ogni voce di primo livello, genera un `Padding` con `bottom: 5.0` che avvolge un `_SideMenuItem`. Nota una piccola differenza rispetto a prima: prima lo spazio veniva omesso dopo l'ultimo elemento (`if (i != items.length - 1)`); ora ogni voce, **compresa l'ultima**, riceve lo stesso padding sotto. Effetto pratico: un filo di spazio vuoto in più in fondo alla lista rispetto a prima — cosmetico, non un problema funzionale.
- **`_SideMenuItem(item: item, currentIndex: selectedIndex, onMenuChanged: onMenuChanged)`**: nota che qui passiamo **l'intero oggetto `item`**, non più i singoli campi (`title`, `iconPath`, `index`) separati come nella versione precedente. Questo è il cambiamento chiave che rende possibile la ricorsione: passando l'oggetto intero, `_SideMenuItem` ha accesso anche a `item.subItems`, e può quindi decidere da solo se e come disegnare dei figli.

### 3.2 `_SideMenuItem` — il cuore ricorsivo

```dart
class _SideMenuItem extends StatefulWidget {
  final SidebarItemData item;
  final int currentIndex;
  final Function(int) onMenuChanged;
  ...
}

class _SideMenuItemState extends State<_SideMenuItem> {
  bool _isHovered = false;
  bool _isExpanded = false;
```

Due booleani locali, entrambi gestiti con `setState`, entrambi puramente visivi — nessuno dei due va nel Cubit:

- **`_isHovered`**: come prima, per l'evidenziazione al passaggio del mouse.
- **`_isExpanded`**: **nuovo**. Dice se la tendina dei sotto-elementi di *questa specifica voce* è aperta o chiusa. È locale per lo stesso motivo per cui lo è `_isHovered`: aprire/chiudere una tendina non cambia "quale contenuto è mostrato a destra" — è pura interazione visiva, isolata a questo widget. Nessun altro pezzo dell'app ha bisogno di sapere se questa tendina è aperta.

```dart
final hasSubItems = widget.item.subItems != null && widget.item.subItems!.isNotEmpty;
final isSelected = widget.item.id == widget.currentIndex;
final isActive = isSelected || _isHovered;

final contentColor = isActive ? context.colors.deepPurple : context.colors.black;
final backgroundColor = isActive ? context.colors.deepPurpleAlpha01 : context.colors.transparent;
```

- **`hasSubItems`**: controllo di sicurezza in due parti — non solo "il campo non è null", ma anche "e non è una lista vuota". Una voce con `subItems: []` (lista vuota esplicita) si comporta come una foglia, non come un genitore senza figli visibili.
- **`isSelected`**: confronta `item.id` con `currentIndex` — qui **`currentIndex` è, di fatto, l'id della voce attualmente selezionata**, non una posizione. Il nome del parametro è un residuo della vecchia versione basata su indici; concettualmente andrebbe letto come "id selezionato", non "indice selezionato" (stessa osservazione vale per `currentSidebarIndex` nello stato del Cubit, vedi sezione 5).
- **`contentColor`/`backgroundColor`**: passano ora da `context.colors` (tema chiaro/scuro), coerente con tutto il resto dell'app dopo il refactor dei colori.

```dart
return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    MouseRegion( ... riga cliccabile ... ),
    AnimatedSize( ... tendina dei figli ... ),
  ],
);
```

Ogni `_SideMenuItem`, indipendentemente dal fatto che abbia figli o no, restituisce **sempre la stessa struttura**: una `Column` con due figli fissi — la riga principale, e uno spazio (eventualmente vuoto) sotto per i sotto-elementi. Vediamo i due pezzi separatamente.

#### La riga principale (cliccabile)

```dart
MouseRegion(
  onEnter: (_) => setState(() => _isHovered = true),
  onExit: (_) => setState(() => _isHovered = false),
  cursor: SystemMouseCursors.click,
  child: GestureDetector(
    onTap: () {
      if (hasSubItems) {
        setState(() => _isExpanded = !_isExpanded);
      } else {
        widget.onMenuChanged(widget.item.id);
      }
    },
    child: AnimatedContainer(
      ...
      child: InfoRow(
        text: widget.item.title,
        iconPath: widget.item.iconPath,
        textType: UnissTextType.bodySmall,
        color: contentColor,
        iconTurns: (hasSubItems && _isExpanded) ? 0.5 : 0.0,
      ),
    ),
  ),
),
```

Il punto concettualmente più importante di tutto il file è dentro `onTap`: **il click fa due cose diverse, a seconda che la voce abbia figli o no.**

- **Se `hasSubItems` è vero**: `setState(() => _isExpanded = !_isExpanded)`. Il click **non notifica nessuno all'esterno** — non chiama `onMenuChanged`, non tocca il Cubit. Apre/chiude solo la tendina, localmente. Coerente con quanto detto sopra: espandere un genitore non decide alcun contenuto da mostrare.
- **Se `hasSubItems` è falso** (una foglia, sia essa una voce di primo livello senza figli o una voce dentro `subItems`): `widget.onMenuChanged(widget.item.id)`. Qui sì, notifica verso l'esterno — esattamente come nella versione precedente, solo che ora manda un `id` invece di una posizione.

`iconTurns: (hasSubItems && _isExpanded) ? 0.5 : 0.0` — passato a `InfoRow`, che (nella sua versione attuale) usa questo valore per ruotare un'icona di freccia, tipicamente tramite un `AnimatedRotation` interno: `0.5` corrisponde a mezzo giro (180°, freccia che punta verso l'alto invece che verso il basso), `0.0` a nessuna rotazione. È lo stesso meccanismo di rotazione discusso a suo tempo per il toggle del tema chiaro/scuro.

#### La tendina dei sotto-elementi

```dart
AnimatedSize(
  duration: const Duration(milliseconds: 250),
  curve: Curves.easeInOut,
  alignment: Alignment.topCenter,
  child: (hasSubItems && _isExpanded)
      ? Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.item.subItems!.map((subItem) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: _SideMenuItem(
                  item: subItem,
                  currentIndex: widget.currentIndex,
                  onMenuChanged: widget.onMenuChanged,
                ),
              );
            }).toList(),
          ),
        )
      : const SizedBox(width: double.infinity, height: 0),
),
```

Questa è la **ricorsione vera e propria**: dentro la tendina, per ogni `subItem`, viene creato un **altro `_SideMenuItem`** — lo stesso identico widget che stiamo descrivendo, richiamato su se stesso. Ogni sotto-voce riceve:

- `item: subItem` — il suo proprio dato.
- `currentIndex: widget.currentIndex` — **lo stesso identico valore ricevuto dal genitore**, passato inalterato. Questo è ciò che permette a una sotto-voce di sapere se *lei stessa* è quella selezionata, confrontando il proprio `id` con lo stesso `currentIndex` che sta girando in tutto l'albero.
- `onMenuChanged: widget.onMenuChanged` — **la stessa identica funzione ricevuta dal genitore**, passata inalterata anch'essa. Per questo, quando una sotto-voce (foglia) viene cliccata, la notifica risale fino in cima alla catena — fino a `SideMenu`, fino ad `AdminManagerScreen`, fino al Cubit — indipendentemente da quanti livelli di annidamento ci siano in mezzo. Nessun livello intermedio deve "inoltrare manualmente" nulla: è la stessa funzione, semplicemente condivisa lungo tutta la discesa.

`AnimatedSize` è il widget che rende fluida l'apertura/chiusura: anima automaticamente la transizione tra la dimensione del `child` precedente e quella nuova, ogni volta che il `child` cambia. Quando `_isExpanded` è falso, il `child` è un `SizedBox(height: 0)` — praticamente niente, ma con **larghezza `double.infinity` esplicita**: questo dettaglio evita un effetto collaterale dove, durante l'animazione, la larghezza della tendina "scatterebbe" lateralmente invece di restare stabile mentre cambia solo l'altezza (il commento originale nel codice — *"per prevenire l'effetto di espansione laterale"* — si riferisce proprio a questo). `alignment: Alignment.topCenter` fa sì che la crescita/riduzione avvenga "dall'alto", cioè il contenuto si apre verso il basso, non si espande simmetricamente in entrambe le direzioni.

### 3.3 In sintesi: come "SideMenu" diventa un albero

```
SideMenu
  └── per ogni item di primo livello → _SideMenuItem
        ├── riga cliccabile (sempre presente)
        │     └── click: hasSubItems? → toggle locale : notifica il Cubit
        └── AnimatedSize (tendina)
              └── se espansa: per ogni subItem → _SideMenuItem (di nuovo!)
                    ├── riga cliccabile
                    └── AnimatedSize (tendina, eventualmente vuota se subItem non ha a sua volta subItems)
```

---

## 4. `admin_manager_content.dart` — cosa mostrare a destra

Stessa funzione di prima, con più `case` per coprire anche gli id delle sotto-voci:

```dart
Widget _scadenzeContent(int sidebarIndex) {
  switch (sidebarIndex) {
    case 0: return const _Placeholder(text: 'Tutte le scadenze');
    case 1: return const _Placeholder(text: 'Scadenze borse di studio');
    case 21: return const _Placeholder(text: 'Scadenze beni di consumo su MePa');
    case 22: return const _Placeholder(text: 'Scadenze attrezzature su MePa');
    case 31: return const _Placeholder(text: 'Scadenze beni di consumo fuori MePa');
    case 32: return const _Placeholder(text: 'Scadenze pubblicazioni fuori MePa');
    default: return const SizedBox.shrink();
  }
}
```

Concettualmente non cambia nulla rispetto a prima: riceve un id già pronto (qui chiamato ancora `sidebarIndex`, ma — come già notato — è un id, non una posizione) e sceglie cosa disegnare. L'unico collegamento "invisibile" da tenere a mente è che **questi numeri devono coincidere esattamente** con gli id scritti in `admin_manager_menu_config.dart` per lo stesso tab — è proprio la mancata coincidenza a causare il bug descritto nella sezione 2.

---

## 5. `admin_manager_state.dart` e `admin_manager_cubit.dart` — la verità che cambia (aggiornato)

Qui c'è stato il cambiamento più sostanziale. Il Cubit ora gestisce anche **chi è l'utente loggato**, non solo la navigazione:

```dart
enum AdminStatus { loading, initial, error }

class AdminManagerState {
  final AdminStatus status;
  final int currentTabIndex;
  final int currentSidebarIndex;
  final AdminManagerUiModel? uiModel;

  const AdminManagerState({
    this.status = AdminStatus.loading, // Partiamo in caricamento
    this.currentTabIndex = 0,
    this.currentSidebarIndex = 0,
    this.uiModel,
  });

  AdminManagerState copyWith({
    AdminStatus? status,
    int? currentTabIndex,
    int? currentSidebarIndex,
    AdminManagerUiModel? uiModel,
  }) {
    return AdminManagerState(
      status: status ?? this.status,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      currentSidebarIndex: currentSidebarIndex ?? this.currentSidebarIndex,
      uiModel: uiModel ?? this.uiModel,
    );
  }
}
```

- **`AdminStatus`**: tre fasi. `loading` è ora il **valore di default** dello stato — la schermata parte assumendo di dover ancora aspettare qualcosa (i dati dell'utente), non pronta da subito come prima.
- **`uiModel`**: `AdminManagerUiModel?`, nullable — è `null` finché non arrivano i dati reali dell'utente, popolato solo dopo.

```dart
class AdminManagerCubit extends Cubit<AdminManagerState> {
  AdminManagerCubit() : super(const AdminManagerState());

  void loadUserData(LoginResponse loginResponse) {
    final uiModel = AdminManagerUiModel.fromAuthResult(loginResponse);
    emit(state.copyWith(status: AdminStatus.initial, uiModel: uiModel));
  }

  void changeTab(int index) {
    emit(state.copyWith(currentTabIndex: index, currentSidebarIndex: 0));
  }

  void changeSidebarTab(int index) {
    emit(state.copyWith(currentSidebarIndex: index));
  }
}
```

- **`loadUserData(LoginResponse loginResponse)`**: nuovo metodo. Prende il risultato del login (lo stesso oggetto che nasce durante l'autenticazione), lo trasforma in un `AdminManagerUiModel` tramite la sua fabbrica `fromAuthResult`, e lo emette insieme al cambio di stato a `AdminStatus.initial` — **in un solo `emit`**, non due separati. Questo evita un rebuild intermedio "a metà" (status cambiato ma uiModel ancora vecchio, o viceversa).
- **Nota sul nome `AdminStatus.initial`**: qui il nome può confondere. Normalmente "initial" suggerisce "stato di partenza, prima che succeda qualcosa" — ma qui viene usato per indicare **"pronto, dati caricati"**, cioè lo stato *dopo* che qualcosa è successo. Il vero "stato di partenza" è semanticamente `loading`. Vale la pena, quando ci torni sopra, valutare un nome più esplicito come `AdminStatus.ready` o `AdminStatus.loaded` per `initial`, per evitare questa ambiguità di lettura — non cambia il funzionamento, solo la chiarezza.
- **Un punto ancora aperto**: nessun metodo in questo Cubit porta mai lo stato a `AdminStatus.error`. Se `loadUserData` non venisse mai chiamato, la schermata resterebbe bloccata in `loading` per sempre; se `fromAuthResult` fallisse per qualche motivo, non c'è al momento un percorso che lo intercetti e lo trasformi in `AdminStatus.error`. Non è un errore in questo file preso da solo — è più che altro un "capitolo ancora da scrivere": manca ancora, in `admin_manager_screen.dart` o a monte, il pezzo che chiama `context.read<AdminManagerCubit>().loadUserData(...)` con i dati veri dell'utente al momento giusto (subito dopo il login).

`changeTab`/`changeSidebarTab` sono identici a prima nella logica: il reset di `currentSidebarIndex` a `0` quando cambi tab resta valido — anche se ora "0" corrisponde all'id della prima voce (che nella tua config è quasi sempre, per convenzione, la voce "Tutte/Tutti...").

---

## 6. `admin_manager_screen.dart` — dove tutto si incontra (nota di aggiornamento)

La struttura di collegamento resta la stessa descritta prima: `BlocProvider` crea il Cubit, `BlocBuilder` legge lo stato, passa `sidebarItems`/`selectedIndex`/`onMenuChanged` a `SideMenu`, e `tabIndex`/`sidebarIndex` a `AdminManagerContent`.

Una cosa da tenere a mente, collegata alla sezione precedente: lo screen **non usa ancora** `state.status` né `state.uiModel` — l'header mostra tuttora `'Salve Patrizia'` scritto a mano, invece di leggere `state.uiModel?.welcomeMessage`. Finché non viene aggiunta la chiamata a `loadUserData(...)` (e la lettura di `state.uiModel` nell'header), questi due nuovi campi esistono nello stato ma non hanno ancora effetto visibile sulla schermata — è il pezzo di collegamento che manca, di cui sopra.

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

## Il quadro d'insieme (aggiornato)

```
click su una voce (anche annidata)
        │
        ▼
_SideMenuItem
   hasSubItems?
      ├── sì  → setState locale (_isExpanded) — non esce da qui
      └── no  → onMenuChanged(item.id) risale fino a SideMenu
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
                   (+ status / uiModel, aggiornati separatamente
                    da loadUserData, non dal click sul menù)
                        │
                        ▼
                BlocBuilder si accorge del cambiamento → rebuild
                        │
                        ├──► AdminManagerMenuConfig.getSidebarItems(tabIndex)
                        │        traduce l'indice del tab in un albero di voci
                        │
                        ├──► SideMenu
                        │        ridisegna l'albero, ricorsivamente,
                        │        evidenziando la voce con id corrispondente
                        │
                        └──► AdminManagerContent
                                 traduce (tabIndex, id selezionato)
                                 nel contenuto da mostrare
```

Riassumendo in una frase: **il Cubit resta l'unica fonte di verità** (ora anche per chi è l'utente, non solo per la navigazione), la **config è il catalogo statico** che traduce un indice di tab in un albero di voci, `SideMenu` **si richiama ricorsivamente** per disegnare quell'albero a qualunque profondità, e ogni click su una foglia risale la stessa identica catena di callback fino al Cubit — indipendentemente da quanti livelli di annidamento attraversa lungo la strada.