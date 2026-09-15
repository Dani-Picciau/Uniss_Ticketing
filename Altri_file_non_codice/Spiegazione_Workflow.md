# Architettura del Ticketing System: WorkflowController e WorkflowService

Questo documento illustra nel dettaglio il funzionamento, la logica e l'interazione dei due componenti centrali del sistema di ticketing per le procedure amministrative universitarie: il **`WorkflowController`** e il **`WorkflowService`**.

L'architettura è stata progettata seguendo le specifiche rigorose del professore: **separare la logica di funzionamento dal database** e garantire una **flessibilità estrema** tramite un "motore di workflow" basato su un unico tipo di nodo (ispirato alle reti di Petri).

---

## 1. La Filosofia di Base: Il "Motore Data-Driven"

Il cuore innovativo di questo progetto è l'approccio *Data-Driven* (guidato dai dati). Invece di scrivere nel codice Java le regole specifiche per un "Ordine su MEPA" o per una "Borsa di Studio" (es. *se sei allo step 3 devi spuntare il DURC*), il codice Java **non sa nulla** delle procedure specifiche.

Il codice Java si comporta come un "motore" generico o un lettore:
1. Legge il "copione" (il **Template**) dal database MongoDB.
2. Interpreta il **Nodo** corrente (lo stato in cui si trova la procedura).
3. Richiede l'interazione dell'utente basandosi sui **Requisiti** scritti in quel nodo.
4. Passa al nodo successivo seguendo le "frecce" (gli ID dei nodi successivi) definite sempre nel database.

Questo garantisce che se domani l'Ateneo decide di aggiungere un nuovo documento obbligatorio a un iter, sarà sufficiente modificare il file JSON su MongoDB, **senza dover toccare o ricompilare una singola riga di codice Java**.

---

## 2. WorkflowController (Il "Cancello")

Il `WorkflowController` (situato in `web_api`) funge da intermediario esclusivo tra l'interfaccia utente (l'app Flutter) e la logica di business (il Service).

### Il suo ruolo:
* **Non contiene logica di business:** Non prende decisioni, non calcola nulla, non accede direttamente al database.
* **Ricezione e Traduzione:** Riceve le richieste HTTP (GET, POST, PUT) da Flutter, estrae i dati dal formato JSON utilizzando delle classi di supporto chiamate **DTO (Data Transfer Objects)** e chiama i metodi appropriati del Service.
* **Risposta:** Prende il risultato dal Service (es. la procedura aggiornata) e lo impacchetta in una risposta HTTP (codice 200 OK) da rimandare a Flutter. Se c'è un errore, restituisce un codice 400 Bad Request con un messaggio di errore leggibile.

### Gli Endpoint principali esposti:
* `POST /api/workflow/start`: Avvia una nuova procedura.
* `PUT /api/workflow/{id}/requirement`: Aggiorna (spunta o toglie la spunta) a un requisito.
* `POST /api/workflow/{id}/advance`: Fa avanzare la procedura al nodo successivo (sia in percorso normale che "saltato").
* `GET /api/workflow/...`: Varie chiamate (Dashboard) per recuperare le liste di procedure associate a un Docente, a un RUP o al Direttore.

---

## 3. WorkflowService (Il "Cervello")

Il `WorkflowService` (situato in `services`) contiene tutta la "logica intelligente" del sistema. È qui che le direttive del professore prendono vita. Interagisce con MongoDB tramite le interfacce `ProcedureRepository` e `WorkflowTemplateRepository`.

### Logiche e Funzionalità Chiave:

#### A. Inizializzazione di una Procedura (`startProcedure`)
Quando un Docente avvia una procedura, il Service:
1. Cerca nel DB il template richiesto (es. `ORDINI_SU_MEPA_BENI_CONSUMO`).
2. Prende il **primo nodo** della lista.
3. Crea un'istanza della classe `Procedure`, salvando al suo interno:
   * Lo stato dei requisiti (tutti inizialmente `false`, cioè da spuntare).
   * L'ID del nodo corrente.
   * **Il ruolo abilitato (currentEnabledRole):** *Questa è una feature fondamentale.* Legge dal template chi deve operare in quello step (es. "DOCENTE_RICHIEDENTE") e lo salva nella procedura. Questo rende le query per la dashboard universalmente valide.

#### B. Gestione dei Requisiti (`updateRequirementStatus`)
Quando nell'app Flutter l'utente clicca su una checkbox per confermare di avere un documento (es. "DURC"):
1. Il Service carica la procedura in corso.
2. Scorre l'array dei requisiti attuali e cambia lo stato (`true`/`false`) del requisito specifico.
3. Salva la procedura su DB. (Nota: i documenti veri non si caricano ancora, ci si limita a questo tracciamento di stato).

#### C. Avanzamento e Flessibilità Estrema (`advanceToNextStep`)
Questo è il metodo più complesso. Quando l'utente preme "Avanza":
1. **Controllo Requisiti:** Verifica se tutti i requisiti del nodo corrente sono stati soddisfatti. Se ne manca anche solo uno, blocca l'avanzamento e lancia un errore.
2. **Lo "Skip" (Salto Step):** Se l'utente richiede di saltare uno step (perché un percorso alternativo è permesso dalla rete di Petri), entra in gioco un valutatore dinamico.
   * **SpEL (Spring Expression Language):** Il codice utilizza SpEL per leggere la condizione testuale salvata nel DB (es. `"amount < 40000"`) e calcolarla come se fosse vero codice Java, confrontandola con l'importo della procedura corrente. Se l'importo è 30.000, SpEL dice "Sì, puoi saltare". Questo evita di dover programmare (hardcode) gli "if" nel codice.
3. **Archiviazione Storico:** Salva lo step appena concluso in una cronologia (`CompletedStep`), utile per tracciare chi ha fatto cosa e quando.
4. **Aggiornamento Nodo:** Legge l'ID del nodo successivo (`nextNodeIfOk` o `nextNodeIfSkipped`), recupera i requisiti del nuovo nodo e assegna il "turno" al nuovo ruolo responsabile.

#### D. Le Dashboard ("A chi tocca?")
Grazie all'attributo `currentEnabledRole` salvato nella Procedura, le query per le dashboard sono facilissime:
* Il **Direttore** vede tutte le procedure ferme su uno step dove il template diceva: `"enabledRole": "DIRETTORE"`. Non serve cercare ID di step specifici come "STEP_7B"; il sistema lo sa in automatico basandosi sui dati del momento.

---

## 4. Come interagiscono i componenti tra loro?

L'architettura segue un flusso lineare e pulito (MVC / N-Tier):

1. **Flutter (L'Utente):** Invia un payload JSON (es. un clic su una checkbox) verso un indirizzo (es. `/api/workflow/123/requirement`).
2. **WorkflowController:** Riceve il JSON, lo trasforma in un oggetto Java (`UpdateRequirementRequest`) e lo passa come parametro al metodo del `WorkflowService`.
3. **WorkflowService:** Esegue i controlli (es. "La procedura esiste?").
4. **Repositories (`ProcedureRepository`, `WorkflowTemplateRepository`):** Il Service "chiede" ai repository di andare su MongoDB a prendere i dati (Template e Procedura). I repository sono solo interfacce che Spring Boot implementa automaticamente.
5. **Entities (`Procedure`, `Node`, `WorkflowTemplate`):** I dati che tornano dal DB sono mappati su queste classi Java, che modellano esattamente la struttura del database.
6. **Ritorno:** Il Service fa le modifiche sull'Entità, il Repository salva sul DB, e il Controller invia a Flutter il JSON della procedura aggiornata, permettendo all'app di mostrare la spunta sulla checkbox o di sbloccare il bottone "Avanti".

---

## 5. Conclusione: L'Obiettivo del Professore Raggiunto

Questo setup garantisce esattamente ciò che è stato richiesto:
* **Unico tipo di nodo:** La classe `Node` modella qualsiasi stadio della procedura. Che sia l'attesa di un file dal MEPA o una firma del Direttore, per Java è solo un "Nodo con dei requisiti testuali".
* **Isolamento Logica/Dati:** Modificare un intero flusso (aggiungere step, togliere obblighi, cambiare le logiche di skip sotto soglia) richiede **zero** modifiche al codice. Basterà che l'amministratore del database aggiorni il file `Prova.Template_flussi.json` in MongoDB.
