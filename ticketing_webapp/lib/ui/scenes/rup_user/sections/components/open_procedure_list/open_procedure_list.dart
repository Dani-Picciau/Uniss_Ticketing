import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/procedure_list_api.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/bloc/procedure_list_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/bloc/procedure_list_state.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/components/open_procedure_list/open_procedure_list_item.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class ShowOpenProcedureList extends StatelessWidget {
  final String procedureType;
  final bool showReassignButton;
  final bool showDeleteButton;
  final bool showDeadline;

  const ShowOpenProcedureList({
    super.key,
    required this.procedureType,
    this.showReassignButton = true,
    this.showDeleteButton = true,
    this.showDeadline = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProcedureListCubit(
          procedureApi: context.read<ProcedureListApi>(),
        )..fetchProceduresByCategory(procedureType);
      },
      child: BlocConsumer<ProcedureListCubit, ProcedureListState>(
        listener: (context, state) {
          if (state.status == ProcedureListStatus.error ||
              state.status == ProcedureListStatus.deleteError) {
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
          if (state.status == ProcedureListStatus.deleteSuccess) {
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
          if (state.status == ProcedureListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProcedureListStatus.empty) {
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
                itemCount: state.procedures.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final procedure = state.procedures[index];
                  return OpenProcedureListItem(
                    procedure: procedure,
                    showReassignButton: showReassignButton,
                    showDeleteButton: showDeleteButton,
                    showDeadline: showDeadline,
                    onTap: () {
                      context.read<ProcedureTimelineCubit>().fetchTimeline(
                        procedure.id,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
