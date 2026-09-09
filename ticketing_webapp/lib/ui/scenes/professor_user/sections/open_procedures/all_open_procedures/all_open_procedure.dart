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

class AllOpenProcedures extends StatelessWidget {
  const AllOpenProcedures({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProfessorRequestsCubit(api: context.read<ProfessorRequestApi>())
          ..fetchPendingRequests('Presa in carico');
      },
      child: BlocConsumer<ProfessorRequestsCubit, ProfessorRequestsState>(
        listener: (context, state) {
          if (state.status == ProfessorRequestsStatus.error) {
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
        },
        builder: (context, state) {
          if (state.status == ProfessorRequestsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProfessorRequestsStatus.empty) {
            return const Center(
              child: UnissLabel(
                text: 'Nessuna procedura attiva al momento.',
                textType: UnissTextType.bodyMedium,
              ),
            );
          }

          return ShowProfessorsRequestsList(
            requests: state.requests,
            showDeleteButton: false,
          );
        },
      ),
    );
  }
}
