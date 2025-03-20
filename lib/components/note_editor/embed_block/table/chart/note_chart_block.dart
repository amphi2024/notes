import 'package:amphi/models/app.dart';
import 'package:amphi/widgets/menu/popup/custom_popup_menu_route.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/chart/edit_chart_style.dart';
import 'package:notes/components/note_editor/embed_block/table/chart/bar/note_bar_chart_horizontal.dart';
import 'package:notes/components/note_editor/embed_block/table/table/note_table_block.dart';

class NoteChartBlock extends NoteTableBlock {
  const NoteChartBlock({super.key, required super.readOnly, required super.tableData, required super.pageInfo, required super.removePage});

  @override
  State<NoteChartBlock> createState() => _NoteChartState();
}

class _NoteChartState extends State<NoteChartBlock> {
  @override
  Widget build(BuildContext context) {
    Widget chartWidget = NoteBarChartHorizontal(readOnly: widget.readOnly, tableData: widget.tableData, pageInfo: widget.pageInfo, removePage: () {  },);
    var editBarChartStyle = EditChartStyle(
      tableData: widget.tableData,
      onStyleChange: (function) {
        setState(function);
      },
      pageInfo: widget.pageInfo,
    );

    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Visibility(
              visible: !widget.readOnly,
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
                      showCustomPopupMenuByPosition(context,relativeRect ,editBarChartStyle);
                    }
                    else {
                      showDialog(context: context, builder: (context) {
                        return Dialog(
                          child: editBarChartStyle,
                        );
                      });
                    }
                  }),
                  IconButton(onPressed: () {
                    widget.removePage!();
                  }, icon: Icon(Icons.remove))
                ],
              )),
        ),
        chartWidget
      ],
    );
  }
}
