import 'package:equatable/equatable.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/utils/form_inputs.dart';
import 'package:ticketing_webapp/ui/scenes/models/requests/professor_request_summary.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/models/ui_model/user_ui_model.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/procedure_summary/procedure_summary.dart';

enum ProcedureStatus { loadingInitial, initial, submitting, success, error }

class NewProcedureState extends Equatable {
  final ProcedureStatus status;
  final String? errorMessage;

  final List<UserUiModel> professors;
  final List<UserUiModel> assignedAdministrator;

  // Le "Nuove borse" già esistenti, da proporre come rinnovabili.
  // Riusa lo stesso modello (ProcedureSummary) già usato nella lista delle
  // procedure aperte — stesso dato, stesso tipo di chiamata leggera.
  final List<ProcedureSummary> renewableScholarships;

  // Campi per la validazione del form
  final TextInput title;
  final AmountInput amount;
  final AmountInput duration;
  final TextInput deadline;
  final TextInput procedureType;
  final TextInput selectedProfessorId;
  final TextInput selectedAdministratorId;
  final TextInput selectedRenewalProcedureId;
  final TextInput startDate;
  final TextInput scholarshipHolder;
  final bool isValid; // Indica se tutti i capi sono compilati e corretti

  final List<ProfessorRequestSummary> pendingRequests;
  final TextInput selectedPendingRequestId;

  const NewProcedureState({
    this.status = ProcedureStatus.loadingInitial,
    this.errorMessage,
    this.professors = const [],
    this.assignedAdministrator = const [],
    this.renewableScholarships = const [],
    this.title = const TextInput.pure(),
    this.amount = const AmountInput.pure(),
    this.duration = const AmountInput.pure(),
    this.deadline = const TextInput.pure(),
    this.procedureType = const TextInput.pure(),
    this.selectedProfessorId = const TextInput.pure(),
    this.selectedAdministratorId = const TextInput.pure(),
    this.selectedRenewalProcedureId = const TextInput.pure(),
    this.startDate = const TextInput.pure(),
    this.scholarshipHolder = const TextInput.pure(),
    this.isValid = false,

    this.pendingRequests = const [],
    this.selectedPendingRequestId = const TextInput.pure(),
  });

  NewProcedureState copyWith({
    ProcedureStatus? status,
    String? errorMessage,
    List<UserUiModel>? professors,
    List<UserUiModel>? assignedAdministrator,
    List<ProcedureSummary>? renewableScholarships,
    TextInput? title,
    AmountInput? amount,
    AmountInput? duration,
    TextInput? deadline,
    TextInput? procedureType,
    TextInput? selectedProfessorId,
    TextInput? selectedAdministratorId,
    TextInput? selectedRenewalProcedureId,
    TextInput? startDate,
    TextInput? scholarshipHolder,
    bool? isValid,

    List<ProfessorRequestSummary>? pendingRequests,
    TextInput? selectedPendingRequestId,
  }) {
    return NewProcedureState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      professors: professors ?? this.professors,
      assignedAdministrator:
          assignedAdministrator ?? this.assignedAdministrator,
      renewableScholarships:
          renewableScholarships ?? this.renewableScholarships,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      duration: duration ?? this.duration,
      deadline: deadline ?? this.deadline,
      procedureType: procedureType ?? this.procedureType,
      selectedProfessorId: selectedProfessorId ?? this.selectedProfessorId,
      selectedAdministratorId:
          selectedAdministratorId ?? this.selectedAdministratorId,
      selectedRenewalProcedureId:
          selectedRenewalProcedureId ?? this.selectedRenewalProcedureId,
      startDate: startDate ?? this.startDate,
      scholarshipHolder: scholarshipHolder ?? this.scholarshipHolder,
      isValid: isValid ?? this.isValid,

      pendingRequests: pendingRequests ?? this.pendingRequests,
      selectedPendingRequestId:
          selectedPendingRequestId ?? this.selectedPendingRequestId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    professors,
    assignedAdministrator,
    renewableScholarships,
    title,
    amount,
    duration,
    deadline,
    procedureType,
    selectedProfessorId,
    selectedAdministratorId,
    selectedRenewalProcedureId,
    startDate,
    scholarshipHolder,
    isValid,

    pendingRequests,
    selectedPendingRequestId,
  ];
}
