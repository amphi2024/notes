import 'dart:io';

import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:amphi/widgets/menu/popup/show_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/image_from_storage.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/views/image_page_view.dart';

class ImageBlockWidget extends StatefulWidget {
  final String imageFilename;
  final String noteFileNameOnly;
  const ImageBlockWidget({super.key, required this.imageFilename, required this.noteFileNameOnly});

  @override
  State<ImageBlockWidget> createState() => _ImageBlockWidgetState();
}

class _ImageBlockWidgetState extends State<ImageBlockWidget> {

  @override
  Widget build(BuildContext context) {

    String absolutePath = PathUtils.join(appStorage.notesPath, widget.noteFileNameOnly, "images", widget.imageFilename);
    return Align(
      alignment: Alignment.centerLeft,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onLongPress: () {},
          onTap: () {
            showMenuByRelative(context: context, items: [
              menuItem(context, "@image_action_resize", Icons.settings, () {}),
              menuItem(context, "@image_action_share", Icons.share, () {}),
              menuItem(context, "@image_action_copy", Icons.copy, () {}),
              menuItem(context, "@image_action_save", Icons.save, () async {

                var bytes = await File(absolutePath).readAsBytes();
                String? selectedPath = await FilePicker.platform.saveFile(
                  fileName: "image.${FilenameUtils.extensionName(widget.imageFilename)}",
                  type: FileType.image,
                  bytes: bytes
                );

                if (selectedPath != null) {
                  if (App.isDesktop()) {
                    File file = File(selectedPath);
                    file.writeAsBytes(bytes);
                  }
                }
              }),
              menuItem(context, "@image_action_zoom", Icons.zoom_in, () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return ImagePageView(path: absolutePath);
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);  // 아래에서 시작
                      const end = Offset.zero;         // 최종 위치 (위)
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
                // Navigator.push(context, Route(builder: (context) {
                //   return Center(
                //
                //   );
                // }));
              }),
              menuItem(context, "@image_action_remove", Icons.delete, () {

              }),
            ]);
          },
          child: ImageFromStorage(
            noteFileNameOnly: widget.noteFileNameOnly.split(".").first,
            imageFilename: widget.imageFilename,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

PopupMenuItem menuItem(BuildContext context, String titleKey, IconData icon, void Function() onPressed) {
  return PopupMenuItem(
    onTap: onPressed,
      child: Row(children: [
    Padding(
      padding: const EdgeInsets.only(left: 5, right: 15),
      child: Icon(icon,
      // color: Theme.of(context).textTheme.bodyMedium!.color!,
        ),
    ),
    Text(AppLocalizations.of(context).get(titleKey))
  ]
  ));
}
