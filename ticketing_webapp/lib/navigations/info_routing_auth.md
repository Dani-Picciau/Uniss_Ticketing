# Come funzionano insieme go_router, AuthCubit e il flusso di login

Questo documento spiega quali file sono stati aggiunti/modificati per far funzionare go_router con reindirizzamento automatico basato sull'autenticazione, e come comunicano tra loro.

## 0. Chi c'entra col routing e chi no

Dei file che mi hai mandato in questo giro:

- **`app_router.dart`** — nuovo, è il router vero e proprio.
- **`auth_cubit.dart` / `auth_state.dart`** — nuovi, sono l'"identità condivisa" che il router legge per decidere dove mandarti.
- **`login_response.dart`** — modificato: prima aveva `role` (singolare, una stringa) e `displayName`; ora ha `roles` (plurale, una lista) e campi separati `title`/`name`/`surname`. Il cambio a `roles` come lista è necessario proprio per il router, che deve poter controllare "questo utente ha il ruolo RUP?" (`roles.contains('ROLE_RUP')`).
- **`login_cubit.dart` / `login_state.dart` / `login_screen.dart`** — modificati, ma la parte "nuova per il routing" è solo il collegamento a `AuthCubit`. Il resto (validazione campi vuoti, gestione errori) è la stessa logica di sempre.
- **`auth_api.dart`** — modificato per salvare il token tramite `SessionManager`, ma questo non è direttamente collegato al routing — è un dettaglio di persistenza, indipendente da go_router.

L'idea centrale da tenere a mente: **il router non naviga mai "a comando"**, tipo `Navigator.push`. Osserva costantemente `AuthCubit`, e ricalcola da solo dove dovresti trovarti ogni volta che quello stato cambia. Tutto il resto di questo documento spiega come si arriva a quel cambiamento di stato, e cosa il router ne fa.

---

## 1. Il quadro generale, in breve

```
Utente digita email/password
        │
        ▼
LoginCubit.login()  ──chiama──▶  AuthApi.login()  ──chiama──▶  backend
        │                                                          │
        │                                                    risposta JSON
        │                                                          │
        │◀──────────────────── LoginResponse ─────────────────────┘
        │
        ├──▶ AuthCubit.setAuthenticatedUser(result)   ← QUESTO è il passaggio chiave
        │         │
        │         ▼
        │    AuthCubit emette un nuovo AuthState (status: authenticated)
        │         │
        │         ▼
        │    GoRouterRefreshStream sente il cambiamento → notifica GoRouter
        │         │
        │         ▼
        │    GoRouter richiama redirect() da solo, senza che nessuno gliel'abbia chiesto
        │         │
        │         ▼
        │    redirect() legge authCubit.state → decide la rotta giusta → naviga
        │
        └──▶ LoginCubit emette anche il proprio stato (status: success/error/warning)
                  → login_screen.dart lo usa SOLO per mostrare errori/warning,
                    MAI per navigare
```

Il punto probabilmente più sorprendente, se vieni dalla versione precedente: **`login_screen.dart` non contiene più nessuna chiamata a `Navigator` per andare alla dashboard**. Prima, il `listener` di `BlocConsumer` faceva `Navigator.pushReplacement(...)` quando `state.status == LoginStatus.success`. Ora quel caso è sparito dal listener — perché la navigazione non è più responsabilità di `LoginScreen`: è una conseguenza automatica del cambiamento di `AuthCubit`, gestita interamente dal router.

---

## 2. `auth_state.dart` e `auth_cubit.dart` — l'identità condivisa

```dart
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final LoginResponse? user;

  const AuthState({this.status = AuthStatus.unknown, this.user});
  ...
}
```

Tre stati, non due — e la presenza di `unknown` (invece di partire direttamente da `unauthenticated`) è deliberata: rappresenta "non ho ancora controllato se questo utente è già loggato da una sessione precedente" (es. token salvato da un accesso di ieri). Se partissi da `unauthenticated`, il redirect manderebbe l'utente al login anche se ha già un token valido salvato, prima ancora di aver avuto la possibilità di verificarlo. **Nota**: dal codice che ho visto, non c'è ancora nessun controllo automatico all'avvio dell'app che tenti di leggere un token salvato e portare lo stato a `authenticated` di conseguenza — `unknown` esiste concettualmente nell'enum, ma nulla lo fa evolvere automaticamente verso gli altri due stati all'avvio. È un pezzo mancante, non un bug: se vuoi il "resta loggato" tra un riavvio e l'altro dell'app, è il prossimo passo naturale.

```dart
class AuthCubit extends Cubit<AuthState> {
  final AuthApi _authApi;

  void setAuthenticatedUser(LoginResponse user) {
    emit(state.copyWith(status: AuthStatus.authenticated, user: user));
  }

  Future<void> logout() async {
    await _authApi.logout();
    emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
  }
}
```

Due soli metodi, entrambi con un unico compito: aggiornare "chi sono e se lo sono". `setAuthenticatedUser` non fa nessuna chiamata di rete — riceve un `LoginResponse` già pronto (creato da qualcun altro, vedi sezione 4) e si limita a registrarlo. `logout()` invece fa lui stesso il lavoro di cancellare il token (`_authApi.logout()`) prima di aggiornare lo stato — coerente: chi disconnette deve anche occuparsi di ripulire cosa resta salvato.

Questo Cubit va fornito **alla radice dell'app** (sopra `MaterialApp`/`MaterialApp.router`) — esattamente come discusso a suo tempo per `ThemeCubit` — perché sia `LoginScreen` sia il router stesso devono poterlo leggere, e nessuno dei due deve essere "genitore" dell'altro.

---

## 3. `login_response.dart` — perché ha questa forma

```dart
const factory LoginResponse({
  required String token,
  required String userId,
  required List<String> roles,
  required String title,
  required String name,
  required String surname,
}) = _LoginResponse;
```

`roles` come `List<String>` (non una singola stringa) è il campo che rende possibile lo smistamento nel `redirect` — un utente potrebbe teoricamente avere più ruoli, e il router controlla `roles.contains('ROLE_RUP')` piuttosto che un confronto di uguaglianza secco. `title`/`name`/`surname` separati (al posto di un `displayName` già composto) spostano la responsabilità di *comporre* il nome visualizzato fuori da questo modello — probabilmente dentro un `UiModel` dedicato (coerente con `AdminManagerUiModel` che avevamo visto), lasciando questo modello a rappresentare solo il dato grezzo così come arriva dal backend.

---

## 4. `login_cubit.dart` — il cambiamento chiave

```dart
class LoginCubit extends Cubit<LoginState> {
  final AuthApi _authApi;
  final AuthCubit _authCubit;   // ← nuovo

  Future<void> login(String email, String password) async {
    ...
    final result = await _authApi.login(email, password);

    _authCubit.setAuthenticatedUser(result);   // ← la riga che fa scattare tutto

    emit(state.copyWith(status: LoginStatus.success));
  }
}
```

`LoginCubit` ora riceve **anche** `AuthCubit` nel costruttore, non solo `AuthApi`. Dopo un login riuscito, fa **due cose distinte**, non una:

1. `_authCubit.setAuthenticatedUser(result)` — comunica all'esterno "questo è l'utente loggato ora", il dato che serve al router e a qualunque altra schermata.
2. `emit(state.copyWith(status: LoginStatus.success))` — aggiorna il **proprio** stato locale, che serve solo a `login_screen.dart` per sapere che il tentativo è concluso con successo (utile, ad esempio, per smettere di mostrare lo spinner — anche se qui, dato che subito dopo si naviga via, l'effetto pratico è minimo).

Perché due Cubit invece di uno solo che fa tutto? Perché rispondono a domande diverse, con cicli di vita diversi: `LoginCubit` esiste solo mentre sei sulla schermata di login (nasce e muore con essa); `AuthCubit` esiste per tutta la durata della sessione dell'app, ben oltre la vita di `LoginScreen`. Se `LoginCubit` tenesse lui stesso il dato dell'utente, quel dato sparirebbe nel momento stesso in cui navighi via dal login — esattamente il problema che avevamo diagnosticato qualche scambio fa con `AdminManagerScreen`.

`login_state.dart` e `login_screen.dart` non hanno altri cambiamenti concettualmente rilevanti per il routing: `login_screen.dart` ora costruisce `LoginCubit` leggendo sia `AuthApi` sia `AuthCubit` dal contesto (`context.read<AuthApi>()`, `context.read<AuthCubit>()`) — il che significa che entrambi devono essere già stati forniti più in alto nell'albero (in `main.dart`, presumibilmente, anche se non l'ho visto) — e il suo `listener` non gestisce più il caso `success` per navigare, solo `error`/`warning` per gli snackbar.

---

## 5. `app_router.dart` — il pezzo nuovo

### 5.1 La struttura base

```dart
class AppRouter {
  final AuthCubit authCubit;
  AppRouter(this.authCubit);

  late final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/rup-dashboard', builder: (context, state) => AdminManagerScreen(loginResponse: authCubit.state.user!)),
      GoRoute(path: '/professor-dashboard', builder: (context, state) => RequestingProfessorScreen()),
      GoRoute(path: '/administrator-dashboard', builder: (context, state) => AssignedAdministratorScreen()),
    ],
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) { ... },
  );
}
```

Rispetto alla versione precedente, ora **tutte** le dashboard hanno una `GoRoute` registrata — il buco che segnalavo (`/professor-dashboard` mancante) è stato chiuso, e nel frattempo è arrivata anche `/administrator-dashboard`. `AppRouter` riceve `authCubit` nel costruttore e lo tiene per tutta la sua vita — sia le `routes` (per costruire le schermate con i dati giusti) sia `redirect` (per decidere dove mandare l'utente) leggono da questa stessa istanza condivisa.

Nota su `AdminManagerScreen(loginResponse: authCubit.state.user!)`: qui c'è il punto esclamativo (`!`), che dice "sono sicuro che non sia null". Questa è una promessa che regge **solo se** il `redirect` (sezione 5.3) garantisce che non si arrivi mai a costruire questa rotta se `authCubit.state.user` è `null`. È un'invariante implicita tra due parti di codice diverse — se in futuro cambi la logica del redirect senza tenerne conto, questo `!` potrebbe far crashare l'app con un errore a runtime invece di un problema visibile prima. Da tenere d'occhio, non è un errore ora, ma è un punto fragile.

**Confermato** (prima era solo un'ipotesi): `AdminManagerScreen` — che in realtà vive nel file `rup_user_screen.dart`, con un piccolo disallineamento tra nome del file e nome della classe, utile da sistemare quando ci ripassi — riceve `loginResponse` nel costruttore e lo passa immediatamente al proprio Cubit:

```dart
BlocProvider(
  create: (context) => AdminManagerCubit()..loadUserData(loginResponse),
  ...
)
```

Il discorso rimasto aperto per un po' ("chi chiama `loadUserData`?") è quindi definitivamente risolto: lo chiama il costruttore della schermata stessa, non appena viene creata dal router, usando il dato che il router gli ha passato.

### 5.2 `GoRouterRefreshStream` — il traduttore tra Cubit e GoRouter

```dart
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
```

Questa classe esiste per risolvere un problema di "incompatibilità di linguaggio" tra due mondi: `GoRouter.refreshListenable` vuole ricevere un `Listenable` (l'interfaccia di Flutter usata da `ChangeNotifier`, con un metodo `notifyListeners()`), ma `AuthCubit.stream` è uno `Stream` (l'interfaccia standard di Dart per sequenze asincrone di eventi) — due tipi diversi, che Flutter non sa collegare da solo.

`GoRouterRefreshStream` fa da ponte: **estende `ChangeNotifier`** (così GoRouter può trattarlo come un `Listenable`) e **si iscrive allo `Stream`** del Cubit che gli viene passato. Ogni volta che quello stream emette un nuovo stato (cioè: ogni volta che `AuthCubit.emit(...)` viene chiamato, in `setAuthenticatedUser` o `logout`), la callback `(_) => notifyListeners()` scatta, e quel `notifyListeners()` è il segnale che GoRouter stava aspettando per dire "qualcosa è cambiato, rivaluta se sono ancora nella rotta giusta".

Il `notifyListeners()` chiamato subito nel costruttore (prima ancora di ricevere il primo evento dallo stream) serve a far sì che GoRouter valuti il `redirect` **almeno una volta all'avvio dell'app**, e non solo dopo il primo cambiamento di stato — altrimenti, con lo stato iniziale `unknown`, l'app potrebbe mostrare per un istante una schermata sbagliata prima del primo controllo.

`asBroadcastStream()`: gli `Stream` di un Cubit sono normalmente "a singolo ascoltatore" — una volta che qualcuno vi si iscrive, un secondo tentativo di iscrizione darebbe errore. `asBroadcastStream()` lo trasforma in un tipo che permette più ascoltatori contemporaneamente, il che ha senso qui perché il widget `BlocProvider`/`BlocBuilder` che userai altrove nell'app *si iscrivono già* allo stesso Cubit — questo evita conflitti tra le due iscrizioni parallele.

### 5.3 `redirect` — la logica di smistamento, riga per riga

```dart
redirect: (BuildContext context, GoRouterState state) {
  final authState = authCubit.state;
  final isGoingToLogin = state.uri.toString() == '/login';

  if (authState.status != AuthStatus.authenticated && !isGoingToLogin) {
    return '/login';
  }

  if (authState.status == AuthStatus.authenticated && isGoingToLogin) {
    final roles = authState.user?.roles ?? [];
    if (roles.contains('RUP')) {
      return '/rup-dashboard';
    } else if (roles.contains('DIRETTORE')) {
      return '/login'; // Ancora da definire
    } else if (roles.contains('DOCENTE_RICHIEDENTE')) {
      return '/professor-dashboard';
    } else if (roles.contains('AMMINISTRATORE_ASSEGNATO')) {
      return '/administrator-dashboard';
    } else {
      return '/login'; // Fallback di default
    }
  }

  return null;
}
```

Nota che le stringhe dei ruoli sono cambiate rispetto a prima (`'RUP'`, `'DOCENTE_RICHIEDENTE'`, `'AMMINISTRATORE_ASSEGNATO'`, invece dei precedenti `'ROLE_RUP'`/`'ROLE_PROFESSOR'`) — presumibilmente per farle coincidere esattamente con le stringhe che arrivano dal backend Java. Vale la pena controllare che coincidano davvero carattere per carattere: un confronto `roles.contains(...)` che non trova corrispondenza esatta cade silenziosamente nel fallback, senza nessun errore visibile — lo stesso tipo di rischio "silenzioso" degli id disallineati che avevamo visto nel side menu.

Questa funzione viene richiamata da GoRouter **prima di ogni navigazione** — sia quando l'utente clicca qualcosa nell'app, sia quando cambi manualmente l'URL nella barra degli indirizzi (rilevante soprattutto per Flutter Web), sia ogni volta che `GoRouterRefreshStream` notifica un cambiamento (sezione 5.2). Il valore che ritorna dice a GoRouter cosa fare:

- **`return '/login'` / `return '/rup-dashboard'`**: "vai lì invece", forza un redirect.
- **`return null`**: "va bene così, non serve cambiare nulla", lascia proseguire la navigazione originale.

**Primo blocco**: se l'utente **non è autenticato** e **non sta già andando al login**, forza il redirect a `/login`. Questo è il guardiano contro i tentativi di aprire un URL protetto a mano (es. digitare `/rup-dashboard` nella barra degli indirizzi senza aver fatto login) — esattamente il caso che il commento nel codice descrive.

**Secondo blocco**: se l'utente **è autenticato** ma **sta cercando di andare al login** (es. ha già fatto login, ma clicca "indietro" nel browser, o l'URL iniziale è ancora `/login`), lo rimanda invece alla dashboard giusta in base al ruolo. Da notare: questo controllo scatta *solo* se `isGoingToLogin` — un utente autenticato che sta navigando altrove (non verso `/login`) non viene toccato da questo blocco, il che è corretto: non ha senso "correggere" una navigazione che non ha nulla a che fare col login.

### Due cose emerse controllando la versione aggiornata

**1. Il ruolo `DIRETTORE` non ha ancora una vera destinazione** — torna a `/login`, con il commento onesto `// Ancora da definire` lasciato nel codice. Non è un bug (nessun crash, nessuna rotta mancante), ma è un caso in cui un utente autenticato con *solo* questo ruolo si ritroverebbe bloccato sulla schermata di login, senza nessun messaggio che gli spieghi perché — probabilmente da affrontare quando la dashboard per quel ruolo esisterà.

**2. Il fallback finale è cambiato da `/rup-dashboard` a `/login`**. Prima, un ruolo non riconosciuto finiva (probabilmente per errore) sulla dashboard del RUP; ora finisce di nuovo sul login. È più prudente come comportamento (non mostri per sbaglio la dashboard di qualcun altro a chi non dovrebbe vederla), ma vale la pena essere consapevoli che, di fatto, produce lo stesso "vicolo cieco silenzioso" del caso `DIRETTORE`: l'utente resta bloccato senza spiegazioni.

### ✅ L'inconsistenza in `rup_user_screen.dart` — risolta

Il `listener` di `AdminManagerScreen` tornava al login con `Navigator.pushReplacement` diretto, bypassando completamente `AuthCubit` e `go_router`:

```dart
// PRIMA — bypassava AuthCubit e go_router
listener: (context, state) {
  if (state.status == AdminStatus.error) {
    ScaffoldMessenger.of(context).showSnackBar(...);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
},
```

Il fix applicato: sostituire la navigazione manuale con un aggiornamento di `AuthCubit`, lasciando che sia il router a reagire da solo — lo stesso identico meccanismo automatico già usato per l'accesso, semplicemente innescato da un punto diverso dell'app:

```dart
// DOPO — aggiorna solo AuthCubit, il router fa il resto
listener: (context, state) {
  if (state.status == AdminStatus.error) {
    ScaffoldMessenger.of(context).showSnackBar(...);
    context.read<AuthCubit>().logout();
  }
},
```

La cascata che segue è identica a quella del logout "vero" descritto nella sezione 6: `logout()` cancella il token ed emette `unauthenticated` → lo stream lo notifica a `GoRouterRefreshStream` → `redirect` viene rivalutato → vede un utente non autenticato che non sta già andando al login → forza `/login`. Con questa correzione, **ogni** cambio di schermata legato all'autenticazione nell'app passa da `AuthCubit`, senza eccezioni — nessun punto del codice chiama più `Navigator` direttamente per questo scopo.

Un punto lasciato aperto deliberatamente, da valutare più avanti: il messaggio mostrato ("Sessione scaduta o errore di rete") tratta come identici due casi diversi — una sessione davvero scaduta (per cui il logout ha senso) e un errore di rete transitorio (per cui forse converrebbe solo un tasto "riprova", senza buttare fuori l'utente). Se `AdminManagerCubit` arriverà a distinguere questi due casi con stati diversi, andrebbe rivista anche questa parte.

---

## 6. Il flusso di logout, per completezza

Non l'ho visto attivato da nessuna parte nei file che mi hai mandato (nessun bottone "Esci" collegato), ma vale la pena sapere come si incastrerebbe: qualcosa chiamerebbe `context.read<AuthCubit>().logout()` → `AuthCubit` cancella il token e emette `status: unauthenticated` → lo stream lo notifica a `GoRouterRefreshStream` → GoRouter rivaluta `redirect` → primo blocco: non autenticato e non sta andando al login → forza `/login`. Nessuna chiamata esplicita a `Navigator` da nessuna parte: lo stesso identico meccanismo automatico dell'accesso, semplicemente al contrario.

---

## Riassumendo in una frase

`AuthCubit` è l'unica fonte di verità su "chi sono e se sono autenticato" (esattamente come `ThemeCubit` lo è per il tema); `GoRouterRefreshStream` traduce i suoi cambiamenti di stato in un segnale che GoRouter sa ascoltare; `redirect` legge quello stato ogni volta che viene interpellato e decide la rotta corretta; e nessuna schermata (incluso `LoginScreen`) naviga più "a comando" — si limita ad aggiornare `AuthCubit`, e il router fa il resto.
