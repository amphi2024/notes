import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/providers/tables_provider.dart';
import 'table_text_dialog.dart';
import '../buttons/table_add_button.dart';
import '../buttons/table_edit_button.dart';

class TableText extends ConsumerWidget {

  final String tableId;
  final String text;
  final bool readOnly;
  final int rowIndex;
  final int colIndex;

  const TableText({super.key,
    required this.readOnly, required this.text, required this.rowIndex, required this.colIndex, required this.tableId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if(readOnly) {
      return Padding(
        padding: const EdgeInsets.all(7.5),
        child: Text(text),
      );
    }

    if(text.isEmpty) {
      return Row(
        children: [
          TableAddButton(tableId: tableId, colIndex: colIndex, rowIndex: rowIndex),
          TableEditButton(tableId: tableId, colIndex: colIndex, rowIndex: rowIndex)
        ],
      );
    }

    return GestureDetector(
        onTap: () async {
          String? result = await showDialog(
              context: context,
              builder: (context) {
                return TableTextDialog(text: text);
              });
          if (result is String) {
            final map = {
              "text": result
            };
            ref.read(tablesProvider.notifier).setValue(id: tableId, rowIndex: rowIndex, colIndex: colIndex, value: map);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(7.5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  softWrap: true,
                  maxLines: 5,
                ),
              ),
              TableEditButton(tableId: tableId, rowIndex: rowIndex, colIndex: colIndex)
            ],
          ),
        ));
  }
}
