import 'package:equatable/equatable.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/utils/form_inputs.dart';

enum RequestStatus { initial, submitting, success, error }

class NewRequestState extends Equatable {
  final RequestStatus status;
  final String? errorMessage;

  // Campi per la validazione del form
  final TextInput title;
  final TextInput body;
  final bool isValid;

  const NewRequestState({
    this.status = RequestStatus.initial,
    this.errorMessage,
    this.title = const TextInput.pure(),
    this.body = const TextInput.pure(),
    this.isValid = false,
  });

  NewRequestState copyWith({
    RequestStatus? status,
    String? errorMessage,
    TextInput? title,
    TextInput? body,
    bool? isValid,
  }) {
    return NewRequestState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      title: title ?? this.title,
      body: body ?? this.body,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, title, body, isValid];
}
