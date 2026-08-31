import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/procedure_summary/procedure_summary.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class DeadlinesCalendar extends StatefulWidget {
  final List<ProcedureSummary> allProcedures;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  const DeadlinesCalendar({
    super.key,
    required this.allProcedures,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  State<DeadlinesCalendar> createState() => _DeadlinesCalendarState();
}

class _DeadlinesCalendarState extends State<DeadlinesCalendar> {
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    // Inizializza il focus sul giorno selezionato o su oggi
    _focusedDay = widget.selectedDay ?? DateTime.now();
  }

  // Spostiamo qui la funzione helper per i pallini
  List<ProcedureSummary> _getEventsForDay(DateTime day) {
    return widget.allProcedures.where((procedure) {
      if (procedure.deadline == null) return false;
      return isSameDay(procedure.deadline, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.lightGray),
      ),
      child: TableCalendar<ProcedureSummary>(
        firstDay: DateTime.utc(2026, 1, 1),
        lastDay: DateTime.utc(2050, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
        startingDayOfWeek: StartingDayOfWeek.monday,
        rowHeight: 45,
        eventLoader: _getEventsForDay,

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
          // Notifichiamo il genitore del click!
          widget.onDaySelected(selectedDay);
        },

        calendarFormat: _calendarFormat,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Compatta',
          CalendarFormat.week: 'Espandi',
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },

        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          titleTextStyle:
              unissTextTheme.titleLarge ?? const TextStyle(fontSize: 18),
          leftChevronIcon: Icon(Icons.chevron_left, color: context.colors.gray),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: context.colors.gray,
          ),
          formatButtonDecoration: BoxDecoration(
            color: context.colors.deepPurpleAlpha01,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.colors.deepPurple),
          ),
          formatButtonTextStyle:
              unissTextTheme.labelSmall?.copyWith(
                color: context.colors.deepPurple,
              ) ??
              const TextStyle(color: Colors.white),
        ),

        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle:
              unissTextTheme.bodySmall ?? const TextStyle(fontSize: 14),
          weekendStyle:
              unissTextTheme.bodySmall ?? const TextStyle(fontSize: 14),
        ),

        calendarStyle: CalendarStyle(
          defaultTextStyle:
              unissTextTheme.bodySmall ?? const TextStyle(fontSize: 14),
          weekendTextStyle:
              unissTextTheme.bodySmall ?? const TextStyle(fontSize: 14),
          outsideTextStyle:
              (unissTextTheme.bodySmall ?? const TextStyle(fontSize: 14))
                  .copyWith(color: context.colors.lightGray),
          selectedTextStyle:
              (unissTextTheme.bodySmall ?? const TextStyle(fontSize: 14))
                  .copyWith(color: context.colors.white),
          todayTextStyle:
              (unissTextTheme.bodySmall ?? const TextStyle(fontSize: 14))
                  .copyWith(color: context.colors.white),
          todayDecoration: BoxDecoration(
            color: context.colors.loginButton.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: context.colors.loginButton,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Color(0xFFD35400),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
