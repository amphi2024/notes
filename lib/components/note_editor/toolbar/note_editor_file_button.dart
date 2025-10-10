import 'dart:io';
import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/random_string.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/components/note_editor/editor_extension.dart';
import 'package:notes/components/note_editor/embed_block/file/file_block_embed.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/file_in_note.dart';
import 'package:notes/models/note_embed_blocks.dart';
import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/utils/toast.dart';

class NoteEditorFileButton extends ConsumerWidget {

  final QuillController controller;

  const NoteEditorFileButton({super.key, required this.controller});

  String generatedFileNameCompareToList(String fileType,
      List<Map<String, dynamic>> list) {
    String name = randomString(15, 8) + fileType;
    bool exists = false;
    for (var map in list) {
      if (map["filename"] == name) {
        exists = true;
        break;
      }
    }
    if (exists) {
      return generatedFileNameCompareToList(fileType, list);
    }
    else {
      return name;
    }
  }

  void pickFilesAndInsert(List<Map<String, dynamic>> list) async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      for (int i = 0; i < result.files.length; i++) {
        var file = result.files[i].xFile;

        var filename = generatedFileNameCompareToList(
            ".${FilenameUtils.extensionName(file.name)}", list);

        var fileModel = FileInNote(
            filename: filename, originalPath: file.path, label: file.name);
        var blockKey = noteEmbedBlocks.generatedFileKey();
        noteEmbedBlocks.files[blockKey] = fileModel;

        // appWebChannel.uploadFile(noteName: appState.noteEditingController.note.name, filename: fileModel.filename, filePath: file.path ,onSuccess: () {
        //   appState.notifySomethingChanged(() {
        //     noteEmbedBlocks.getFile(blockKey).originalPath = null;
        //   });
        // });
        final block = BlockEmbed.custom(
          FileBlockEmbed(blockKey),
        );
        controller.insertBlock(block);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.attach_file, size: 30),
      onPressed: () async {
        if (appSettings.useOwnServer) {
          appWebChannel.getFiles(noteId: ref.watch(editingNoteProvider).note.id, onSuccess: (list) async {
            pickFilesAndInsert(list);
          }, onFailed: (statusCode) {
            if (statusCode == HttpStatus.notFound) {
              pickFilesAndInsert([]);
            }
            else {
              showToast(context,
                  AppLocalizations.of(context).get("@failed_to_connect"));
            }
          });
        }
        else {
          showToast(context,
              AppLocalizations.of(context).get("@please_set_server_address"));
        }
      },
    );
  }
}
