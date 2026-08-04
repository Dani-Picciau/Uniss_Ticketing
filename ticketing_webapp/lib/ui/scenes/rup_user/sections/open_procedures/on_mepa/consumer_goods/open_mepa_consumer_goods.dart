import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/procedure_detail_api.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_state.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/node/procedure_timeline_view.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/open_procedure_list/open_procedure_list.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class OpenMepaConsumerGoods extends StatelessWidget {
  const OpenMepaConsumerGoods({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProcedureTimelineCubit(detailApi: context.read<ProcedureDetailApi>()),
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
            return const ShowOpenProcedureList(
              procedureType: 'ORDINI_SU_MEPA_BENI_CONSUMO',
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
                    text: 'Impossibile carcare i dettagli della procedura',
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
          return ProcedureTimelineView(data: state.uiModel!);
        },
      ),
    );
  }
}
