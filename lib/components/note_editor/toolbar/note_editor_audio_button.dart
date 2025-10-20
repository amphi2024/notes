import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_editor/editor_extension.dart';

import '../../../providers/editing_note_provider.dart';
import '../../../utils/select_file_utils.dart';
import '../embed_block/audio/audio_block_embed.dart';

class NoteEditorAudioButton extends ConsumerWidget {

  final QuillController controller;

  const NoteEditorAudioButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final note = ref.watch(editingNoteProvider).note;

    return IconButton(
      icon: Icon(Icons.audiotrack, size: 30),
      onPressed: () async {
        var files = await selectedAudioFiles(note.id);
        for (var file in files) {
          final block = BlockEmbed.custom(
            AudioBlockEmbed(file.path),
          );
          controller.insertBlock(block);
        }
      },
    );
  }
}
