# Formz nel form "Nuova Procedura MePa" — come funziona e perché

## 1. Il problema che Formz risolve

Prima, con `TextEditingController`, la gestione di un form aveva due responsabilità mescolate nello stesso oggetto:

- **Il valore digitato** (`controller.text`)
- **La validità** del valore, che dovevi calcolare a mano da qualche parte (spesso con `if` sparsi nel `build()` o in un `validator` isolato per campo, senza sapere lo stato *complessivo* del form)

Il risultato tipico: per sapere se il bottone "Crea procedura" va abilitato dovevi controllare manualmente ogni controller, spesso con `setState` sparsi ovunque, e la UI (widget) diventava responsabile anche della logica di validazione.

Formz sposta **valore + validità** dentro un unico oggetto immutabile, e sposta la validazione **fuori dalla UI**, dentro il Cubit. La UI si limita a leggere lo stato e disegnare.

---

## 2. Il mattoncino base: `FormzInput`

Nel tuo `form_inputs.dart` hai due classi che estendono `FormzInput<Valore, TipoErrore>`:

```dart
enum TextInputError { empty }

class TextInput extends FormzInput<String, TextInputError> {
  const TextInput.pure() : super.pure('');
  const TextInput.dirty([super.value = '']) : super.dirty();

  @override
  TextInputError? validator(String value) {
    return value.trim().isEmpty ? TextInputError.empty : null;
  }
}
```

Ogni `FormzInput` porta con sé, sempre:

| Proprietà | Significato |
|---|---|
| `value` | il valore attuale (es. il testo digitato) |
| `isPure` | `true` se il campo non è mai stato toccato dall'utente |
| `isValid` | `true` se `validator(value)` ritorna `null` |
| `error` | l'errore calcolato da `validator`, sempre presente (anche se pure) |
| `displayError` | **`null` se il campo è "pure"**, altrimenti uguale a `error` |

Questo è il punto chiave: **`error` vs `displayError`**.

- `error` esiste già anche su un campo mai toccato (perché `TextInput.pure('')` fallisce comunque la validazione: stringa vuota → `TextInputError.empty`).
- `displayError` invece resta `null` finché il campo è "pure", cioè finché non hai chiamato `.dirty(...)`.

Questo è esattamente il motivo per cui nel tuo `on_mepa.dart` scrivi:

```dart
errorText: state.title.displayError != null ? 'Campo obbligatorio' : null,
```

e **non** `state.title.error != null`: altrimenti vedresti "Campo obbligatorio" sotto ogni campo **appena aperto il form**, prima ancora che l'utente scriva qualcosa. Usando `displayError`, l'errore compare solo dopo che l'utente ha effettivamente interagito col campo (cioè dopo la prima chiamata a `.dirty()`).

`AmountInput` fa lo stesso ma con tre possibili errori invece di uno:

```dart
enum AmountInputError { empty, invalid, zeroOrNegative }

class AmountInput extends FormzInput<String, AmountInputError> {
  ...
  @override
  AmountInputError? validator(String value) {
    if (value.trim().isEmpty) return AmountInputError.empty;
    final amount = double.tryParse(value.replaceAll(',', '.'));
    if (amount == null) return AmountInputError.invalid;
    if (amount <= 0) return AmountInputError.zeroOrNegative;
    return null;
  }
}
```

Nella UI, infatti, mappi ogni possibile `displayError` a un messaggio diverso:

```dart
errorText: state.amount.displayError == AmountInputError.empty
    ? 'Importo obbligatorio'
    : state.amount.displayError == AmountInputError.invalid
    ? 'Numero non valido'
    : state.amount.displayError == AmountInputError.zeroOrNegative
    ? 'L\'importo deve essere > 0'
    : null,
```

**Nota su `AmountInput`/`TextInput`**: sono classi generiche riusate per campi concettualmente diversi (`title`, `deadline`, `procedureType`, `selectedProfessorId`, `selectedAdministratorId` sono tutti `TextInput`). Formz non "sa" cosa rappresenta il valore — sei tu a dare significato al campo in base a dove lo usi nello stato. Per questo `procedureType` e `selectedProfessorId`, pur essendo entrambi `TextInput`, hanno regole di validazione identiche (non vuoto) ma contenuto semanticamente diverso.

---

## 3. Dove vive lo stato: `NewProcedureState`

Invece di avere `String title`, `double amount`, ecc. nel tuo state, hai:

```dart
final TextInput title;
final AmountInput amount;
final TextInput deadline;
final TextInput procedureType;
final TextInput selectedProfessorId;
final TextInput selectedAdministratorId;
final bool isValid;
```

Ogni campo del form **è** un `FormzInput`, non una stringa grezza. Questo ti dà, gratis, sia il valore che l'errore, sempre sincronizzati nello stesso oggetto immutabile — niente disallineamenti tra "quello che vedo scritto" e "quello che è stato validato".

`isValid` invece **non** viene calcolato da Formz automaticamente ogni volta che leggi lo stato: è un campo booleare che *tu* calcoli e salvi esplicitamente, con `Formz.validate([...])` (vedi sezione 4). Non è un getter magico — è un valore congelato nel momento in cui hai chiamato `Formz.validate`.

---

## 4. Il cuore della logica: il Cubit

Ogni metodo "xChanged" nel tuo `NewProcedureCubit` segue sempre lo stesso pattern in 3 passi:

```dart
void titleChanged(String value) {
  // 1. Creo una nuova istanza "dirty" del FormzInput con il nuovo valore
  final title = TextInput.dirty(value);

  emit(
    state.copyWith(
      status: ProcedureStatus.initial,
      // 2. Sostituisco il vecchio campo nello state con quello nuovo
      title: title,
      // 3. Ricalcolo la validità GLOBALE del form con tutti i campi
      isValid: Formz.validate([
        title,               // <- quello appena creato, non state.title!
        state.amount,
        state.deadline,
        state.procedureType,
        state.selectedProfessorId,
        state.selectedAdministratorId,
      ]),
    ),
  );
}
```

Punti importanti:

- **`.dirty(value)`** è quello che "attiva" la validazione visibile (`displayError`). Finché un campo resta `.pure()` (come all'apertura del form), Formz lo considera valido ai fini del calcolo `error`/`isValid`? **No** — attenzione: `isValid` di un singolo `FormzInput` dipende solo da `validator(value)`, non da `isPure`. Un campo `.pure('')` è comunque `isValid == false` se vuoto. `isPure` incide solo su `displayError` (quello che mostri a schermo), non su `Formz.validate`.
- **`Formz.validate([...])`** prende una lista di `FormzInput` e ritorna `true` solo se **tutti** sono validi (`isValid == true` per ognuno). Per questo il bottone "Crea procedura" resta disabilitato finché anche un solo campo non rispetta il proprio `validator`.
- Passi sempre il campo **appena creato** (`title`) insieme a **tutti gli altri presi da `state`** (`state.amount`, `state.deadline`, ecc.), perché a questo punto `state` è ancora il vecchio stato — lo `emit` con il nuovo `title` avverrà solo dopo.

Lo stesso pattern esatto si ripete identico in `amountChanged`, `deadlineChanged`, `procedureTypeChanged`, `professorChanged`, `administratorChanged`: cambia solo *quale* campo viene reso `.dirty()` e sostituito nella lista.

---

## 5. Come la UI si aggancia (senza controller manuali)

Guarda `CommonInputField` nel tuo `on_mepa.dart`:

```dart
CommonInputField(
  label: 'Nome della procedura',
  onChanged: (value) => context.read<NewProcedureCubit>().titleChanged(value),
  errorText: state.title.displayError != null ? 'Campo obbligatorio' : null,
),
```

Non passi nessun `controller`. Il flusso è **unidirezionale**:

```
utente digita
   ↓
onChanged(value)
   ↓
cubit.titleChanged(value)  →  crea TextInput.dirty(value), calcola isValid, emit()
   ↓
BlocConsumer si ricostruisce con il nuovo state
   ↓
errorText legge state.title.displayError
```

Per i campi di testo "semplici" (`CommonInputField`, `NumericField`) il widget tiene comunque un suo `TextEditingController` interno (per mostrare il testo digitato), ma **la fonte di verità sulla validità è il Cubit**, non il controller.

Nei campi più particolari (`autocomplete_field.dart`, `date_input_field.dart`, `drop_down_field.dart`) noterai che **non leggono `state.title.value` per mostrare il testo** — è la UI nativa di Flutter (`Autocomplete`, `TextFormField` readOnly, `DropdownButtonFormField`) a gestire da sola cosa mostrare a schermo, mentre il valore "logico" (quello valido/non valido) vive comunque nel Cubit tramite `onChanged`/`onSelected`.

Questo spiega anche perché nel tuo widget usi le `Key` (`_professoreKey`, `_amministratoreKey`): quando chiami `resetForm()`, lo `state.selectedProfessorId` torna a `TextInput.pure()`, ma l'`Autocomplete` **non ridisegna il proprio `TextEditingController` interno da solo** (Formz non tocca i widget Flutter direttamente!). Per questo forzi un remount del widget con `UniqueKey()`, l'unico modo per "pulire" visivamente un `Autocomplete` che tiene il proprio controller interno.

---

## 6. Riepilogo per ogni campo del tuo form

| Campo UI | Widget | FormzInput nello state | Come arriva il valore | Note |
|---|---|---|---|---|
| Nome procedura | `CommonInputField` | `TextInput title` | `onChanged` → `titleChanged` | controller interno al widget, solo per il testo |
| Tipo procedura | `CommonDropdownField` | `TextInput procedureType` | `onChanged` → `procedureTypeChanged` | mappa "Beni di consumo"/"Attrezzature" → stringa backend prima di creare `.dirty()` |
| Professore | `CommonAutocompleteField` | `TextInput selectedProfessorId` | `onChanged`/`onSelected` → `professorChanged` | il valore salvato è il **nome visualizzato**, non un vero id — l'id reale viene recuperato solo al submit cercando nella lista `state.professors` |
| Amministratore | `CommonAutocompleteField` | `TextInput selectedAdministratorId` | idem | idem |
| Importo | `NumericField` | `AmountInput amount` | `onChanged` → `amountChanged` | unico campo con 3 tipi di errore invece di 1 |
| Deadline | `DateInputField` | `TextInput deadline` | callback manuale dentro `_selectDate` → `deadlineChanged` | non è un vero `onChanged` di `TextFormField` (il campo è `readOnly`), viene chiamato "a mano" dopo la scelta nel date picker |

---

## 7. Un dettaglio che ti è già "morso": `status` non è gestito da Formz

Formz valida **i campi del form**, ma non ha nulla a che vedere con `ProcedureStatus` (`loadingInitial`, `submitting`, `success`, `error`). Quello è puro state management "manuale" tuo, nello stesso `copyWith`. È per questo che il bug di prima (SnackBar che ricompariva a ogni lettera) non aveva nulla a che fare con Formz — Formz stava facendo esattamente il suo lavoro (validare i campi), il problema era che `status` restava "congelato" su `error` nei metodi `xChanged` finché non hai iniziato a resettarlo esplicitamente con `status: ProcedureStatus.initial`.

---

## 8. In breve

- **Formz = valore + validità in un solo oggetto immutabile**, per ogni campo.
- **`pure` vs `dirty`** controlla solo *quando mostrare* l'errore (`displayError`), non se il campo è valido.
- **`Formz.validate([...])`** aggrega la validità di più campi in un solo booleano (`isValid`), che tu salvi tu stesso nello state dopo ogni modifica.
- **La UI non valida nulla**: legge solo `displayError` e `isValid` dallo state, e delega ogni cambiamento al Cubit tramite `onChanged`.
- **I controller `TextEditingController` non sono spariti** nei widget più "custom" (autocomplete, date, numeric) — convivono con Formz, ma gestiscono solo la rappresentazione visiva, non la validità logica.