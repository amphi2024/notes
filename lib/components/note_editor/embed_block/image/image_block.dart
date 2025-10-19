import 'package:flutter/material.dart';
import 'package:notes/components/note_image.dart';
import 'package:notes/pages/image/image_page.dart';

class ImageBlock extends StatefulWidget {
  final String filename;
  final String noteId;
  const ImageBlock({super.key, required this.filename, required this.noteId});

  @override
  State<ImageBlock> createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  @override
  Widget build(BuildContext context) {
     return Align(
       alignment: Alignment.centerLeft,
       child: GestureDetector(
         onTap: () {
           Focus.of(context).unfocus();
           Navigator.of(context).push(
             PageRouteBuilder(
               opaque: false,
               pageBuilder: (context, animation, secondaryAnimation) {
                 return ImagePage(noteId: widget.noteId, filename: widget.filename);
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
           ).then((value) {
             Focus.of(context).unfocus();
           });
         },
         child: Hero(
           tag: widget.filename,
           child: NoteImage(
             noteId: widget.noteId,
             filename: widget.filename,
             fit: BoxFit.contain,
           ),
         ),
       ),
     );
  }
}