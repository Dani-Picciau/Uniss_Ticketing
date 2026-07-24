import 'package:equatable/equatable.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/utils/form_inputs.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/ui_model/user_ui_model.dart';

enum ProcedureStatus { loadingInitial, initial, submitting, success, error }

class NewProcedureState extends Equatable {
  final ProcedureStatus status;
  final String? errorMessage;

  final List<UserUiModel> professors;
  final List<UserUiModel> assignedAdministrator;

  // Campi per la validazione del form
  final TextInput title;
  final AmountInput amount;
  final TextInput deadline;
  final TextInput procedureType;
  final TextInput selectedProfessorId;
  final TextInput selectedAdministratorId;
  final bool isValid; // Indica se tutti i capi sono compilati e corretti

  const NewProcedureState({
    this.status = ProcedureStatus.loadingInitial,
    this.errorMessage,
    this.professors = const [],
    this.assignedAdministrator = const [],

    this.title = const TextInput.pure(),
    this.amount = const AmountInput.pure(),
    this.deadline = const TextInput.pure(),
    this.procedureType = const TextInput.pure(),
    this.selectedProfessorId = const TextInput.pure(),
    this.selectedAdministratorId = const TextInput.pure(),
    this.isValid = false,
  });

  NewProcedureState copyWith({
    ProcedureStatus? status,
    String? errorMessage,
    List<UserUiModel>? professors,
    List<UserUiModel>? assignedAdministrator,
    TextInput? title,
    AmountInput? amount,
    TextInput? deadline,
    TextInput? procedureType,
    TextInput? selectedProfessorId,
    TextInput? selectedAdministratorId,
    bool? isValid,
  }) {
    return NewProcedureState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      professors: professors ?? this.professors,
      assignedAdministrator:
          assignedAdministrator ?? this.assignedAdministrator,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      deadline: deadline ?? this.deadline,
      procedureType: procedureType ?? this.procedureType,
      selectedProfessorId: selectedProfessorId ?? this.selectedProfessorId,
      selectedAdministratorId:
          selectedAdministratorId ?? this.selectedAdministratorId,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    professors,
    assignedAdministrator,
    title,
    amount,
    deadline,
    procedureType,
    selectedProfessorId,
    selectedAdministratorId,
    isValid,
  ];
}
