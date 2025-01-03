import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/calendar/note_calendar_page.dart';
import 'package:notes/views/note_calender_events_view.dart';

TableCell noteCalendarCell({required NoteCalendarPage widget, required DateTime dateTime, required int startingIndex, required double height}) {

    int titleIndex = widget.pageInfo["rowIndex"] ?? 0;
    int dateIndex = widget.pageInfo["dateRowIndex"] ?? 0;

    List<String> events = [];

    widget.tableData.data.forEach((list) {
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

    return TableCell(child: _DayWidget(day: dateTime.day, events: events, height: height, isDayOff:  dayOff,));

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
          Navigator.push(context,    PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return NoteCalenderEventsView(events: events);
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
    if(green > 125 && blue > 125) {
      return Color.fromARGB(255, red, green - 25, blue - 25);
    }
    else {
      return Color.fromARGB(255, red, green + 25, blue + 25);
    }
  }
}