# Funzionamento del Livello Data e di Dio

Questo documento spiega come l'applicazione Flutter comunica con il backend (Spring Boot) per gestire l'autenticazione, senza mai connettersi direttamente al database MongoDB.

## Architettura del Livello `data`

Il livello dati è diviso in tre componenti principali, che lavorano a cascata:

### 1. `ApiClient` (Il Motore di Rete)
È il cuore della comunicazione HTTP. 
- Utilizza la libreria **Dio** per gestire tutte le chiamate in uscita verso Spring Boot.
- Configura le regole di base: l'URL del server (`ApiConstants.baseUrl`), i tempi massimi di attesa (timeout) e imposta che ci aspettiamo sempre risposte in formato JSON.
- **L'Interceptor:** È la funzione più potente di questo livello. Funge da "dogana". Ogni volta che l'app effettua una chiamata a Spring Boot, l'interceptor si attiva in automatico, va a cercare se nel "caveau" del dispositivo (`flutter_secure_storage`) c'è un token JWT e, in caso affermativo, lo attacca alla chiamata (`Authorization: Bearer <token>`).

### 2. `AuthApi` (Il Servizio Specifico)
Mentre l'`ApiClient` è generico, l'`AuthApi` fa un lavoro specifico: il login.
- Riceve le credenziali dal Cubit e usa l'`ApiClient` per instradarle verso l'indirizzo esatto (`/api/auth/login`).
- Se il server risponde con successo, estrae il token dal JSON e lo salva nella memoria sicura del dispositivo.
- Se il server risponde con un errore (es. password errata), trasforma il codice di errore HTTP in un'eccezione chiara e gestibile in Dart (`AuthException`).

### 3. `AuthResult` (Il Modello Dati)
I dati in arrivo da Spring Boot viaggiano come stringhe di testo (JSON). L'`AuthResult` è lo "stampo" che prende queste stringhe e le trasforma in un oggetto Dart formattato in modo rigoroso, garantendo che l'interfaccia utente (UI) sappia sempre esattamente quali dati ha a disposizione (es. `userId`, `role`).

## Riepilogo del Flusso (No connessione diretta al DB)

Come principio fondamentale di sicurezza e architettura, l'app Flutter non sa nulla di MongoDB.
1. L'utente preme "Accedi" sulla UI.
2. Flutter passa i dati a **Dio**, che li invia tramite rete a **Spring Boot**.
3. Spring Boot interroga il database **MongoDB**, valida i dati e genera un lasciapassare (Token).
4. Spring Boot invia il Token indietro a Dio, che lo passa a Flutter per sbloccare l'app.
