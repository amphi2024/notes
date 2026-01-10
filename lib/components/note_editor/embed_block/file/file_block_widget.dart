import 'dart:io';
import 'dart:typed_data';

import 'package:amphi/models/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/file_model.dart';
import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/providers/note_files_provider.dart';
import 'package:notes/utils/screen_size.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../channels/app_web_channel.dart';
import '../../../../utils/toast.dart';

class FileBlockWidget extends ConsumerWidget {
  final String filename;

  const FileBlockWidget({super.key, required this.filename});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeData = Theme.of(context);
    final model = ref.watch(noteFilesProvider)[filename] ?? FileModel(filename: filename, label: "");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.basic,
            child: Container(
              width: isTablet(context) ? 350 : 250,
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
                  () {
                    if (model.uploading || model.downloading) {
                      return CircularPercentIndicator(
                          radius: 15,
                          lineWidth: 5,
                          animation: false,
                          percent: (model.transferred / model.total).toDouble(),
                          progressColor: Theme.of(context).highlightColor);
                    }
                    return IconButton(
                        onPressed: () async {
                          final selectedPath = await FilePicker.platform.saveFile(fileName: model.label, bytes: Uint8List(0));

                          if (selectedPath != null) {
                            model.downloading = true;
                                appWebChannel.downloadNoteFile(
                                noteId: ref.watch(editingNoteProvider).note.id,
                                filename: model.filename,
                                onSuccess: () {
                                  model.downloading = false;
                                  ref.read(noteFilesProvider.notifier).insertFile(model);
                                  showToast(context, AppLocalizations.of(context).get("@toast_message_file_download_success"));
                                },
                                onFailed: (statusCode) {
                                  if (statusCode == HttpStatus.unauthorized) {
                                    showToast(context, AppLocalizations.of(context).get("@toast_message_file_download_failed_unauthorized"));
                                  } else if (statusCode == HttpStatus.notFound) {
                                    showToast(context, AppLocalizations.of(context).get("@toast_message_file_download_failed_not_found"));
                                  } else {
                                    showToast(context, AppLocalizations.of(context).get("@toast_message_file_download_failed_error"));
                                  }
                                },
                                onProgress: (received, total) {
                                  model.transferred = received;
                                  model.total = total;
                                  ref.read(noteFilesProvider.notifier).insertFile(model);
                                },
                                saveFilePath: selectedPath);
                          }
                        },
                        icon: Icon(Icons.download));
                  }()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
