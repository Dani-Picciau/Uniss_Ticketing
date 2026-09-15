import 'package:ticketing_webapp/ui/components/common_input_field/utils/form_inputs.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/models/ui_model/user_ui_model.dart';

enum ReassignStatus { loadingInitial, initial, submitting, success, error }

class ReassignState {
  final List<UserUiModel> assignedAdministrator;
  final ReassignStatus status;
  final String? errorMessage;

  // Campo per la validazione del form
  final TextInput selectedAdministratorName;
  final bool isValid;

  const ReassignState({
    this.assignedAdministrator = const [],
    this.status = ReassignStatus.loadingInitial,
    this.errorMessage,

    this.selectedAdministratorName = const TextInput.pure(),
    this.isValid = false,
  });

  ReassignState copyWith({
    ReassignStatus? status,
    String? errorMessage,
    List<UserUiModel>? assignedAdministrator,

    TextInput? selectedAdministratorName,
    bool? isValid,
  }) {
    return ReassignState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      assignedAdministrator:
          assignedAdministrator ?? this.assignedAdministrator,
      selectedAdministratorName:
          selectedAdministratorName ?? this.selectedAdministratorName,
      isValid: isValid ?? this.isValid,
    );
  }
}
