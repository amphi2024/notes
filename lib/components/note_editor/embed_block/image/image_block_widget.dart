
import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/image_from_storage.dart';
import 'package:notes/views/image_page_view.dart';

class ImageBlockWidget extends StatefulWidget {
  final String imageFilename;
  final String noteName;
  const ImageBlockWidget({super.key, required this.imageFilename, required this.noteName});

  @override
  State<ImageBlockWidget> createState() => _ImageBlockWidgetState();
}

class _ImageBlockWidgetState extends State<ImageBlockWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onLongPress: () {},
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ImagePageView(noteName: widget.noteName, imageFilename: widget.imageFilename,);
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
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

            // showMenuByRelative(context: context, items: [
            //   menuItem(context, "@image_action_resize", Icons.settings, () {}),
            //   menuItem(context, "@image_action_share", Icons.share, () {}),
            //   menuItem(context, "@image_action_copy", Icons.copy, () {}),
            //   menuItem(context, "@image_action_save", Icons.save, () async {
            //     var bytes = await File(absolutePath).readAsBytes();
            //     String? selectedPath = await FilePicker.platform
            //         .saveFile(fileName: "image.${FilenameUtils.extensionName(widget.imageFilename)}", type: FileType.image, bytes: bytes);
            //
            //     if (selectedPath != null) {
            //       if (App.isDesktop()) {
            //         File file = File(selectedPath);
            //         file.writeAsBytes(bytes);
            //       }
            //     }
            //   }),
            //   menuItem(context, "@image_action_zoom", Icons.zoom_in, () {
            //
            //     // Navigator.push(context, Route(builder: (context) {
            //     //   return Center(
            //     //
            //     //   );
            //     // }));
            //   }),
            //   menuItem(context, "@image_action_remove", Icons.delete, () {}),
            // ]);
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 250
            ),
            child: ImageFromStorage(
              noteName: widget.noteName,
              imageFilename: widget.imageFilename,
              fit: BoxFit.contain,
            ),
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
          child: Icon(
            icon,
            // color: Theme.of(context).textTheme.bodyMedium!.color!,
          ),
        ),
        Text(AppLocalizations.of(context).get(titleKey))
      ]));
}
