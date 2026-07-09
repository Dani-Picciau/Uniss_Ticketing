# Architettura delle Entità: Il Cuore del Ticketing Uniss

Benvenuti in questa spiegazione dettagliata dell'architettura dati del progetto di ticketing per l'Università di Sassari. Come richiesto dal vostro professore, il sistema è stato progettato con un focus estremo sulla **flessibilità**, sulla **separazione tra logica e database** e sull'uso di **un singolo nodo generico** per gestire la complessità delle reti di Petri.

Immaginiamo di essere in un'aula: l'obiettivo di questo documento è farvi comprendere non solo *come* è scritto il codice, ma soprattutto *perché* sono state fatte queste scelte architetturali.

---

## 1. Il Concetto Fondamentale: Modello vs. Istanza

Prima di analizzare le singole classi, dobbiamo capire la differenza tra la **Regola** (il Modello) e la **Pratica reale** (l'Istanza). 

Pensate alla costruzione di una casa:
* Il **Modello** è il *progetto dell'architetto* (la piantina). Definisce quante stanze ci sono, dove passano i tubi e dove sono le porte.
* L'**Istanza** è *l'edificio reale in costruzione*. Ha dei muratori assegnati (gli utenti), uno stato di avanzamento (es. "Stiamo facendo il tetto") e dei materiali effettivamente consegnati.

Nel nostro codice:
* La classe `WorkflowTemplate` rappresenta il progetto dell'architetto.
* La classe `Procedure` rappresenta l'edificio in costruzione.

Questa separazione è il segreto per ottenere la flessibilità richiesta: se cambia una legge e serve un documento in più per gli acquisti MEPA, modificheremo la "piantina" nel database. Il codice Java non se ne accorgerà nemmeno, ma inizierà magicamente a richiedere il nuovo documento.

---

## 2. Analisi delle Classi (Package `entities`)

Le classi fondamentali presenti nel package `entities` sono quattro. Vediamole nel dettaglio.

### 2.1. `User.java` (L'Utente)
Questa classe è mappata sulla collezione `"Utenti"` in MongoDB. Rappresenta le persone fisiche che accedono al sistema.

**Campi principali:**
* `id`, `name`, `surname`, `email`, `title`: Dati anagrafici e di identificazione.
* `passwordHash`: La password crittografata per l'accesso.
* `role`: **Il campo più importante per il motore di routing.** Contiene stringhe come `"DOCENTE_RICHIEDENTE"`, `"RUP"`, o `"DIRETTORE"`.

**Perché questa implementazione?**
Il campo `role` è la "chiave" che apre le porte del flusso. Quando una procedura arriva a un determinato passo, il sistema guarda chi è abilitato a compiere quell'azione e lo confronta con il `role` dell'utente loggato. Questo permette a Flutter di mostrare le dashboard differenziate senza scrivere mille `if` nel codice backend.

### 2.2. `Node.java` (Il Nodo Generico Universale)
Questa è la classe che risponde direttamente alla direttiva del professore: *"Fare un unico tipo di nodo che possa indirizzare un numero illimitato di documenti"*. 

Invece di creare classi specifiche per ogni step (es. `VerificaAmministrativaNode`, `EmissioneCigNode`), abbiamo creato una scatola vuota e riutilizzabile. Sarà il database a riempirla di significato.

**Campi principali:**
* `nodeId`: Un identificativo univoco (es. `"STEP_2_PRIME_VERIFICHE"`).
* `stageName`: Il nome leggibile che Flutter mostrerà a schermo (es. "Prime Verifiche Amministrative").
* `enabledRole`: Chi ha il permesso di operare in questo nodo (es. `"RUP"`).
* `requirementsToSatisfy`: Una lista di stringhe (`List<String>`). Contiene i nomi dei documenti necessari in quello stadio (es. `["DURC", "Documento anticorruzione"]`).
* `nextNodeIfOk`: L'ID del nodo a cui passare quando tutti i requisiti sono soddisfatti.
* `nextNodeIfSkipped` e `skipCondition`: Usati per gestire deviazioni nel grafo (es. saltare la fideiussione se l'importo è < 40.000€).

**Perché questa implementazione?**
Perché garantisce **manutenibilità zero del codice Java**. Se domani un nodo richiede 15 documenti anziché 3, basta aggiungere stringhe nell'array JSON nel database. Java leggerà l'array, lo passerà a Flutter, e Flutter disegnerà 15 checkbox. La logica è disaccoppiata dal dato.

### 2.3. `WorkflowTemplate.java` (Il "Libretto delle Istruzioni")
Questa classe è mappata sulla collezione `"Template_flussi"`. Non contiene dati di pratiche reali, ma descrive le regole di un intero processo (come la Rete di Petri).

**Campi principali:**
* `procedureType`: L'identificativo del flusso (es. `"ORDINI_SU_MEPA_BENI_CONSUMO"`).
* `workflowName`: Nome esteso e descrittivo.
* `nodes`: Una lista di oggetti `Node` (`List<Node>`). È l'intero grafo del procedimento.

### 2.4. `Procedure.java` (L'Istanza, il Ticketing Reale)
Questa è la classe più attiva del sistema. Viene creata ogni volta che un docente preme "Nuova Richiesta". È mappata su una collezione separata (es. `"procedure"`).

**Campi principali:**
* `procedureType`: Un riferimento per capire quale template seguire (es. `"ORDINI_SU_MEPA_BENI_CONSUMO"`).
* `requesterId` e `rupId`: Gli ID degli utenti assegnati a questa pratica.
* `currentNodeId`: **Il Puntatore.** È una semplice stringa che indica in quale step del grafo ci troviamo (es. `"STEP_3_PUBBLICAZIONE_MEPA"`).
* `currentRequirementsStatus`: Una mappa `Map<String, Boolean>` che rappresenta lo stato delle checkbox.

**Perché NON abbiamo copiato tutta la lista dei Nodi dentro Procedure?**
Questa è una domanda che spesso emerge studiando il sistema. Se copiassimo tutti i nodi dentro ogni pratica, appesantiremmo il database a dismisura. Inoltre, se il Senato Accademico decidesse di cambiare le regole in corsa, le pratiche già aperte avrebbero una copia "vecchia" delle regole. 
Invece, usando il **Puntatore** (`currentNodeId`), l'istanza è leggerissima: sa solo in quale punto si trova, e delega al `WorkflowTemplate` il compito di spiegare quali sono le regole di quello specifico punto.

---

## 3. Dinamica di Funzionamento: Come dialogano queste classi

Ora uniamo i pezzi per capire come il sistema soddisfa i requisiti del progetto.

### Scenario: Il Prof. Rossi crea una richiesta
1. **Inizializzazione:** Il Prof. Rossi (ruolo `DOCENTE_RICHIEDENTE`) crea un ordine MEPA. Java crea un oggetto `Procedure`. Imposta `requesterId` con l'ID del prof e `procedureType` a `"ORDINI_SU_MEPA_BENI_CONSUMO"`.
2. **Lo start:** Java legge il `WorkflowTemplate`, prende il primo nodo (`"STEP_1_PREORDINE"`) e lo imposta come `currentNodeId` nella `Procedure`.
3. **Le Spunte:** Java guarda i `requirementsToSatisfy` del primo nodo e inizializza la mappa `currentRequirementsStatus`:
   * `"Preventivo/quotazione informale"` -> `false`
   * `"Dichiarazione di scelta con firma"` -> `false`
4. Flutter disegna due checkbox vuote.

### Scenario: L'Avanzamento
1. Il Prof. spunta le caselle. Java aggiorna la mappa mettendole a `true`.
2. Quando il Prof. clicca "Vai avanti", Java verifica che tutti i valori della mappa siano `true`.
3. Essendo tutti `true`, Java legge dal Template qual è il `nextNodeIfOk` (es. `"STEP_2_PRIME_VERIFICHE"`).
4. Java sostituisce il `currentNodeId` della `Procedure` con `"STEP_2_PRIME_VERIFICHE"`.
5. Ora l'`enabledRole` del nuovo nodo è `"RUP"`. Il Prof. non può più modificare la pratica, che "scompare" dalle sue operazioni attive e appare nella dashboard dei Responsabili Amministrativi.

### La Visione del Direttore
Il Direttore deve sapere quando serve una sua firma. Con questa architettura è banalissimo.
Basta dire al database: *"MongoDB, dammi tutte le Procedure il cui `currentNodeId` corrisponde a un nodo nel Template che ha `enabledRole: 'DIRETTORE'`"*. Immediatamente, il Direttore vedrà un cruscotto con le pratiche ferme agli step come `"STEP_7B_DETERMINA_FIRMATA"`.

---

## 4. Uno sguardo al Futuro: L'Upload dei Documenti

Il professore ha chiesto che in questa prima fase il sistema si limiti alle spunte (checkbox) e che l'upload venga aggiunto dopo. L'architettura è già pronta per questo.

Quando dovremo implementare l'upload, la logica a grafo non cambierà di una virgola. Non dovremo copiare i nodi. Cambierà solo un piccolo dettaglio nella classe `Procedure`:

Invece di avere una mappa booleana:
`Map<String, Boolean>` -> *Esempio: "DURC" = true*

Avremo una mappa di oggetti (o metadati file):
`Map<String, DocumentMetaData>` -> *Esempio: "DURC" = { url: "/files/durc123.pdf", caricatoDa: "RUP", data: "10-05-2026" }*

Il template continuerà a dirci "Serve un DURC". La procedura, invece di dire "Sì, c'è la spunta", dirà "Sì, eccoti il PDF". La flessibilità e l'eleganza del codice rimarranno incontaminate.
