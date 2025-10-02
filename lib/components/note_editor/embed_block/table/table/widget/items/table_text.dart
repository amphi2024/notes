import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/dialogs/table_text_dialog.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/items/table_edit_button.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/items/table_item.dart';

class TableText extends TableItem {

  final String text;
  const TableText(
      {super.key,
      required this.text,
      required super.addColumnAfter,
      required super.addColumnBefore,
      required super.addRowBefore,
      required super.addRowAfter,
      required super.removeColumn,
      required super.removeRow,
      required super.onEdit,
      required super.removeValue});

  @override
  Widget build(BuildContext context) {
    // if (appState.noteEditingController.readOnly) {
    //   return Padding(
    //     padding: const EdgeInsets.all(7.5),
    //     child: SelectableText(text),
    //   );
    // }
    return GestureDetector(
        onTap: () async {
          String? result = await showDialog(
              context: context,
              builder: (context) {
                return TableTextDialog(text: text);
              });
          if(result != null) {
            Map<String, dynamic> map = {
              "text": result
            };
            onEdit(map);
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
