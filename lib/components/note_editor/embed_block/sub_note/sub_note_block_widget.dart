import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/sub_note/edit_sub_note_dialog.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/models/note_embed_blocks.dart';

class SubNoteBlockWidget extends StatefulWidget {
  final String noteKey;
  final bool readOnly;
  const SubNoteBlockWidget({super.key, required this.noteKey, required this.readOnly});

  @override
  State<SubNoteBlockWidget> createState() => _SubNoteBlockWidgetState();
}

class _SubNoteBlockWidgetState extends State<SubNoteBlockWidget> {
  late NoteEditingController noteEditingController = noteEmbedBlocks.getSubNote(widget.noteKey);
  bool showing = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
                icon: Icon(showing ? Icons.arrow_drop_down : Icons.arrow_right, size: 20),
                onPressed: () {
                  setState(() {
                    showing = !showing;
                  });
                }),
            Text(noteEditingController.note.title),
            Visibility(
              visible: !widget.readOnly,
              child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          noteEditingController.readOnly = false;
                          return EditSubNoteDialog(noteEditingController: noteEditingController);
                        });
                  }),
            ),
          ],
        ),
        Visibility(
            visible: showing,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 7.5, top: 7.5),
              child: NoteEditor(noteEditingController: noteEditingController),
            )),
      ],
    );
  }
}

// extension _SubDocumentBackground on Color {
//   Color toSubNoteBackground() {
//     if(red + blue + green > 516) {
//       return Color.fromARGB(alpha, red - 10, green - 10, blue  - 10);
//     }
//     else {
//       return Color.fromARGB(alpha, red + 10, green + 10, blue  + 10);
//     }
//
//   }
// }
