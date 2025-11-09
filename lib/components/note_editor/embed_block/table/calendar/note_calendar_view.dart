import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/table_data.dart';
import 'package:notes/pages/note_calender_events_page.dart';

class NoteCalendarView extends StatelessWidget {

  final DateTime month;
  final double cellHeight;
  final TableData tableData;
  final Map<String, dynamic> viewInfo;
  const NoteCalendarView({super.key, required this.month, required this.cellHeight, required this.tableData, required this.viewInfo});

  @override
  Widget build(BuildContext context) {

    int maxDays = _getMaxDaysInMonth(month);

    int childrenLength = calculateChildrenLength(maxDays, month.weekday);

    List<TableRow> children = List.generate(childrenLength, (i) => TableRow(
        children: List.generate(7, (index) => TableCell(child: Text("")))
    ));
    int startingIndex = (month.weekday == 7) ? 0 : month.weekday;

    for(int i = 1 ; i <= maxDays; i++) {
      DateTime dateTime = DateTime(month.year, month.month, i);
      int rowIndex = (i + startingIndex - 1) ~/ 7;
      int colIndex = (dateTime.weekday > 6) ? 0 : dateTime.weekday;

      int titleIndex = viewInfo["rowIndex"] ?? 0;
      int dateIndex = viewInfo["dateRowIndex"] ?? 0;

      List<String> events = [];

      tableData.data.forEach((list) {
        if(list[dateIndex]["date"] is int && list[titleIndex]["text"] is String) {
          DateTime dateOfEvent = DateTime.fromMillisecondsSinceEpoch(list[dateIndex]["date"]).toLocal();
          if(dateOfEvent.day == dateTime.day && dateOfEvent.year == dateTime.year && dateOfEvent.month == dateTime.month) {
            events.add(list[titleIndex]["text"]);
          }
        }
      });
      bool dayOff = false;
      if(dateTime.weekday > 5) {
        dayOff = true;
      }

      children[rowIndex].children[colIndex] = _DayWidget(day: dateTime.day, events: events, height: cellHeight, isDayOff: dayOff);
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

int calculateChildrenLength(int maxDays, int firstDayWeekday) {
  if ((maxDays == 31 && firstDayWeekday < 5) || firstDayWeekday == 7) {
    return 5;
  }
  if ((maxDays < 31 && firstDayWeekday < 6) || firstDayWeekday == 7) {
    return 5;
  }
  return 6;
}

int _getMaxDaysInMonth(DateTime dateTime) {

  DateTime nextMonth = DateTime(dateTime.year, dateTime.month + 1, 1);

  DateTime lastDayOfCurrentMonth = nextMonth.subtract(Duration(days: 1));

  return lastDayOfCurrentMonth.day;
}

class _DayWidget extends StatelessWidget {

  final int day;
  final bool isDayOff;
  final double height;
  final List<String> events;
  const _DayWidget({required this.day, this.isDayOff = false, required this.events, required this.height});

  @override
  Widget build(BuildContext context) {

    if(height > 50) {
      List<Widget> children = [ Align(
          alignment: Alignment.topRight,
          child: Text(day.toString()))  ];

      for(String event in events) {
        children.add(Text(event));
        if(children.length > 3) {
          break;
        }
      }
      return Container(
        height: height,
        color: isDayOff ? Theme.of(context).scaffoldBackgroundColor.toDayOffColor() : null,
        child: Padding(
          padding: const EdgeInsets.all(7.5),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children
          ),
        ),
      );
    }
    else {
      return GestureDetector(
        onTap: () {
          Navigator.push(context, PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return NoteCalenderEventsPage(events: events);
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),);
        },
        child: Padding(
          padding: const EdgeInsets.all(7.5),
          child: Column(
            children: [
              Text(day.toString(), textAlign: TextAlign.center,),
              Opacity(
                  opacity: events.isNotEmpty ? 1.0 : 0.0,
                  child: Icon(Icons.circle, size: 10))
            ],
          ),
        ),
      );
    }

  }
}

extension _DayOffEx on Color {
  Color toDayOffColor() {
    final red = (r * 255).round() & 0xff;
    final green = (g * 255).round() & 0xff;
    final blue = (b * 255).round() & 0xff;
    if(green > 125 && blue > 125) {
      return Color.fromARGB(255, red, green - 25, blue - 25);
    }
    else {
      return Color.fromARGB(255, red, green + 25, blue + 25);
    }
  }
}