import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/sub_note/sub_note_block_embed.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/note_embed_blocks.dart';

class NoteEditorSubNoteButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorSubNoteButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
    icon: Icon(Icons.note_add),
  onPressed: () {
    String subNoteKey = noteEmbedBlocks.generatedSubNoteKey();
    noteEmbedBlocks.subNotes[subNoteKey] = NoteEditingController(note: Note.createdNote("!SubNote"));
    BlockEmbed blockEmbed = BlockEmbed.custom(
        SubNoteBlockEmbed(subNoteKey)
      );
     noteEditingController.insertBlock(blockEmbed);
  },
    );
  }
}
