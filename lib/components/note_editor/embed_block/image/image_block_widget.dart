
import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_image.dart';
import 'package:notes/pages/image_page.dart';

class ImageBlockWidget extends StatefulWidget {
  final String filename;
  final String noteId;
  final bool readOnly;
  const ImageBlockWidget({super.key, required this.filename, required this.noteId, required this.readOnly});

  @override
  State<ImageBlockWidget> createState() => _ImageBlockWidgetState();
}

class _ImageBlockWidgetState extends State<ImageBlockWidget> {
  @override
  Widget build(BuildContext context) {
  // if(widget.readOnly) {
     return Align(
       alignment: Alignment.centerLeft,
       child: GestureDetector(
         onLongPress: () {},
         onTap: () {
           Navigator.of(context).push(
             PageRouteBuilder(
               opaque: false,
               pageBuilder: (context, animation, secondaryAnimation) {
                 return ImagePage(noteName: widget.noteId, imageFilename: widget.filename);
               },
               transitionsBuilder:
                   (context, animation, secondaryAnimation, child) {
                 return FadeTransition(
                   opacity: animation,
                   child: child,
                 );
               },
               transitionDuration: const Duration(milliseconds: 300),
             ),
           );
         },
         child: Hero(
           tag: widget.noteId,
           child: NoteImage(
             noteId: widget.noteId,
             filename: widget.filename,
             fit: BoxFit.contain,
           ),
         ),
       ),
     );
//   }
   // else {
   //   return Align(
   //     alignment: Alignment.centerLeft,
   //     child: MouseRegion(
   //       cursor: SystemMouseCursors.basic,
   //       child: Stack(
   //         children: [
   //           SizedBox(
   //             width: 250,
   //             child: ImageFromStorage(
   //               noteName: widget.noteName,
   //               imageFilename: widget.imageFilename,
   //               fit: BoxFit.contain,
   //             ),
   //           ),
   //           Positioned(
   //             left: 200,
   //               top: 5,
   //               child: Container(
   //                 width: 5,
   //                 height: 10,
   //                 decoration: BoxDecoration(
   //                   color: Colors.white
   //                 ),
   //               )),
   //         ],
   //       ),
   //     ),
   //   );
   // }
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
