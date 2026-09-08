import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ticketing_webapp/features/repositories/professor_request_api.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/utils/form_inputs.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/new_request/models/requests/professor_request.dart';
import 'new_request_state.dart';

class NewRequestCubit extends Cubit<NewRequestState> {
  final ProfessorRequestApi _newProfessorRequestApi;

  // Inizializziamo il Cubit richiedendo l'API nel costruttore
  NewRequestCubit({required ProfessorRequestApi newProfessorRequestApi})
    : _newProfessorRequestApi = newProfessorRequestApi,
      super(const NewRequestState());

  // === Azione all'inzio del form ===
  Future<void> submitProfessorRequest() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: RequestStatus.submitting));

    try {
      final request = ProfessorRequest(
        subject: state.title.value,
        content: state.body.value,
      );

      await _newProfessorRequestApi.createProfessorRequest(request);

      emit(state.copyWith(status: RequestStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.error,
          errorMessage: 'Errore durante l\'invio della richiesta.',
        ),
      );
    }
  }

  // === METODO DI SUPPORTO PER LA VALIDAZIONE ===
  List<FormzInput> _fieldsToValidate({TextInput? title, TextInput? body}) {
    return [title ?? state.title, body ?? state.body];
  }

  // === AGGIORNAMENTO CAMPI ===
  void titleChanged(String value) {
    final title = TextInput.dirty(value);
    emit(
      state.copyWith(
        status: RequestStatus.initial,
        title: title,
        isValid: Formz.validate(_fieldsToValidate(title: title)),
      ),
    );
  }

  void bodyChanged(String value) {
    final body = TextInput.dirty(value);
    emit(
      state.copyWith(
        status: RequestStatus.initial,
        body: body,
        isValid: Formz.validate(_fieldsToValidate(body: body)),
      ),
    );
  }

  void resetForm() {
    emit(const NewRequestState());
  }
}
