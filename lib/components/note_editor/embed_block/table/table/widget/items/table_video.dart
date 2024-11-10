import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/items/table_edit_button.dart';
import 'package:notes/components/note_editor/embed_block/video/video_player_widget.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';

class TableVideo extends StatelessWidget {

  final String filename;
  final void Function() addColumnAfter;
  final void Function() addColumnBefore;
  final void Function() addRowBefore;
  final void Function() addRowAfter;
  final void Function() removeColumn;
  final void Function() removeRow;
  final void Function() removeValue;
  const TableVideo({super.key, required this.filename, required this.addColumnAfter, required this.addColumnBefore, required this.addRowBefore, required this.addRowAfter, required this.removeColumn, required this.removeRow, required this.removeValue});

  @override
  Widget build(BuildContext context) {
    String noteFilename = appState.noteEditingController.note.filename;
    String videoPath = "${appStorage.notesPath}/${noteFilename}/videos/$filename";
    if(appState.noteEditingController.readOnly) {
      return Padding(
          padding: EdgeInsets.all(7.5),
          child: VideoPlayerWidget(path: videoPath));
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
          VideoPlayerWidget(path: videoPath),
        ],
      ),
    );

  }
}
