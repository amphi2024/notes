import 'package:amphi/utils/file_name_utils.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/image/image_block_widget.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/items/table_edit_button.dart';
import 'package:notes/models/app_state.dart';

class TableImage extends StatelessWidget {
  final String filename;
  final void Function() addColumnAfter;
  final void Function() addColumnBefore;
  final void Function() addRowBefore;
  final void Function() addRowAfter;
  final void Function() removeColumn;
  final void Function() removeRow;
  final void Function() removeValue;
  final bool readOnly;
  const TableImage(
      {super.key,
      required this.filename,
      required this.addColumnAfter,
      required this.addColumnBefore,
      required this.addRowBefore,
      required this.addRowAfter,
      required this.removeColumn,
      required this.removeRow,
      required this.removeValue, required this.readOnly});

  @override
  Widget build(BuildContext context) {
    if (appState.noteEditingController.readOnly) {
      return Padding(
          padding: EdgeInsets.all(7.5),
          child: ImageBlockWidget(
            noteName: FilenameUtils.nameOnly(appState.noteEditingController.note.filename),
            imageFilename: filename,
            readOnly: readOnly,
          ));
    }

    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: Column(
        children: [
          TableEditButton(
              addColumnAfter: addColumnAfter,
              addColumnBefore: addColumnBefore,
              addRowBefore: addRowBefore,
              addRowAfter: addRowAfter,
              removeColumn: removeColumn,
              removeRow: removeRow,
              clearCell: removeValue),
          ImageBlockWidget(
            noteName: FilenameUtils.nameOnly(appState.noteEditingController.note.filename),
            imageFilename: filename,
            readOnly: readOnly,
          )
        ],
      ),
    );
  }
}
