import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/professor_request_api.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/new_request/bloc/new_request_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/new_request/bloc/new_request_state.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/new_request/components/new_request_form.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class NewProfessorRequest extends StatefulWidget {
  const NewProfessorRequest({super.key});

  @override
  State<NewProfessorRequest> createState() => _NewProfessorRequestState();
}

class _NewProfessorRequestState extends State<NewProfessorRequest> {
  Key _formResetKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return NewRequestCubit(
          newProfessorRequestApi: context.read<ProfessorRequestApi>(),
        );
      },
      child: FadeIn(
        offset: const Offset(-50, 0),
        duration: Duration(milliseconds: 500),
        child: LayoutBuilder(
          builder: (context, outerConstraints) {
            final isDesktop = outerConstraints.maxWidth > 400;
            return BlocConsumer<NewRequestCubit, NewRequestState>(
              listener: (context, state) {
                if (state.status == RequestStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildMessangerSnackBar(
                      context,
                      text: 'Richiesta inviata con successo!',
                      iconPath: MediaConstants.success,
                      textColor: context.colors.white,
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.read<NewRequestCubit>().resetForm();
                  setState(() {
                    _formResetKey = UniqueKey();
                  });
                }
                if (state.status == RequestStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildMessangerSnackBar(
                      context,
                      text: state.errorMessage ?? 'Errore sconosciuto',
                      iconPath: MediaConstants.error,
                      textColor: context.colors.white,
                      backgroundColor: context.colors.errorMessage,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == RequestStatus.submitting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return NewRequestForm(
                  key: _formResetKey,
                  formTitle: 'Nuova richiesta di acquisto',
                  requestNameLabel: 'Titolo della richiesta',
                  requestBodyLabel:
                      'Fornisci una descrizione dettagliata della tua richiesta',

                  onTitleChanged: (value) =>
                      context.read<NewRequestCubit>().titleChanged(value),
                  onBodyChanged: (value) =>
                      context.read<NewRequestCubit>().bodyChanged(value),

                  // Azioni dei bottoni
                  onSubmit: state.isValid
                      ? () => context
                            .read<NewRequestCubit>()
                            .submitProfessorRequest()
                      : null,
                  onClear: () {
                    context.read<NewRequestCubit>().resetForm();
                    setState(() {
                      _formResetKey = UniqueKey();
                    });
                  },
                  isDesktop: isDesktop,

                  //Mappatura errori
                  titleError: state.title.displayError != null
                      ? 'Campo obbligatorio'
                      : null,
                  bodyError: state.body.displayError != null
                      ? 'Campo obbligatorio'
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
