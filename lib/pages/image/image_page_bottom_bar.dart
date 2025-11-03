
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/pages/image/image_page.dart';
import 'package:notes/utils/image_utils.dart';

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
            IconButton(onPressed: () {
              shareNoteImage(noteId, filename);
            }, icon: const Icon(
              Icons.share,
              size: _iconSize,
            )),
            IconButton(
                onPressed: () {
                  exportNoteImage(noteId, filename, context);
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