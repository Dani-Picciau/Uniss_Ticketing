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
  final List<String> professors; // La lista che popolerà l'Autocomplete
  final List<String>
  assignedAdministrator; // La lista che popolerà l'Autocomplete
  final String? errorMessage;

  const NewProcedureState({
    this.status = ProcedureStatus.loadingInitial, // Lo stato "loginInitial" permette di bloccare la UI
    this.professors = const [],
    this.assignedAdministrator = const [],
    this.errorMessage,
  });

  NewProcedureState copyWith({
    ProcedureStatus? status,
    List<String>? professors,
    List<String>? assignedAdministrator,
    String? errorMessage,
  }) {
    return NewProcedureState(
      status: status ?? this.status,
      professors: professors ?? this.professors,
      assignedAdministrator:
          assignedAdministrator ?? this.assignedAdministrator,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
