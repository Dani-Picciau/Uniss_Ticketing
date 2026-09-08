import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/professor_request_api.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/requests/bloc/incoming_requests_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/requests/bloc/incoming_requests_state.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/requests/components/professor_request_list/professor_request_list_item.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class ShowProfessorsRequestsList extends StatelessWidget {
final String statusType;

  const ShowProfessorsRequestsList({
    super.key,
    required this.statusType
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return IncomingRequestsCubit(
          api: context.read<ProfessorRequestApi>(),
        )..fetchIncomingRequests(statusType);
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

          return FadeIn(
            offset: Offset(-50, 0),
            child: SingleChildScrollView(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.requests.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final requests = state.requests[index];

                  return ProfessorRequestListItem(request: requests);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
