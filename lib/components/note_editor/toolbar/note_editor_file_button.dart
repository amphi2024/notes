import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorFileButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorFileButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.attach_file),
      onPressed: () async {
        var result = await FilePicker.platform.pickFiles(allowMultiple: true);
        if(result != null) {

        }
      },
    );
  }
}
