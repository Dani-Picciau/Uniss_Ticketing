import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/professor_request_api.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/scenes/components/professor_request_list/professor_request_list.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/bloc/professor_requests_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/bloc/professor_requests_state.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class MadeRequests extends StatelessWidget {
  final String? status;
  final String? viewAs;
  final bool showDeleteButton;
  final String? emptyListMessage;

  const MadeRequests({
    super.key,
    required this.status,
    this.viewAs,
    this.showDeleteButton = true,
    this.emptyListMessage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProfessorRequestsCubit(api: context.read<ProfessorRequestApi>())
          ..fetchPendingRequests(statusType: status, viewAs: viewAs);
      },
      child: BlocConsumer<ProfessorRequestsCubit, ProfessorRequestsState>(
        listener: (context, state) {
          if (state.status == ProfessorRequestsStatus.error ||
              state.status == ProfessorRequestsStatus.deleteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildMessangerSnackBar(
                context,
                text: state.errorMessage ?? 'Si è verificato un erorre',
                iconPath: MediaConstants.error,
                textColor: context.colors.white,
                backgroundColor: context.colors.errorMessage,
              ),
            );
          }
          if (state.status == ProfessorRequestsStatus.deleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildMessangerSnackBar(
                context,
                text: 'Procedura eliminata con successo!',
                iconPath: MediaConstants.success,
                textColor: context.colors.white,
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProfessorRequestsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProfessorRequestsStatus.empty) {
            return const Center(
              child: UnissLabel(
                text: 'Nessuna richiesta al momento.',
                textType: UnissTextType.bodyMedium,
              ),
            );
          }

          return ShowProfessorsRequestsList(
            requests: state.requests,
            showDeleteButton: showDeleteButton,
          );
        },
      ),
    );
  }
}
