import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/calendar/note_calendar_block.dart';
import 'package:notes/components/note_editor/embed_block/table/chart/note_chart_block.dart';
import 'package:notes/components/note_editor/embed_block/table/table/note_table_block.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_data.dart';
import 'package:notes/models/note_embed_blocks.dart';

class NoteTableWidget extends StatefulWidget {

  final String tableKey;
  final bool readOnly;
  const NoteTableWidget({super.key, required this.tableKey, required this.readOnly});

  @override
  State<NoteTableWidget> createState() => _NoteTableWidgetState();
}

class _NoteTableWidgetState extends State<NoteTableWidget> {

  @override
  Widget build(BuildContext context) {
    TableData tableData = noteEmbedBlocks.getTable(widget.tableKey);
    List<Widget> children = [];

    bool tableExist = false;
    for(int i = 0 ; i < tableData.pages.length; i++) {
      var page = tableData.pages[i];
      switch(page["type"]) {
        case "calendar":
          children.add(NoteCalendarBlock(
            tableData: tableData,
            readOnly: widget.readOnly,
            pageInfo: page,
            removePage: () {
              setState(() {
                tableData.pages.removeAt(i);
                i--;
              });
            },
          ));
        case "chart":
          children.add(NoteChartBlock(
            tableData: tableData,
            readOnly: widget.readOnly,
            pageInfo: page,
            removePage: () {
              setState(() {
                tableData.pages.removeAt(i);
                i--;
              });
            },
          ));
          break;
        case "table":
          tableExist = true;
          children.add(NoteTableBlock(
            tableData: tableData,
            readOnly: widget.readOnly,
            pageInfo: page,
            removePage: () {
              setState(() {
                tableData.pages.removeAt(i);
                i--;
              });
            },
          ));
          break;
      }
    }

    if(children.isEmpty || !tableExist) {
      children.add(NoteTableBlock(
        tableData: tableData,
        readOnly: widget.readOnly,
        pageInfo: {},
      ));
    }

    if(!widget.readOnly) {
      children.insert(0, _AddPageButton(addPage: (pageType) {
        setState(() {
          noteEmbedBlocks.getTable(widget.tableKey).pages.insert(0, {"type": pageType});
        });
      }));

      children.add(_AddPageButton(addPage: (pageType) {
        setState(() {
          noteEmbedBlocks.getTable(widget.tableKey).pages.add({"type": pageType});
        });
      }));
    }

    // if(tableData.viewMode == "view-pager") {
    //   PageController pageController = PageController();
    //   return Column(
    //     children: [
    //       SizedBox(
    //         height: tableData.height,
    //         child: PageView(
    //           controller: pageController,
    //           children: children,
    //         )
    //       ),
    //       SmoothPageIndicator(
    //         controller: pageController,
    //         count: children.length,
    //         onDotClicked: (index) {
    //           pageController.animateToPage(index, duration: Duration(milliseconds: 750), curve: Curves.easeOutQuint);
    //         },
    //       )
    //     ],
    //   );
    // }
    // else {
      return MouseRegion(
        cursor: SystemMouseCursors.basic,
        onHover: (d) {
          if(!widget.readOnly) {
            Focus.of(context).unfocus();
          }

        },
        child: GestureDetector(
          onTap: () {
            if(!widget.readOnly) {
              Focus.of(context).unfocus();
            }
          },
          child: Column(
            children: children,
          ),
        ),
      );
 //   }

  }
}

class _AddPageButton extends StatelessWidget {

  final void Function(String) addPage;
  const _AddPageButton({required this.addPage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton(icon: Icon(Icons.add), itemBuilder: (context) {
        return [
          PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_add_data_page_chart")), onTap: () {
            addPage("chart");
          }),
          PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_add_data_page_calendar")), onTap: () {
            addPage("calendar");
          }),
        ];
      }),
    );
  }
}
