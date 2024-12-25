import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/menu/popup/show_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker_ios/image_picker_ios.dart';
import 'package:image_picker_macos/image_picker_macos.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:notes/components/note_editor/embed_block/image/image_block_embed.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorImageButton extends StatelessWidget {
  final NoteEditingController noteEditingController;
  const NoteEditorImageButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.image),
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
                    XFile? image;
                    image = await ImagePickerIOS().getImage(source: ImageSource.gallery);
                    // if (Platform.isIOS) {
                    //   image = await ImagePickerIOS().getImage(source: ImageSource.gallery);
                    // } else {
                    //   image = await ImagePickerMacOS().getImage(source: ImageSource.gallery);
                    // }
                    if (image != null) {
                      File file = await noteEditingController.note.createdImageFile(image.path);
                      final block = BlockEmbed.custom(
                        ImageBlockEmbed(file.path),
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
                    var files = await noteEditingController.selectedImageFiles();
                    for(var file in files) {
                      final block = BlockEmbed.custom(
                        ImageBlockEmbed(file.path),
                      );
                      noteEditingController.insertBlock(block);
                    }
                  }),
            ]);
          } else {
            var files = await noteEditingController.selectedImageFiles();
            for(var file in files) {
              final block = BlockEmbed.custom(
                ImageBlockEmbed(file.path),
              );
              noteEditingController.insertBlock(block);
            }
          }
        });
  }
}
