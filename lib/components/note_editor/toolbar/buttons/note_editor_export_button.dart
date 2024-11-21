import 'package:amphi/widgets/menu/popup/show_menu.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorExportButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorExportButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_upward, size: 20), onPressed: () {
      showMenuByRelative(context: context, items: [
        PopupMenuItem(child: Text("HTML"))
      ]);
    });
  }
}
