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
import 'package:notes/models/file_model.dart';
import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/providers/note_files_provider.dart';
import 'package:notes/utils/toast.dart';

class NoteEditorFileButton extends ConsumerStatefulWidget {
  final double iconSize;
  final QuillController controller;

  const NoteEditorFileButton({super.key, required this.controller, required this.iconSize});

  @override
  NoteEditorFileButtonState createState() => NoteEditorFileButtonState();
}

class NoteEditorFileButtonState extends ConsumerState<NoteEditorFileButton> {
  String generatedFilename(String fileExtension,
      Set<Map<String, dynamic>> list) {
    String name = randomString(15, 8) + fileExtension;
    bool exists = false;
    for (var map in list) {
      if (map["filename"] == name) {
        exists = true;
        break;
      }
    }
    if (exists) {
      return generatedFilename(fileExtension, list);
    }
    else {
      return name;
    }
  }

  void pickFilesAndInsert(Set<Map<String, dynamic>> list) async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      for (int i = 0; i < result.files.length; i++) {
        final file = result.files[i].xFile;

        final filename = generatedFilename(
            ".${FilenameUtils.extensionName(file.name)}", list);

        final fileModel = FileModel(
            filename: filename, originalPath: file.path, label: file.name);

        ref.read(noteFilesProvider.notifier).insertFile(fileModel);

        appWebChannel.uploadNoteFile(noteId: ref.watch(editingNoteProvider).note.id, fileModel: fileModel, onSuccess: () {
          fileModel.originalPath = null;
          ref.read(noteFilesProvider.notifier).insertFile(fileModel);
        }, onFailed: (code) {

        }, onProgress: (sent, total) {
          fileModel.total = total;
          fileModel.transferred = sent;
          ref.read(noteFilesProvider.notifier).insertFile(fileModel);
        });

        final block = BlockEmbed.custom(
          FileBlockEmbed(filename),
        );
        widget.controller.insertBlock(block);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.attach_file, size: widget.iconSize),
      onPressed: () async {
        if (appSettings.useOwnServer) {
          appWebChannel.getFiles(noteId: ref
              .watch(editingNoteProvider)
              .note
              .id, onSuccess: (files) async {
            pickFilesAndInsert(files);
          }, onFailed: (statusCode) {
            if (statusCode == HttpStatus.notFound) {
              pickFilesAndInsert({});
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
