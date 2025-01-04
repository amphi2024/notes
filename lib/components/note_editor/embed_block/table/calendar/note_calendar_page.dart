import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/calendar/note_calendar_cell.dart';
import 'package:notes/components/note_editor/embed_block/table/table/note_table_block.dart';

class NoteCalendarPage extends NoteTableBlock {

  final DateTime dateTime;
  final double cellHeight;
  const NoteCalendarPage({super.key, required super.tableData, required super.readOnly, required this.dateTime, required this.cellHeight, required super.pageInfo});

  @override
  State<NoteCalendarPage> createState() => _NoteCalendarPageState();
}

class _NoteCalendarPageState extends State<NoteCalendarPage> {


  int calculateChildrenLength(int maxDays, int firstDayWeekday) {
    if ((maxDays == 31 && firstDayWeekday < 5) || firstDayWeekday == 7) {
      return 5;
    }
    if ((maxDays < 31 && firstDayWeekday < 6) || firstDayWeekday == 7) {
      return 5;
    }
    return 6;
  }

  @override
  Widget build(BuildContext context) {
    int maxDays = getMaxDaysInMonth(widget.dateTime);

    int childrenLength = calculateChildrenLength(maxDays, widget.dateTime.weekday);

    List<TableRow> children = List.generate(childrenLength, (i) => TableRow(
        children: List.generate(7, (index) => TableCell(child: Text("")))
    ));
    int startingIndex = (widget.dateTime.weekday == 7) ? 0 : widget.dateTime.weekday;

    for(int i = 1 ; i <= maxDays; i++) {
      DateTime dateTime = DateTime(widget.dateTime.year, widget.dateTime.month, i);
      int row = (i + startingIndex - 1) ~/ 7;
      int col = (dateTime.weekday > 6) ? 0 : dateTime.weekday; //

      children[row].children[col] = noteCalendarCell(
          widget: widget,
          dateTime: dateTime,
          startingIndex: startingIndex,
          height: widget.cellHeight);
    }

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(AppLocalizations.of(context).get("@day_name_sunday")),
                        Text(AppLocalizations.of(context).get("@day_name_monday")),
                        Text(AppLocalizations.of(context).get("@day_name_tuesday")),
                        Text(AppLocalizations.of(context).get("@day_name_wednesday")),
                        Text(AppLocalizations.of(context).get("@day_name_thursday")),
                        Text(AppLocalizations.of(context).get("@day_name_friday")),
                        Text(AppLocalizations.of(context).get("@day_name_saturday")),
                      ],
                    ),
                    Table(
                      border: App.isWideScreen(context) ? TableBorder.all(
                          color: Theme.of(context).dividerColor
                      ) : null,
                      children: children,
                    )
                  ],
                ),
              );
  }
}

int getMaxDaysInMonth(DateTime dateTime) {

  DateTime nextMonth = DateTime(dateTime.year, dateTime.month + 1, 1);

  DateTime lastDayOfCurrentMonth = nextMonth.subtract(Duration(days: 1));

  return lastDayOfCurrentMonth.day;
}