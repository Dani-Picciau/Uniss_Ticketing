import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/procedure_api.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/bloc/rup_user_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_state.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/node/procedure_timeline_view.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/components/open_procedure_list/open_procedure_list.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class SharedTimelineProcedure extends StatelessWidget {
  final String? procedureType;
  final String? status;
  final String? viewAs;

  // Aggiungiamo i booleani visivi
  final bool showReassignButton;
  final bool showDeleteButton;
  final bool showDeadline;
  final bool isReadOnly;

  const SharedTimelineProcedure({
    super.key,
    this.procedureType,
    this.status,
    this.viewAs,
    this.showReassignButton = true,
    this.showDeleteButton = true,
    this.showDeadline = false,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    String? targetProcedureId;
    try {
      targetProcedureId = context
          .read<AdminManagerCubit>()
          .state
          .targetProcedureId;
    } catch (_) {
      // Se fallisce, siamo nella dashboard del professore. Lo ignoriamo in modo silenzioso.
      targetProcedureId = null;
    }
    return BlocProvider(
      create: (context) {
        final cubit = ProcedureTimelineCubit(
          detailApi: context.read<ProcedureApi>(),
        );

        // Se l'ID c'è, forziamo l'apertura immediata della timeline!
        if (targetProcedureId != null && targetProcedureId.isNotEmpty) {
          cubit.fetchTimeline(targetProcedureId);
        }

        return cubit;
      },
      child: BlocConsumer<ProcedureTimelineCubit, ProcedureTimelineState>(
        listener: (context, state) {
          if (state.status == ProcedureTimelineStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildMessangerSnackBar(
                context,
                text:
                    state.errorMessage ??
                    'Errore nel caricamento della timeline',
                iconPath: MediaConstants.error,
                textColor: context.colors.white,
                backgroundColor: context.colors.errorMessage,
              ),
            );
          }
        },

        builder: (context, state) {
          if (state.status == ProcedureTimelineStatus.initial) {
            return ShowOpenProcedureList(
              procedureType: procedureType,
              status: status,
              viewAs: viewAs,
              showReassignButton: showReassignButton,
              showDeleteButton: showDeleteButton,
              showDeadline: showDeadline,
            );
          }

          if (state.status == ProcedureTimelineStatus.loading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 48.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.status == ProcedureTimelineStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UnissLabel(
                    text: 'Impossibile caricare i dettagli della procedura',
                    textType: UnissTextType.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProcedureTimelineCubit>().clearSelection(),
                    child: UnissLabel(
                      text: 'Torna alla lista',
                      textType: UnissTextType.bodySmall,
                    ),
                  ),
                ],
              ),
            );
          }

          // status == success qui: uiModel è garantito non-null
          return ProcedureTimelineView(data: state.uiModel!,isReadOnly: isReadOnly);
        },
      ),
    );
  }
}
