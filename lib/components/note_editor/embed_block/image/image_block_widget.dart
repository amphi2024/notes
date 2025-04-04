
import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/image_from_storage.dart';
import 'package:notes/views/image_page_view.dart';

class ImageBlockWidget extends StatefulWidget {
  final String imageFilename;
  final String noteName;
  final bool readOnly;
  const ImageBlockWidget({super.key, required this.imageFilename, required this.noteName, required this.readOnly});

  @override
  State<ImageBlockWidget> createState() => _ImageBlockWidgetState();
}

class _ImageBlockWidgetState extends State<ImageBlockWidget> {
  @override
  Widget build(BuildContext context) {
  // if(widget.readOnly) {
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
           },
           child: ImageFromStorage(
             noteName: widget.noteName,
             imageFilename: widget.imageFilename,
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
