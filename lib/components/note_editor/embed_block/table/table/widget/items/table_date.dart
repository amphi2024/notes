import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/items/table_item.dart';
import 'package:notes/models/app_state.dart';
import 'table_edit_button.dart';

class TableDate extends TableItem {
  final int date;
  const TableDate({super.key, required this.date, required super.addColumnAfter, required super.addColumnBefore, required super.addRowBefore, required super.addRowAfter, required super.removeColumn, required super.removeRow, required super.onEdit, required super.removeValue});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date).toLocal();
    if (appState.noteEditingController.readOnly) {
      return Padding(
        padding: const EdgeInsets.all(7.5),
        child: SelectableText(   DateFormat.yMMMEd(Localizations.localeOf(context).languageCode.toString()).format(dateTime),),
      );
    }
    return GestureDetector(
        onTap: () async {
          DateTime? result = await showDatePicker(context: context, firstDate: DateTime(1950), lastDate: DateTime.now());
          if(result != null) {
            onEdit({"date": result.toUtc().millisecondsSinceEpoch});
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(7.5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat.yMMMEd(Localizations.localeOf(context).languageCode.toString()).format(dateTime),
                  softWrap: true,
                  maxLines: 5,
                ),
              ),
              TableEditButton(
                  addColumnAfter: addColumnAfter,
                  addColumnBefore: addColumnBefore,
                  addRowBefore: addRowBefore,
                  addRowAfter: addRowAfter,
                  removeColumn: removeColumn,
                  removeRow: removeRow,
                  clearCell: removeValue)
            ],
          ),
        ));
  }
}
