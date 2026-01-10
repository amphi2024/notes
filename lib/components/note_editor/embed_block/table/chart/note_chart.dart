import 'package:amphi/widgets/menu/popup/custom_popup_menu_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_editor/embed_block/table/chart/edit_chart_style.dart';
import 'package:notes/components/note_editor/embed_block/table/chart/bar/note_bar_chart_horizontal.dart';
import 'package:notes/providers/tables_provider.dart';
import 'package:notes/utils/screen_size.dart';

class NoteChart extends ConsumerWidget {

  final bool readOnly;
  final String tableId;
  final int viewIndex;
  const NoteChart({super.key, required this.readOnly, required this.tableId, required this.viewIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editBarChartStyle = EditChartStyle(
      tableId: tableId,
      viewIndex: viewIndex
    );

    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Visibility(
              visible: !readOnly,
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
                    ref.read(tablesProvider.notifier).removeView(tableId, viewIndex);
                  }, icon: Icon(Icons.remove))
                ],
              )),
        ),
        NoteBarChartHorizontal(tableId: tableId, viewIndex: viewIndex)
      ],
    );
  }
}
