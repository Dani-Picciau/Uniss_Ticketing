import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ticketing_webapp/features/repositories/procedure_api.dart';
import 'package:ticketing_webapp/features/repositories/professor_request_api.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/utils/form_inputs.dart';
import 'package:ticketing_webapp/ui/components/overlay_confirm_message/bloc/reassign_state.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/models/ui_model/user_ui_model.dart';

class ReassignCubit extends Cubit<ReassignState> {
  final ProcedureApi _procedureApi;
  final ProfessorRequestApi _professorRequestApi;

  ReassignCubit({
    required ProcedureApi procedureApi,
    required ProfessorRequestApi professorRequestApi,
  }) : _procedureApi = procedureApi,
       _professorRequestApi = professorRequestApi,
       super(const ReassignState());

  Future<void> fetchAdministrators() async {
    try {
      final rawAdministrators = await _procedureApi.getAssignedAdministrator();
      final administratorsUiList = rawAdministrators
          .map((a) => UserUiModel.fromAdministrator(a))
          .toList();
      // Passiamo alla UI i dati formattati
      emit(
        state.copyWith(
          status: ReassignStatus.initial,
          assignedAdministrator: administratorsUiList,
        ),
      );
    } on ProcedureException catch (e) {
      emit(
        state.copyWith(status: ReassignStatus.error, errorMessage: e.message),
      );
    } catch (e) {
      // Fallback per errori generici non previsti
      emit(
        state.copyWith(
          status: ReassignStatus.error,
          errorMessage: 'Errore critico durante l\'inizializzazione.',
        ),
      );
    }
  }

  // Passiamo l'ID della richiesta o della procedura
  Future submitReassignment(String targetId, bool isProcedure) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: ReassignStatus.submitting));

    try {
      final selectedName = state.selectedAdministratorName.value;

      final adminMatch = state.assignedAdministrator
          .where((admin) => admin.displayName == selectedName)
          .firstOrNull;

      if (adminMatch == null) {
        emit(
          state.copyWith(
            status: ReassignStatus.error,
            errorMessage: 'Seleziona un amministratore valido dalla lista.',
          ),
        );
        return;
      }

      if (isProcedure) {
        //usiamo la stessa funzione per decidere se la riassegnazione coinvolge una richiesta o una procedura
        await _procedureApi.assignProcedureToAdmin(targetId, adminMatch.id);
      } else {
        // Usa l'API delle richieste
        await _professorRequestApi.assignRequestToAdmin(
          targetId,
          adminMatch.id,
        );
      }

      emit(state.copyWith(status: ReassignStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: ReassignStatus.error,
          errorMessage: 'Errore durante la riassegnazione: $e',
        ),
      );
    }
  }

  //=====================================================

  List<FormzInput> _fieldsToValidate({TextInput? selectedAdministratorId}) {
    return [selectedAdministratorId ?? state.selectedAdministratorName];
  }

  void administratorChanged(String name) {
    final admin = TextInput.dirty(name);
    emit(
      state.copyWith(
        status: ReassignStatus.initial,
        selectedAdministratorName: admin,
        isValid: Formz.validate(
          _fieldsToValidate(selectedAdministratorId: admin),
        ),
      ),
    );
  }

  void resetForm() {
    emit(
      state.copyWith(
        selectedAdministratorName: const TextInput.pure(),
        isValid: false,
        status: ReassignStatus.initial,
      ),
    );
  }
}
