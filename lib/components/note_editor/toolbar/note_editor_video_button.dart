import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/menu/popup/show_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_ios/image_picker_ios.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:notes/components/note_editor/editor_extension.dart';
import 'package:notes/components/note_editor/embed_block/video/video_block_embed.dart';
import 'package:notes/providers/editing_note_provider.dart';

import '../../../utils/select_file_utils.dart';

class NoteEditorVideoButton extends ConsumerWidget {
  final QuillController controller;
  final double iconSize;
  const NoteEditorVideoButton({super.key, required this.controller, required this.iconSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final note = ref.watch(editingNoteProvider).note;

    return IconButton(
        icon: Icon(Icons.video_camera_back_outlined, size: iconSize),
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
                      Text(AppLocalizations.of(context).get(
                          "@editor_add_image_from_photos"))
                    ],
                  ),
                  onTap: () async {
                    XFile? videoFile;
                    if (Platform.isIOS) {
                      videoFile = await ImagePickerIOS().getVideo(
                          source: ImageSource.gallery);
                    }
                    if (videoFile != null) {
                      File file = await createdVideoFile(note.id,
                          videoFile.path);
                      final block = BlockEmbed.custom(
                        VideoBlockEmbed(file.path),
                      );
                      controller.insertBlock(block);
                    }
                  }),
              PopupMenuItem(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7.5),
                        child: Icon(Icons.folder),
                      ),
                      Text(AppLocalizations.of(context).get(
                          "@editor_add_image_from_files"))
                    ],
                  ),
                  onTap: () async {
                    File? file = await selectedVideoFile(note.id);
                    if (file != null) {
                      final block = BlockEmbed.custom(
                        VideoBlockEmbed(file.path),
                      );
                      controller.insertBlock(block);
                    }
                  }),
            ]);
          } else {
            File? file = await selectedVideoFile(note.id);
            if (file != null) {
              final block = BlockEmbed.custom(
                VideoBlockEmbed(file.path),
              );
              controller.insertBlock(block);
            }
          }
          // appMethodChannel.selectVideo();
        });
  }
}
