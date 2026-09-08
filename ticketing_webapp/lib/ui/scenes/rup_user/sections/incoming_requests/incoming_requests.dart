import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/professor_request_api.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/scenes/components/professor_request_list/professor_request_list.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/incoming_requests/bloc/incoming_requests_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/incoming_requests/bloc/incoming_requests_state.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class IncomingRequests extends StatelessWidget {
  const IncomingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return IncomingRequestsCubit(api: context.read<ProfessorRequestApi>())
          ..fetchIncomingRequests('In attesa');
      },
      child: BlocConsumer<IncomingRequestsCubit, IncomingRequestsState>(
        listener: (context, state) {
          if (state.status == IncomingRequestsStatus.error ||
              state.status == IncomingRequestsStatus.deleteError) {
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
          if (state.status == IncomingRequestsStatus.deleteSuccess) {
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
          if (state.status == IncomingRequestsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == IncomingRequestsStatus.empty) {
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
            showReassignButton: true,
          );
        },
      ),
    );
  }
}
