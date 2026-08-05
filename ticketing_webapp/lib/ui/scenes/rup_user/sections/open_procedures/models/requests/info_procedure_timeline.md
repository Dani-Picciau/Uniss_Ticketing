# Come funziona la timeline completa di una procedura

Questo documento ricostruisce, passo per passo, tutto quello che è stato fatto — sia lato Java (Spring Boot) sia lato Flutter — per passare da "vedo solo lo step attuale" a "vedo l'intera timeline: passato, presente e futuro proiettato" di una procedura.

---

## 0. Il problema di partenza, in breve

Prima di questo lavoro, la timeline veniva costruita interamente lato Flutter, a partire da `ProcedureDetail` (un modello che rispecchiava l'entità `Procedure` di MongoDB così com'era). Quel modello conteneva solo **due fonti**: `completedSteps` (il passato, già accaduto) e `currentNodeId`/`currentEnabledRole` (il presente). Non c'era **nessuna fonte per il futuro** — gli step del workflow non ancora raggiunti — perché quell'informazione non vive nell'istanza della procedura, vive nel **template** del workflow (`WorkflowTemplate`, con i suoi `Node`), un oggetto completamente separato che nessun endpoint esponeva a Flutter.

La soluzione doveva rispondere a una domanda in più: *"dato dove sono ora, dove andrò dopo?"* — e qui è nata la complicazione più interessante di tutto questo lavoro, spiegata nella prossima sezione.

---

## 1. Lato Java — come si ottiene la timeline completa

### 1.1 `Procedure.java` — l'istanza, così com'è

Rappresenta la "copia in esecuzione" di una procedura: sa il tipo (`procedureType`, che la collega al template giusto), lo step attuale (`currentNodeId`), tutto lo storico (`completedSteps`, una lista di `CompletedStep` che cresce e non si svuota mai), e due metodi di utilità già pronti che torneranno utili:

```java
public boolean isFinished() {
    return "FINITO".equals(currentNodeId) || "COMPLETATA".equals(status);
}

public boolean areAllCurrentRequirementsSatisfied() {
    if (currentRequirementsStatus == null || currentRequirementsStatus.isEmpty()) return false;
    return currentRequirementsStatus.stream().allMatch(RequirementStatus::isSatisfied);
}
```

Questa classe **non cambia** in questo lavoro — resta il "cosa è successo finora". Il pezzo nuovo si aggiunge in `WorkflowService`.

### 1.2 Il nodo del problema: il workflow è un grafo, non una lista

Il motivo per cui non si può semplicemente "prendere la lista dei nodi del template e mostrarli tutti in ordine" sta in `advanceToNextStep`, già esistente in `WorkflowService`:

```java
String nextNodeId = skip
        ? currentNode.getNextNodeIfSkipped()
        : currentNode.getNextNodeIfOk();
```

Ogni nodo ha **due** possibili nodi successivi, non uno — e quale dei due viene preso dipende da `canSkip()`, che valuta dinamicamente una condizione scritta nel database (es. `"amount < 40000"`) usando Spring Expression Language:

```java
private boolean canSkip(Procedure procedure, Node node) {
    if (node.getSkipCondition() == null || node.getSkipCondition().isBlank()) {
        return false;
    }
    ExpressionParser parser = new SpelExpressionParser();
    StandardEvaluationContext context = new StandardEvaluationContext(procedure);
    Boolean result = parser.parseExpression(node.getSkipCondition()).getValue(context, Boolean.class);
    return result != null && result;
}
```

Questo significa che **il percorso futuro dipende dai dati della singola procedura** (es. il suo importo) — due procedure dello stesso tipo, con importi diversi, potrebbero seguire percorsi futuri diversi. Non è un elenco statico leggibile una volta per tutte dal template: va **calcolato**, procedura per procedura, camminando nel grafo esattamente come farebbe `advanceToNextStep` — ma "a secco", senza salvare nulla, solo per scoprire cosa succederebbe.

### 1.3 `WorkflowService.getFullTimeline()` — passo per passo

```java
public TimelineDto getFullTimeline(String procedureId) {
    Procedure procedure = getProcedureById(procedureId);
    WorkflowTemplate template = getTemplateForProcedure(procedure);

    List<TimelineStepDto> steps = new ArrayList<>();

    // 1. Step già completati: dato reale, nessun calcolo necessario
    for (CompletedStep completed : procedure.getCompletedSteps()) {
        steps.add(new TimelineStepDto(
                completed.getNodeId(),
                completed.getStageName(),
                null, // enabledRole: non salvato per gli step passati
                List.of(),
                true,
                false
        ));
    }

    if (!procedure.isFinished()) {
        // 2. Step attuale
        Node currentNode = getCurrentNode(procedure, template);
        steps.add(new TimelineStepDto(
                currentNode.getNodeId(),
                currentNode.getStageName(),
                currentNode.getEnabledRole(),
                currentNode.getRequirementsToSatisfy(),
                false,
                true
        ));

        // 3. Percorso futuro proiettato: stesso ramo che advanceToNextStep
        // prenderebbe DAVVERO, senza salvare nulla.
        Node cursor = currentNode;
        int safetyLimit = template.getNodes().size() + 1; // anti loop-infinito

        while (safetyLimit-- > 0) {
            boolean wouldSkip = canSkip(procedure, cursor);
            String nextId = wouldSkip ? cursor.getNextNodeIfSkipped() : cursor.getNextNodeIfOk();

            if (nextId == null || "FINITO".equals(nextId)) break;

            Node next = template.findNodeById(nextId);
            if (next == null) break; // template incoerente: ci fermiamo, non esplodiamo

            steps.add(new TimelineStepDto(
                    next.getNodeId(),
                    next.getStageName(),
                    next.getEnabledRole(),
                    next.getRequirementsToSatisfy(),
                    false,
                    false
            ));
            cursor = next;
        }
    }

    return new TimelineDto(procedure.getId(), procedure.getTitle(), procedure.getStatus(), steps);
}
```

Passo per passo, cosa fa:

1. **Step completati**: copiati direttamente da `procedure.getCompletedSteps()` — sono fatti, nessun calcolo, `completed: true`.
2. **Step attuale**: preso da `currentNodeId`, marcato `active: true`.
3. **Step futuri**: qui sta la parte nuova. Partendo dal nodo attuale (`cursor`), il ciclo chiede a ogni passo "questo nodo salterebbe?" (`canSkip`), sceglie il prossimo nodo di conseguenza (esattamente la stessa logica di `advanceToNextStep`, riusata **senza duplicarla**), e continua finché non trova `"FINITO"` o un nodo mancante.
4. **`safetyLimit`**: una guardia contro un template scritto male con un ciclo (nodo A → nodo B → nodo A...) che altrimenti farebbe girare il `while` per sempre. Il valore massimo possibile di passi è "quanti nodi ha il template", quindi usarlo come limite è una scelta sicura senza essere arbitraria.
5. **`next == null → break`**: se il template referenzia un `nodeId` che non esiste, ci si ferma silenziosamente invece di far esplodere la richiesta — coerente con lo stile difensivo già presente altrove nel progetto (es. `getSidebarItems` che ritorna lista vuota invece di crashare).

### 1.4 `TimelineDto` / `TimelineStepDto`

Due semplici classi-contenitore (inner class di `WorkflowService`, stesso stile di `StepOptions` già esistente):

```java
public static class TimelineDto {
    private final String procedureId;
    private final String title;
    private final String status;
    private final List<TimelineStepDto> steps;
    // costruttore + getter
}

public static class TimelineStepDto {
    private final String nodeId;
    private final String stageName;
    private final String enabledRole; // null per gli step completati
    private final List<String> requirementsToSatisfy;
    private final boolean completed;
    private final boolean active;
    // costruttore + getter
}
```

`enabledRole` è nullable apposta: per gli step già completati, quel dato non è mai stato salvato in `CompletedStep` — mostrare "COMPLETATO" al suo posto è una scelta di presentazione, fatta più avanti lato Flutter, non qui.

### 1.5 `WorkflowController` — il nuovo endpoint

```java
@GetMapping("/{procedureId}/timeline")
public ResponseEntity<?> getFullTimeline(@PathVariable String procedureId) {
    try {
        WorkflowService.TimelineDto timeline = workflowService.getFullTimeline(procedureId);
        return ResponseEntity.ok(timeline);
    } catch (RuntimeException e) {
        return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
    }
}
```

`GET /api/workflow/{procedureId}/timeline` — accanto agli altri endpoint di `WorkflowController` (`/start`, `/requirement`, `/advance`, `/options`...), stesso stile di gestione errori (try/catch che traduce in `400` con `{"error": "..."}`, coerente con come `AuthController`/gli altri controller già gestiscono gli errori in questo progetto).

---

## 2. Lato Flutter — dal JSON alla schermata

### 2.1 `timeline_dto.dart` — lo specchio Dart dei DTO Java

```dart
@freezed
class TimelineDto with _$TimelineDto {
  const factory TimelineDto({
    required String procedureId,
    required String title,
    required String status,
    @Default([]) List<TimelineStepDto> steps,
  }) = _TimelineDto;

  factory TimelineDto.fromJson(Map<String, dynamic> json) => _$TimelineDtoFromJson(json);
}

@freezed
class TimelineStepDto with _$TimelineStepDto {
  const factory TimelineStepDto({
    required String nodeId,
    required String stageName,
    String? enabledRole,
    @Default([]) List<String> requirementsToSatisfy,
    required bool completed,
    required bool active,
  }) = _TimelineStepDto;

  factory TimelineStepDto.fromJson(Map<String, dynamic> json) => _$TimelineStepDtoFromJson(json);
}
```

Nota i nomi: **identici**, campo per campo, a `TimelineDto`/`TimelineStepDto` lato Java (compreso il nome delle classi stesse). Non è un caso — è la stessa disciplina già vista con `LoginResponse`/il contratto del login: quando il JSON che arriva ha una forma nota e stabile, rispecchiarla 1:1 in Dart rende ovvio, guardando i due file affiancati, che stanno parlando della stessa cosa.

Questo file **sostituisce** il vecchio `procedure_detail.dart` (che rispecchiava l'entità `Procedure` grezza) — non esiste più, come segnalato. È una buona rimozione: quel modello vecchio esponeva più dati di quanti la timeline ne avesse davvero bisogno (es. `amount`, `deadline`, `assignedRupId`...), e nessuno di quei campi extra viene usato dalla schermata della timeline.

### 2.2 `ProcedureDetailApi.getFullTimeline()` — chi chiama l'endpoint

Non mi hai mandato il contenuto aggiornato di questo file in questo giro, ma il suo utilizzo nel Cubit (`final timelineDto = await _detailApi.getFullTimeline(procedureId);`) rende chiara la sua forma, seguendo esattamente lo stesso schema del vecchio `getProcedureById` che avevi già:

```dart
Future<TimelineDto> getFullTimeline(String procedureId) async {
  try {
    final token = await _sessionManager.getToken();
    final response = await _apiClient.dio.get(
      '/api/workflow/$procedureId/timeline',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return TimelineDto.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    throw Exception('Errore di rete nel recupero della timeline: ${e.message}');
  } catch (e) {
    throw Exception('Errore imprevisto nel parsing della timeline: $e');
  }
}
```

Se la tua versione reale è diversa, dimmelo e correggo questa sezione.

### 2.3 `TimelineStepUiModel` — il UiModel di riga, ora molto più semplice

```dart
static List<TimelineStepUiModel> fromTimelineDto(TimelineDto dto) {
  return dto.steps.map((item) {
    final displayTitle = item.stageName.isNotEmpty ? item.stageName : item.nodeId;
    final displayRole = item.completed ? 'COMPLETATO' : (item.enabledRole ?? 'DA DEFINIRE');

    return TimelineStepUiModel(
      title: displayTitle,
      role: displayRole,
      requirements: item.requirementsToSatisfy,
      isCompleted: item.completed,
      isActive: item.active,
    );
  }).toList();
}
```

Confronta questo con la vecchia `fromProcedureDetail` (quella commentata, lasciata nel file come riferimento): prima serviva un ciclo per gli step completati, un `if` separato per lo step attuale, e un secondo passaggio per `isFirst`/`isLast`. Ora è **una singola `.map()`** — perché il backend restituisce già una lista piatta, nell'ordine giusto, con lo stato già calcolato per ciascuno step. Il lavoro pesante (distinguere completato/attuale/futuro, seguire i salti condizionali) è stato spostato lato Java, dove il dato per farlo correttamente esiste davvero. Flutter torna a fare quello che un UiModel dovrebbe fare: solo *formattazione* (scegliere `stageName` vs `nodeId` come titolo, tradurre `null` in un'etichetta leggibile), non *logica di dominio*.

`isFirst`/`isLast` non ci sono più, come deciso in precedenza — restano calcolati a runtime dentro `ProcedureTimelineView`, con l'indice della lista già disponibile lì.

### 2.4 `ProcedureTimelineUiModel` — il UiModel di pagina

```dart
factory ProcedureTimelineUiModel.fromTimelineDto(TimelineDto dto) {
  return ProcedureTimelineUiModel(
    id: dto.procedureId,
    title: dto.title,
    status: dto.status,
    steps: TimelineStepUiModel.fromTimelineDto(dto),
  );
}
```

Stessa idea della sezione precedente (il "contenitore" che porta sia `title` sia la lista `steps`), solo che ora `fromTimelineDto` prende in ingresso il DTO invece di `ProcedureDetail`. Nota come delega la costruzione della lista a `TimelineStepUiModel.fromTimelineDto(dto)` — nessuna duplicazione tra i due file.

### 2.5 `ProcedureTimelineState` — una correzione al bug del `copyWith`

Ricorderai la discussione sul sentinel `_Unset` per poter azzerare `uiModel` esplicitamente. Guardando il file che mi hai mandato ora, hai scelto la **strada alternativa** che avevamo discusso, invece del sentinel:

```dart
// State: copyWith "normale", senza sentinel
ProcedureTimelineState copyWith({
  ProcedureTimelineStatus? status,
  ProcedureTimelineUiModel? uiModel,
  String? errorMessage,
}) {
  return ProcedureTimelineState(
    status: status ?? this.status,
    uiModel: uiModel ?? this.uiModel,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
```

```dart
// Cubit: clearSelection costruisce lo stato DIRETTAMENTE, bypassando copyWith
void clearSelection() {
  emit(const ProcedureTimelineState(status: ProcedureTimelineStatus.initial));
}
```

Questa è esattamente l'alternativa 1 di cui parlavamo: invece di rendere `copyWith` capace di distinguere "non toccare" da "azzera esplicitamente", `clearSelection()` scavalca del tutto `copyWith` per questo caso specifico, costruendo un `ProcedureTimelineState` nuovo di zecca con tutti i valori di default (`uiModel` torna `null` perché è il default del costruttore, non perché qualcuno gliel'ha "sottratto"). Funziona correttamente, è più semplice da leggere del sentinel, e va benissimo qui perché `ProcedureTimelineState` non ha altri campi che il reset dovrebbe preservare selettivamente. **Nota di coerenza**: `errorMessage` invece ha mantenuto il fallback corretto (`?? this.errorMessage`) — quindi qui il bug che avevamo trovato in altri file è già risolto.

### 2.6 `ProcedureTimelineCubit` — l'orchestratore

```dart
Future<void> fetchTimeline(String procedureId) async {
  emit(state.copyWith(status: ProcedureTimelineStatus.loading));
  try {
    final timelineDto = await _detailApi.getFullTimeline(procedureId);
    final uiModel = ProcedureTimelineUiModel.fromTimelineDto(timelineDto);
    emit(state.copyWith(status: ProcedureTimelineStatus.success, uiModel: uiModel));
  } catch (e) {
    emit(state.copyWith(status: ProcedureTimelineStatus.error, errorMessage: e.toString()));
  }
}
```

Il flusso resta lo stesso di prima (loading → chiamata → success/error), solo la fonte del dato è cambiata: prima `getProcedureById` + `fromProcedureDetail` (due passaggi, con logica di merge lato Flutter), ora `getFullTimeline` + `fromTimelineDto` (un passaggio, dato già pronto). Anche il doppio `emit` ridondante che c'era in una versione precedente è sparito — resta solo un `emit` per il caso di successo.

### 2.7 `ProcedureTimelineView` + `NodeItem` — il disegno vero e proprio

`ProcedureTimelineView` non è cambiato nella logica da quando l'abbiamo aggiornato: riceve `data` (il UiModel di pagina), mostra `data.title` nell'header, e nel `ListView.builder` calcola `isFirst`/`isLast` dall'indice:

```dart
itemBuilder: (context, index) {
  final step = data.steps[index];
  return NodeItem(
    title: step.title,
    role: step.role,
    requirements: step.requirements,
    isFirst: index == 0,
    isLast: index == data.steps.length - 1,
    isCompleted: step.isCompleted,
    isActive: step.isActive,
  );
},
```

`NodeItem` (il singolo "pallino + linea + testo" della timeline visiva, basato sul pacchetto `timeline_tile`) non ha subito modifiche di logica in questo lavoro — riceve gli stessi campi di sempre (`title`, `role`, `requirements`, `isFirst`, `isLast`, `isCompleted`, `isActive`) e decide i colori (verde = completato, blu = attivo, grigio = futuro) in base a questi. L'unica differenza visibile è cosmetica: i `Text` sono diventati `UnissLabel`, coerente con il resto dell'app.

---

## 3. Il percorso prima della timeline: come si arriva a selezionare una procedura

Prima di vedere la timeline di *una* procedura, l'utente vede la *lista* delle procedure di quel tipo. Questo pezzo non è cambiato in questo lavoro, ma è utile ricordarlo perché è il punto di partenza del flusso completo.

### 3.1 `ProcedureSummary` — un modello "leggero" apposta

```dart
@freezed
class ProcedureSummary with _$ProcedureSummary {
  const factory ProcedureSummary({
    required String id,
    required String title,
    required String procedureType,
    required String status,
    required String currentNodeId,
    required DateTime createdAt,
    DateTime? deadline,
  }) = _ProcedureSummary;
  ...
}
```

Nota che è un modello **diverso** da `TimelineDto`/`Procedure` — porta solo i campi che servono per mostrare una riga nella lista (titolo, stato, fase attuale), non l'intero storico né i requisiti. Il commento nel Cubit lo conferma: *"Chiamata leggera che restituisce solo i summary"*. È la stessa logica di "un UiModel per ogni bisogno specifico" di cui parlavamo — qui applicata direttamente a un modello di richiesta, non solo ai UiModel.

### 3.2 `ProcedureListCubit` / `ProcedureListState`

```dart
Future<void> fetchProceduresByCategory(String procedureType) async {
  try {
    final procedures = await _procedureListApi.getproceduresByType(procedureType);
    if (procedures.isEmpty) {
      emit(state.copyWith(status: ProcedureListStatus.empty));
    } else {
      emit(state.copyWith(status: ProcedureListStatus.success, procedures: procedures));
    }
  } catch (e) {
    emit(state.copyWith(status: ProcedureListStatus.error, errorMessage: '$e'));
  }
}
```

Stesso pattern loading/success/error/empty visto altrove nel progetto. **Nota**: `ProcedureListState.copyWith` ha ancora `errorMessage: errorMessage,` senza `?? this.errorMessage` — lo stesso bug già segnalato per altri file, non ancora corretto qui. Non blocca nulla nell'uso attuale, ma vale la pena allinearlo quando ci ripassi.

### 3.3 `ShowOpenProcedureList` + `OpenProcedureListItem`

Il widget che mostra la lista (`ShowOpenProcedureList`) fa da ponte tra `ProcedureListCubit` (che possiede) e `ProcedureTimelineCubit` (che legge dal `context`, fornito più in alto — vedi sezione 4):

```dart
return OpenProcedureListItem(
  procedure: procedure,
  onTap: () {
    context.read<ProcedureTimelineCubit>().fetchTimeline(procedure.id);
  },
);
```

Il click su una riga della lista non "naviga" da nessuna parte — semplicemente chiama `fetchTimeline` sul Cubit della timeline. È quel cambiamento di stato (non un `Navigator`/`go_router`) a far scomparire la lista e comparire la timeline, come vediamo nella prossima sezione.

---

## 4. `SharedTimelineProcedure` — il pezzo che unisce lista e timeline (ora generico)

Questo file **non esisteva prima** con questo nome — prima c'era `OpenMepaConsumerGoods`, un widget dedicato specificamente ai "Beni di consumo su MePa", con `procedureType` scritto a mano dentro (`'ORDINI_SU_MEPA_BENI_CONSUMO'`). Ora è diventato `SharedTimelineProcedure`, che riceve `procedureType` come parametro:

```dart
class SharedTimelineProcedure extends StatelessWidget {
  final String procedureType;
  const SharedTimelineProcedure({super.key, required this.procedureType});
  ...
}
```

È la stessa evoluzione già vista con `SharedProcedureForm` per il form di nuova procedura: da "un widget per ogni sezione specifica" a "un widget generico, riusabile, parametrizzato". Questo significa che, con ogni probabilità, `admin_manager_content.dart` ora chiama `SharedTimelineProcedure(procedureType: '...')` con un valore diverso per ciascuna voce del menù laterale (Beni di consumo, Attrezzature, Pubblicazioni...), invece di avere un widget dedicato per ognuna — ma non ho il file aggiornato di `admin_manager_content.dart` per confermarlo con certezza.

Il compito di `SharedTimelineProcedure` è **decidere quale delle due schermate mostrare**, in base allo stato di `ProcedureTimelineCubit`:

```dart
builder: (context, state) {
  if (state.status == ProcedureTimelineStatus.initial) {
    return ShowOpenProcedureList(procedureType: procedureType);
  }
  if (state.status == ProcedureTimelineStatus.loading) {
    return const Center(child: CircularProgressIndicator());
  }
  if (state.status == ProcedureTimelineStatus.error) {
    return ...; // messaggio + bottone "Torna alla lista"
  }
  return ProcedureTimelineView(data: state.uiModel!);
},
```

Un solo Cubit (`ProcedureTimelineCubit`), un solo `status`, quattro possibili schermate — non due widget separati che si passano il controllo a vicenda. Questo è il motivo per cui il `BlocProvider` di `ProcedureTimelineCubit` vive qui, un livello sopra sia la lista sia la timeline: entrambe le sotto-schermate leggono lo stesso Cubit condiviso (`ShowOpenProcedureList` lo legge per innescare `fetchTimeline` al click, `ProcedureTimelineView` lo legge per `clearSelection` al bottone "indietro").

---

## 5. Il flusso end-to-end, passo per passo

```
Utente clicca una voce del side menu (es. "Beni di consumo")
        │
        ▼
AdminManagerContent → SharedTimelineProcedure(procedureType: '...')
        │
        ▼
BlocProvider crea ProcedureTimelineCubit (status: initial)
        │
        ▼
SharedTimelineProcedure mostra ShowOpenProcedureList
        │
        ▼
ProcedureListCubit.fetchProceduresByCategory(procedureType)
   → ProcedureListApi → GET (endpoint leggero, solo summary)
   → lista di ProcedureSummary mostrata come righe cliccabili
        │
        ▼
Utente clicca una riga (OpenProcedureListItem)
        │
        ▼
context.read<ProcedureTimelineCubit>().fetchTimeline(procedure.id)
   → status: loading → SharedTimelineProcedure mostra lo spinner
        │
        ▼
ProcedureDetailApi.getFullTimeline(procedureId)
   → GET /api/workflow/{id}/timeline
        │
        ▼
WorkflowController.getFullTimeline
   → WorkflowService.getFullTimeline
        │
        ├─ copia i CompletedStep così come sono (completed: true)
        ├─ aggiunge lo step attuale (active: true)
        └─ cammina nel grafo del template, nodo per nodo,
           valutando canSkip() a ogni passo, finché non trova
           "FINITO" o un nodo mancante
        │
        ▼
TimelineDto (JSON) torna a Flutter
        │
        ▼
ProcedureTimelineUiModel.fromTimelineDto(dto)
   → TimelineStepUiModel.fromTimelineDto(dto) per la lista
        │
        ▼
ProcedureTimelineCubit emette status: success, uiModel: ...
        │
        ▼
SharedTimelineProcedure mostra ProcedureTimelineView(data: uiModel)
   → header con data.title
   → ListView.builder → un NodeItem per ogni step
        (isFirst/isLast calcolati qui, dall'indice)
        │
        ▼
Utente clicca "← Torna alla lista"
   → context.read<ProcedureTimelineCubit>().clearSelection()
   → status torna a initial, uiModel torna null (stato ricostruito da zero)
   → SharedTimelineProcedure rimostra ShowOpenProcedureList
```

---

## 6. File probabilmente obsoleti, da verificare

Con `ProcedureDetail` rimosso, alcuni modelli che gli ruotavano attorno potrebbero non essere più usati da nessuna parte — ma non ho visibilità sull'intero progetto per esserne certo al 100%:

- **`completed_step.dart`** (`CompletedStep`, il modello Dart): era usato solo da `ProcedureDetail.completedSteps`. Con `TimelineDto` che sostituisce tutto, non lo vedo referenziato in nessuno dei file che mi hai mandato ora. Probabilmente eliminabile, ma controlla prima che non serva altrove.
- **`node_status_request.dart`** (`RequirementStatus`, il modello Dart): stesso discorso, era annidato dentro `CompletedStep`. Se `CompletedStep` sparisce e nessun'altra schermata mostra i requisiti di uno step passato, anche questo potrebbe seguire.
- **`procedure_node_request.dart`** (`ProcedureNode`): rispecchia il `Node` del template Java, ma nel flusso descritto qui **Flutter non riceve mai il template grezzo** — il backend fa tutto il lavoro sul grafo internamente e restituisce solo DTO già "appiattiti". Questo modello resta silente per ora; avrebbe senso se un giorno costruissi una schermata di amministrazione dei template stessi (non la timeline di una procedura).

## 7. Cose aperte, non bloccanti

- `ProcedureListState.copyWith` ha ancora il bug del `errorMessage` senza `?? this.errorMessage` (sezione 3.2).
- `NodeItem` usa ancora colori Material grezzi (`Colors.green`, `Colors.blue`, `Colors.grey.shade400`...) invece di `context.colors` — non allineato al sistema di temi chiaro/scuro che avete costruito. Da rivedere quando toccherete di nuovo questo widget.
- `open_procedure_list.dart` ha ancora un `Text('Nessuna procedura trovata.')` letterale invece di `UnissLabel` — piccola incoerenza cosmetica, non funzionale.
