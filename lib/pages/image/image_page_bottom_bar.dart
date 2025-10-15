import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/pages/image/image_page.dart';
import 'package:notes/utils/attachment_path.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/toast.dart';

const double _iconSize = 25;

class ImagePageBottomBar extends ConsumerWidget {

  final String noteId;
  final String filename;
  const ImagePageBottomBar({super.key, required this.noteId, required this.filename});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Container(
      height: imagePageTitleBarHeight + MediaQuery.of(context).padding.bottom,
      color: Theme
          .of(context)
          .appBarTheme
          .backgroundColor,
      child:  Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () async {
              final params = ShareParams(
                files: [XFile(noteImagePath(noteId, filename))],
              );

              await SharePlus.instance.share(params);
            }, icon: const Icon(
              Icons.share,
              size: _iconSize,
            )),
            IconButton(
                onPressed: () async {
                  final originalFile = File(noteImagePath(noteId, filename));
                  var bytes = await originalFile.readAsBytes();
                  var selectedPath = await FilePicker.platform.saveFile(
                      fileName: "image.${FilenameUtils.extensionName(filename)}",
                      bytes: bytes
                  );
                  if(selectedPath != null) {
                    var file = File(selectedPath);
                    await file.writeAsBytes(bytes);
                    showToast(context, AppLocalizations.of(context).get("@toast_message_image_export_success"));
                  }
                }, icon: const Icon(
              Icons.save,
              size: _iconSize,
            )),
          ],
        ),
      ),
    );
  }
}