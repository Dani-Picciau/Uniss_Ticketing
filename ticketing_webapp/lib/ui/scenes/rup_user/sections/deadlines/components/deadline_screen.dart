import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ticketing_webapp/features/repositories/procedure_list_api.dart';
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
  // Teniamo traccia del mese visualizzato e del giorno selezionato
  DateTime? _selectedDay = DateTime.now();

  // Funzione helper per estrarre le procedure di un giorno specifico
  List<ProcedureSummary> _getEventsForDay(
    List<ProcedureSummary> allProcedures,
    DateTime day,
  ) {
    return allProcedures.where((procedure) {
      if (procedure.deadline == null) return false;
      // isSameDay è una comodissima funzione fornita da table_calendar
      return isSameDay(procedure.deadline, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProcedureListCubit(procedureApi: context.read<ProcedureListApi>())
            ..fetchProceduresByCategory(widget.procedureType),
      child: BlocBuilder<ProcedureListCubit, ProcedureListState>(
        builder: (context, state) {
          if (state.status == ProcedureListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProcedureListStatus.error) {
            return const Center(child: Text('Errore nel caricamento'));
          }

          final allProcedures = state.procedures;
          // Filtriamo la lista inferiore in base al giorno selezionato
          final selectedProcedures = _selectedDay != null
              ? _getEventsForDay(allProcedures, _selectedDay!)
              : <ProcedureSummary>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DeadlinesCalendar(
                allProcedures: allProcedures,
                selectedDay: _selectedDay,
                onDaySelected: (newSelectedDay) {
                  setState(() {
                    _selectedDay = newSelectedDay;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Lista delle procedure
              Expanded(
                child: selectedProcedures.isEmpty
                    ? const Center(
                        child: UnissLabel(
                          text: 'Nessuna scadenza per la data selezionata.',
                          textType: UnissTextType.bodyMedium,
                        ),
                      )
                    : FadeIn(
                        offset: const Offset(-50, 0),
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: selectedProcedures.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final procedure = selectedProcedures[index];
                            return OpenProcedureListItem(
                              procedure: procedure,
                              showReassignButton: false,
                              showDeleteButton: false,
                              showArrowAnimation: false,
                              showDeadline: true,
                              onTap: () {
                                context
                                    .read<AdminManagerCubit>()
                                    .jumpToProcedureTimeline(procedure.id);
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
