import 'package:amphi/widgets/menu/popup/custom_popup_menu_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/note_editor/embed_block/table/calendar/edit_calendar_style.dart';
import 'package:notes/utils/screen_size.dart';

import '../../../../../providers/tables_provider.dart';
import 'note_calendar_view.dart';

class NoteCalendar extends ConsumerStatefulWidget {

  final bool readOnly;
  final String tableId;
  final int viewIndex;
  const NoteCalendar({super.key, required this.readOnly, required this.tableId, required this.viewIndex});

  @override
  ConsumerState<NoteCalendar> createState() => _NoteCalendarState();
}

class _NoteCalendarState extends ConsumerState<NoteCalendar> {

  late final PageController pageController = PageController(initialPage: year.month - 1);
  DateTime year = DateTime.now();
  DateTime month = DateTime.now();

 @override
  void dispose() {
   pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final tableData = ref.watch(tablesProvider)[widget.tableId]!.data();
    final viewInfo = tableData.views[widget.viewIndex];

    final editCalendarStyle = EditCalenderStyle(
      viewIndex: widget.viewIndex, tableId: widget.tableId
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
                    if(isTablet(context)) {
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
                    ref.read(tablesProvider.notifier).removeView(widget.tableId, widget.viewIndex);
                  }, icon: Icon(Icons.remove))
                ],
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: isDesktop(),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 15, color: Theme.of(context).dividerColor,),
                onPressed: () {
                  setState(() {
                    if(month.month > 1) {
                      month = DateTime(month.year, month.month - 1);
                      pageController.animateToPage(month.month - 1, duration: Duration(milliseconds: 750), curve: Curves.easeOutQuint);
                    }
                    else {
                      year = DateTime(year.year - 1 , 12);
                      month = DateTime(year.year, 12);
                      pageController.animateToPage(11, duration: Duration(milliseconds: 750), curve: Curves.easeOutQuint);
                    }
                  });
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                final result = await showDatePicker(context: context, firstDate: DateTime(1), lastDate: DateTime.now(), initialDatePickerMode: DatePickerMode.year);
                if(result != null) {
                  setState(() {
                    year = result;
                    month = result;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    DateFormat(DateFormat.YEAR_MONTH, Localizations.localeOf(context).languageCode).format(month), style: TextStyle(
                    fontWeight: FontWeight.bold
                )),
              ),
            ),
            Visibility(
              visible: isDesktop(),
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios, size: 15, color: Theme.of(context).dividerColor,),
                onPressed: () {
                  setState(() {
                    if(month.month < 12) {
                      month = DateTime(month.year, month.month + 1);
                      pageController.animateToPage(month.month - 1, duration: Duration(milliseconds: 750), curve: Curves.easeOutQuint);
                    }
                    else {
                      year = DateTime(year.year + 1 , 1);
                      month = DateTime(year.year, 1);
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
            double cellHeight = isTablet(context) ? 120 : 50;
            return SizedBox(
              width: parentWidth,
              height: isTablet(context) ? 780 : 350,
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    month = DateTime(month.year, index + 1);
                  });
                },
                children: [
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 1, 1), viewInfo: viewInfo),
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 2, 1), viewInfo: viewInfo),
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 3, 1), viewInfo: viewInfo),
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 4, 1), viewInfo: viewInfo),
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 5, 1), viewInfo: viewInfo),
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 6, 1), viewInfo: viewInfo),
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 7, 1), viewInfo: viewInfo),
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 8, 1), viewInfo: viewInfo),
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 9, 1), viewInfo: viewInfo),
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 10, 1), viewInfo: viewInfo),
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 11, 1), viewInfo: viewInfo),
                  NoteCalendarView(cellHeight: cellHeight, tableData: tableData, month: DateTime(year.year, 12, 1), viewInfo: viewInfo),
                ],
              ),
            );
          }
        ),
      ],
    );
  }
}