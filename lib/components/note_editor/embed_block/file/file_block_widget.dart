import 'dart:io';

import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/models/file_in_note.dart';
import 'package:notes/models/note_embed_blocks.dart';
import 'package:notes/utils/toast.dart';

class FileBlockWidget extends StatelessWidget {

  final String blockKey;
  const FileBlockWidget({super.key, required this.blockKey});

  void downloadFile( BuildContext context,  FileInNote fileInNote) async {

        // appWebChannel.downloadFile(
        //   noteName: appState.noteEditingController.note.name,
        //   filename: fileInNote.filename,
        //   onSuccess: (bytes) async {
        //    var selectedPath =  await FilePicker.platform.saveFile(
        //         fileName: fileInNote.label,
        //       bytes: bytes
        //     );
        //
        //    if(selectedPath != null) {
        //      var file = File(selectedPath);
        //      await file.writeAsBytes(bytes);
        //      showToast(context, AppLocalizations.of(context).get("@toast_message_file_download_success"));
        //    }
        //   },
        //   onFailed: (statusCode) {
        //     if(statusCode == HttpStatus.unauthorized) {
        //       showToast(context, AppLocalizations.of(context).get("@toast_message_file_download_failed_unauthorized"));
        //     }
        //     else if(statusCode == HttpStatus.notFound) {
        //       showToast(context, AppLocalizations.of(context).get("@toast_message_file_download_failed_not_found"));
        //     }
        //     else {
        //       showToast(context, AppLocalizations.of(context).get("@toast_message_file_download_failed_error"));
        //     }
        //   }
        // );

  }

  @override
  Widget build(BuildContext context) {
    var model = noteEmbedBlocks.getFile(blockKey);
    var themeData = Theme.of(context);

    Widget downloadButtonOrSomething =  IconButton(onPressed: () {
      downloadFile(context, model);
    }, icon: Icon(Icons.download));
    if(!model.uploaded) {
      downloadButtonOrSomething = CircularProgressIndicator();
    }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.basic,
              child: Container(
                width: App.isWideScreen(context) ? 350 : 250,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: themeData.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: themeData.shadowColor,
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectableText(
                            model.label,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    downloadButtonOrSomething
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  }
}