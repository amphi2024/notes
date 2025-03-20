import 'package:amphi/models/app.dart';
import 'package:amphi/widgets/menu/popup/custom_popup_menu_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/note_editor/embed_block/table/calendar/edit_calendar_style.dart';
import 'package:notes/components/note_editor/embed_block/table/calendar/note_calendar_page.dart';
import 'package:notes/components/note_editor/embed_block/table/table/note_table_block.dart';

class NoteCalendarBlock extends NoteTableBlock {
  const NoteCalendarBlock({super.key, required super.tableData, required super.readOnly, required super.pageInfo, super.removePage});

  @override
  State<NoteCalendarBlock> createState() => _NoteCalendarState();
}

class _NoteCalendarState extends State<NoteCalendarBlock> {

  late PageController pageController = PageController(initialPage: dateTime.month - 1);
  late DateTime dateTime;
  late DateTime showingMonth;

 @override
  void dispose() {
   pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {

    int dateIndex = widget.pageInfo["dateRowIndex"] ?? 0;

    try {
      var list = widget.tableData.data[0];
      DateTime dateOfEvent = DateTime.fromMillisecondsSinceEpoch(list[dateIndex]["date"]).toLocal();
      dateTime = dateOfEvent;
      showingMonth = dateOfEvent;
    }
    catch(e) {
      dateTime = DateTime.now();
      showingMonth = DateTime.now();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var editCalendarStyle = EditCalenderStyle(
      tableData: widget.tableData,
      onStyleChange: (function) {
        setState(function);
      },
      pageInfo: widget.pageInfo,
    );

    return Column(
      children: [
        Visibility(
          visible: !widget.readOnly,
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(icon: Icon(Icons.more_horiz), onPressed: () {
                    if(App.isWideScreen(context)) {
                      final RenderBox button = context.findRenderObject() as RenderBox;
                      final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                      final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

                      RelativeRect relativeRect = RelativeRect.fromLTRB(
                        1,
                        position.dy + 50,
                        0,
                        0,
                      );
                      showCustomPopupMenuByPosition(context,relativeRect ,editCalendarStyle);
                    }
                    else {
                      showDialog(context: context, builder: (context) {
                        return Dialog(
                          child: editCalendarStyle,
                        );
                      });
                    }
                  }),
                  IconButton(onPressed: () {
                    widget.removePage!();

                  }, icon: Icon(Icons.remove))
                ],
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: App.isDesktop(),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 15, color: Theme.of(context).dividerColor,),
                onPressed: () {
                  setState(() {
                    if(showingMonth.month > 1) {
                      showingMonth = DateTime(showingMonth.year, showingMonth.month - 1);
                      pageController.animateToPage(showingMonth.month - 1, duration: Duration(milliseconds: 750), curve: Curves.easeOutQuint);
                    }
                    else {
                      dateTime = DateTime(dateTime.year - 1 , 12);
                      showingMonth = DateTime(dateTime.year, 12);
                      pageController.animateToPage(11, duration: Duration(milliseconds: 750), curve: Curves.easeOutQuint);
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  DateFormat(DateFormat.YEAR_MONTH, Localizations.localeOf(context).languageCode).format(showingMonth), style: TextStyle(
                  fontWeight: FontWeight.bold
              )),
            ),
            Visibility(
              visible: App.isDesktop(),
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios, size: 15, color: Theme.of(context).dividerColor,),
                onPressed: () {
                  setState(() {
                    if(showingMonth.month < 12) {
                      showingMonth = DateTime(showingMonth.year, showingMonth.month + 1);
                      pageController.animateToPage(showingMonth.month - 1, duration: Duration(milliseconds: 750), curve: Curves.easeOutQuint);
                    }
                    else {
                      dateTime = DateTime(dateTime.year + 1 , 1);
                      showingMonth = DateTime(dateTime.year, 1);
                      pageController.animateToPage(0, duration: Duration(milliseconds: 750), curve: Curves.easeOutQuint);
                    }
                  });
                },
              ),
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            double parentWidth = constraints.maxWidth;
            double cellHeight = App.isWideScreen(context) ? 120 : 50;
            return SizedBox(
              width: parentWidth,
              height: App.isWideScreen(context) ? 780 : 350,
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    showingMonth = DateTime(showingMonth.year, index + 1);
                  });
                },
                children: [
                  NoteCalendarPage(cellHeight: cellHeight, tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 1, 1), pageInfo: widget.pageInfo,),
                  NoteCalendarPage(cellHeight: cellHeight,tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 2, 1), pageInfo: widget.pageInfo),
                  NoteCalendarPage(cellHeight: cellHeight,tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 3, 1), pageInfo: widget.pageInfo),
                  NoteCalendarPage(cellHeight: cellHeight,tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 4, 1), pageInfo: widget.pageInfo),
                  NoteCalendarPage(cellHeight: cellHeight,tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 5, 1), pageInfo: widget.pageInfo),
                  NoteCalendarPage(cellHeight: cellHeight,tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 6, 1), pageInfo: widget.pageInfo),
                  NoteCalendarPage(cellHeight: cellHeight,tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 7, 1), pageInfo: widget.pageInfo),
                  NoteCalendarPage(cellHeight: cellHeight,tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 8, 1), pageInfo: widget.pageInfo),
                  NoteCalendarPage(cellHeight: cellHeight,tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 9, 1), pageInfo: widget.pageInfo),
                  NoteCalendarPage(cellHeight: cellHeight,tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 10, 1), pageInfo: widget.pageInfo),
                  NoteCalendarPage(cellHeight: cellHeight,tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 11, 1), pageInfo: widget.pageInfo),
                  NoteCalendarPage(cellHeight: cellHeight,tableData: widget.tableData, readOnly: widget.readOnly, dateTime: DateTime(dateTime.year, 12, 1), pageInfo: widget.pageInfo),
                ],
              ),
            );
          }
        ),
      ],
    );
  }
}
