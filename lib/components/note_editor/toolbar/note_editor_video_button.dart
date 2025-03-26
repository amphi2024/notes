import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/menu/popup/show_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker_ios/image_picker_ios.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:notes/components/note_editor/embed_block/video/video_block_embed.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorVideoButton extends StatelessWidget {
  final NoteEditingController noteEditingController;
  const NoteEditorVideoButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.video_camera_back_outlined),
        onPressed: () async {
          if (Platform.isIOS) {
            showMenuByRelative(context: context, items: [
              PopupMenuItem(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7.5),
                        child: Icon(Icons.photo_library),
                      ),
                      Text(AppLocalizations.of(context).get("@editor_add_image_from_photos"))
                    ],
                  ),
                  onTap: () async {
                    XFile? videoFile;
                    if (Platform.isIOS) {
                      videoFile = await ImagePickerIOS().getVideo(source: ImageSource.gallery);
                    }
                    if (videoFile != null) {
                      File file = await noteEditingController.note.createdVideoFile(videoFile.path);
                      final block = BlockEmbed.custom(
                        VideoBlockEmbed(file.path),
                      );
                      noteEditingController.insertBlock(block);
                    }
                  }),
              PopupMenuItem(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7.5),
                        child: Icon(Icons.folder),
                      ),
                      Text(AppLocalizations.of(context).get("@editor_add_image_from_files"))
                    ],
                  ),
                  onTap: () async {
                    File? file = await noteEditingController.selectedVideoFile();
                    if (file != null) {
                      final block = BlockEmbed.custom(
                        VideoBlockEmbed(file.path),
                      );
                      noteEditingController.insertBlock(block);
                    }
                  }),
            ]);
          } else {
            // appMethodChannel.selectImage();
            File? file = await noteEditingController.selectedVideoFile();
            if (file != null) {
              final block = BlockEmbed.custom(
                VideoBlockEmbed(file.path),
              );
              noteEditingController.insertBlock(block);
            }
          }
          // appMethodChannel.selectVideo();
        });
  }
}
