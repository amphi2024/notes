import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/components/main/buttons/account_button.dart';
import 'package:notes/components/note_editor/embed_block/file/file_block_embed.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/app_storage.dart';

class NoteEditorFileButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorFileButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.attach_file),
      onPressed: () async {
        if(appStorage.selectedUser.token.isNotEmpty) {
          var result = await FilePicker.platform.pickFiles(allowMultiple: true);
          if(result != null) {
            for(var platformFile in result.files) {
              // Need to create something to check for duplicate files later.
              var file = platformFile.xFile;
              final block = BlockEmbed.custom(
                FileBlockEmbed(file.path),
              );
              noteEditingController.insertBlock(block);
            }
          }
        }
        else {
          onAccountButtonPressed(context);
        }
      },
    );
  }
}
