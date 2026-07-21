// Definiamo le fasi specifiche di questo form
enum ProcedureStatus {
  loadingInitial, // Sto scaricando i professori dal DB
  initial, // Dati pronti, l'utente sta compilando il form
  submitting, // L'utente ha premuto "Salva", sto inviando i dati
  success, // Procedura salvata con successo
  error, // Errore di rete (sia in download che in upload)
}

class NewProcedureState {
  final ProcedureStatus status;
  final List<String> professori; // La lista che popolerà l'Autocomplete
  final String? errorMessage;

  const NewProcedureState({
    this.status = ProcedureStatus.loadingInitial, // Partiamo bloccando la UI
    this.professori = const [],
    this.errorMessage,
  });

  NewProcedureState copyWith({
    ProcedureStatus? status,
    List<String>? professori,
    String? errorMessage,
  }) {
    return NewProcedureState(
      status: status ?? this.status,
      professori: professori ?? this.professori,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
