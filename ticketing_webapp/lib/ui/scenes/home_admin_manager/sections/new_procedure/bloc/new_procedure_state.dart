import 'package:equatable/equatable.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/ui_model/user_ui_model.dart';

enum ProcedureStatus {
  loadingInitial, // Sto scaricando i professori dal DB
  initial, // Dati pronti, l'utente sta compilando il form
  submitting, // L'utente ha premuto "Salva", sto inviando i dati
  success, // Procedura salvata con successo
  error, // Errore di rete (sia in download che in upload)
}

class NewProcedureState extends Equatable {
  final ProcedureStatus status;
  final List<UserUiModel> professors;
  final List<UserUiModel> assignedAdministrator;
  final String? selectedProfessorId;
  final String? selectedAdministratorId;
  final String? errorMessage;

  const NewProcedureState({
    this.status = ProcedureStatus
        .loadingInitial, // Lo stato "loginInitial" permette di bloccare la UI
    this.professors = const [],
    this.assignedAdministrator = const [],
    this.selectedAdministratorId,
    this.selectedProfessorId,
    this.errorMessage,
  });

  NewProcedureState copyWith({
    ProcedureStatus? status,
    List<UserUiModel>? professors,
    List<UserUiModel>? assignedAdministrator,
    String? selectedProfessorId,
    String? selectedAdministratorId,
    String? errorMessage,
  }) {
    return NewProcedureState(
      status: status ?? this.status,
      professors: professors ?? this.professors,
      assignedAdministrator:
          assignedAdministrator ?? this.assignedAdministrator,
      selectedProfessorId: selectedProfessorId ?? this.selectedProfessorId,
      selectedAdministratorId:
          selectedAdministratorId ?? this.selectedAdministratorId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    professors,
    assignedAdministrator,
    errorMessage,
    selectedProfessorId,
    selectedAdministratorId,
  ];
}
