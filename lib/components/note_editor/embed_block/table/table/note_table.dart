import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/tables_provider.dart';
import 'table_date.dart';
import 'table_image.dart';
import 'table_text.dart';
import 'table_video.dart';

class NoteTable extends ConsumerWidget {
  final bool readOnly;
  final String tableId;
  final int? viewIndex;
  const NoteTable({super.key, required this.tableId, required this.readOnly, this.viewIndex = null});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableData = ref.watch(tablesProvider)[tableId]!.data();

    List<TableRow> rows = [];
    for (int rowIndex = 0; rowIndex < tableData.data.length; rowIndex++) {
      List<TableCell> tableCells = [];
      for (int colIndex = 0; colIndex < tableData.data[rowIndex].length; colIndex++) {
        Map<String, dynamic> data = tableData.data[rowIndex][colIndex];
        if (data["img"] != null) {
          tableCells.add(TableCell(
              child: TableImage(
                filename: data["img"]!,
                colIndex: colIndex,
                rowIndex: rowIndex,
                tableId: tableId,
                readOnly: readOnly,
              )));
        } else if (data["video"] != null) {
          tableCells.add(TableCell(
              child: TableVideo(
                  filename: data["video"]!,
                  readOnly: readOnly,
              tableId: tableId,
              rowIndex: rowIndex,
              colIndex: colIndex)));
        } else if (data["date"] is int) {
          tableCells.add(TableCell(
              child: TableDate(
                dateTime: DateTime.fromMillisecondsSinceEpoch(data["date"]!).toLocal(),
              colIndex: colIndex,
              rowIndex: rowIndex,
              tableId: tableId,
              readOnly: readOnly)));
        } else {
          tableCells.add(TableCell(
              child: TableText(
                text: data["text"] ?? "",
                readOnly: readOnly,
                colIndex: colIndex,
                rowIndex: rowIndex,
                tableId: tableId
              )));
        }
      }
      rows.add(TableRow(children: tableCells));
    }

    final table = Table(
        border: TableBorder.all(color: Theme
            .of(context)
            .textTheme
            .bodyMedium!
            .color!, width: 1),
        children: rows,
    );

    if(readOnly) {
      return table;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(onPressed: () {
          if(viewIndex != null) {
            ref.read(tablesProvider.notifier).removeView(tableId, viewIndex!);
          }
          else {
            ref.read(tablesProvider.notifier).insertView(tableId, 0, {"type": "table"});
          }
        }, icon: Icon(viewIndex == null ? Icons.visibility_off : Icons.visibility)),
        table
      ],
    );
  }
}