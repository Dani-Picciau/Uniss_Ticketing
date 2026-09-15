import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ticketing_webapp/features/repositories/procedure_api.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/calendar/calendar.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/bloc/rup_user_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/bloc/procedure_list_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/bloc/procedure_list_state.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/components/open_procedure_list/open_procedure_list_item.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/procedure_summary/procedure_summary.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class DeadlineScreen extends StatefulWidget {
  final String procedureType;

  const DeadlineScreen({super.key, required this.procedureType});

  @override
  State<DeadlineScreen> createState() => _DeadlineScreenState();
}

class _DeadlineScreenState extends State<DeadlineScreen> {
  // Funzione helper per estrarre le procedure di un giorno specifico
  List<ProcedureSummary> _getEventsForDay(
    List<ProcedureSummary> allProcedures,
    DateTime day,
  ) {
    return allProcedures.where((procedure) {
      if (procedure.deadline == null) return false;

      return isSameDay(procedure.deadline, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay =
        context.watch<AdminManagerCubit>().state.selectedDeadlineDate ??
        DateTime.now();

    return BlocProvider(
      create: (context) =>
          ProcedureListCubit(procedureApi: context.read<ProcedureApi>())
            ..fetchProcedures(procedureType: widget.procedureType),
      child: BlocBuilder<ProcedureListCubit, ProcedureListState>(
        builder: (context, state) {
          if (state.status == ProcedureListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProcedureListStatus.error) {
            return const Center(child: Text('Errore nel caricamento'));
          }

          final allProcedures = state.procedures;

          // Filtriamo la lista in base al giorno selezionato
          final selectedProcedures = _getEventsForDay(
            allProcedures,
            selectedDay,
          );

          return FadeIn(
            offset: const Offset(-50, 0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Se false, siamo molto probabilmente dentro
                // SingleChildScrollView e quindi non possiamo usare
                // Expanded verticali.
                final hasBoundedHeight = constraints.hasBoundedHeight;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ====================================================
                    // CALENDARIO
                    // ====================================================
                    DeadlinesCalendar(
                      allProcedures: allProcedures,
                      selectedDay: selectedDay,
                      onDaySelected: (newSelectedDay) {
                        context.read<AdminManagerCubit>().updateDeadlineDate(
                          newSelectedDay,
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // ====================================================
                    // LISTA PROCEDURE
                    // ====================================================
                    if (hasBoundedHeight)
                      // --------------------------------------------------
                      // DESKTOP
                      // --------------------------------------------------
                      Expanded(
                        child: _buildProceduresList(
                          context,
                          selectedProcedures,
                          useInternalScroll: true,
                        ),
                      )
                    else
                      // --------------------------------------------------
                      // MOBILE / SINGLECHILDSCROLLVIEW
                      // --------------------------------------------------
                      _buildProceduresList(
                        context,
                        selectedProcedures,
                        useInternalScroll: false,
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProceduresList(
    BuildContext context,
    List<ProcedureSummary> selectedProcedures, {
    required bool useInternalScroll,
  }) {
    if (selectedProcedures.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: UnissLabel(
            text: 'Nessuna scadenza per la data selezionata.',
            textType: UnissTextType.bodyMedium,
          ),
        ),
      );
    }

    // ================================================================
    // DESKTOP
    // ================================================================
    //
    // La lista ha un'altezza finita e può gestire il proprio scroll.
    // ================================================================
    if (useInternalScroll) {
      return FadeIn(
        offset: const Offset(-50, 0),
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: selectedProcedures.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return _buildProcedureItem(context, selectedProcedures[index]);
          },
        ),
      );
    }

    // ================================================================
    // MOBILE / SINGLECHILDSCROLLVIEW
    // ================================================================
    //
    // Lo scroll verticale è già gestito dallo
    // SingleChildScrollView esterno.
    //
    // Quindi niente ListView scrollabile.
    // ================================================================
    return FadeIn(
      offset: const Offset(-50, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...List.generate(
            selectedProcedures.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildProcedureItem(context, selectedProcedures[index]),
            ),
          ),

          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildProcedureItem(BuildContext context, ProcedureSummary procedure) {
    return OpenProcedureListItem(
      procedure: procedure,
      showReassignButton: false,
      showDeleteButton: false,
      showArrowAnimation: false,
      showArrowDown: false,
      showDeadline: true,
      isRUP: false,
      onTap: () {
        context.read<AdminManagerCubit>().jumpToProcedureTimeline(procedure.id);
      },
    );
  }
}
