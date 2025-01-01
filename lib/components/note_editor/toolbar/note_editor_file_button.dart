import 'dart:io';

import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/random_string.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_upload.dart';
import 'package:notes/components/note_editor/embed_block/file/file_block_embed.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/file_in_note.dart';
import 'package:notes/models/note_embed_blocks.dart';
import 'package:notes/utils/toast.dart';

import '../../../models/app_state.dart';

class NoteEditorFileButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorFileButton({super.key, required this.noteEditingController});

  String generatedFileNameCompareToList(String fileType, List<Map<String, dynamic>> list) {
    String name = randomString(10) + fileType;
    bool exists = false;
    for(var map in list) {
      if(map["filename"] == name) {
        exists = true;
        break;
      }
    }
    if(exists) {
      return generatedFileNameCompareToList(fileType, list);
    }
    else {
      return name;
    }

  }

  void pickFilesAndInsert(List<Map<String, dynamic>> list) async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if(result != null) {
      for(int i = 0; i < result.files.length; i++) {

        var file = result.files[i].xFile;

        var filename = generatedFileNameCompareToList(".${FilenameUtils.extensionName(file.name)}", list);

        var fileModel = FileInNote(filename: filename, originalPath: file.path, label: file.name);
        var blockKey = noteEmbedBlocks.generatedFileKey();
        noteEmbedBlocks.files[blockKey] = fileModel;

        appWebChannel.uploadFile(noteName: appState.noteEditingController.note.name, filename: fileModel.filename, filePath: file.path ,onSuccess: () {
          appState.notifySomethingChanged(() {
            noteEmbedBlocks.getFile(blockKey).originalPath = null;
          });
        });
        final block = BlockEmbed.custom(
          FileBlockEmbed(blockKey),
        );
        noteEditingController.insertBlock(block);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.attach_file),
      onPressed: () async {
        var noteName = appState.noteEditingController.note.name;
        appWebChannel.getFiles(noteName: noteName, onSuccess: (list) async {
          pickFilesAndInsert(list);
        }, onFailed: (statusCode) {
          if(statusCode == HttpStatus.notFound) {
            pickFilesAndInsert([]);
          }
          else {
            showToast(context, "Failed to Connect");
          }
        });




      },
    );
  }
}
