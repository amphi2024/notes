import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_data.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorViewPagerButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorViewPagerButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.view_array), onPressed: () {
      String viewPagerKey = noteEditingController.note.generatedViewPagerKey();
      noteEditingController.note.viewPagers[viewPagerKey] = ViewPagerData();
      BlockEmbed blockEmbed = BlockEmbed.custom(
          ViewPagerBlockEmbed(viewPagerKey)
      );
      noteEditingController.insertBlock(blockEmbed);
    });
  }
}
