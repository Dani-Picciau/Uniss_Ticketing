import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/procedure_list_api.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/open_procedure_list/bloc/procedure_list_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/open_procedure_list/bloc/procedure_list_state.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/open_procedure_list/open_procedure_list_item.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class ShowOpenProcedureList extends StatelessWidget {
  final String procedureType;
  const ShowOpenProcedureList({super.key, required this.procedureType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProcedureListCubit(procedureApi: context.read<ProcedureList>())
          ..fetchProceduresByCategory(procedureType);
      },
      child: BlocConsumer<ProcedureListCubit, ProcedureListState>(
        listener: (context, state) {
          if (state.status == ProcedureListStatus.error) {
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
          if (state.status == ProcedureListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProcedureListStatus.empty) {
            return const Center(child: Text('Nessuna procedura trovata.'));
          }

          if (state.status == ProcedureListStatus.error &&
              state.procedures.isEmpty) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Errore nel caricamento dei dati',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.procedures.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final procedure = state.procedures[index];
              return OpenProcedureListItem(
                procedure: procedure,
                onTap: () {
                  // Qui in futuro metteremo la navigazione al dettaglio:
                  // context.go('/procedure-detail/${procedure.id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}
