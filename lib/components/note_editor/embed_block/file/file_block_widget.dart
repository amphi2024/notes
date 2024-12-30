import 'package:amphi/models/app.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/note_embed_blocks.dart';

class FileBlockWidget extends StatelessWidget {

  final String blockKey;
  const FileBlockWidget({super.key, required this.blockKey});

  @override
  Widget build(BuildContext context) {
    var model = noteEmbedBlocks.getFile(blockKey);
    var themeData = Theme.of(context);

    Widget downloadButtonOrSomething =  IconButton(onPressed: () {}, icon: Icon(Icons.download));
    if(!model.uploaded) {
      downloadButtonOrSomething = CircularProgressIndicator();
    }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.basic,
              child: Container(
                width: App.isWideScreen(context) ? 350 : 250,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: themeData.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: themeData.shadowColor,
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(model.label, style: themeData.textTheme.bodyLarge, maxLines: 1,overflow: TextOverflow.ellipsis,),
                      ),
                    ),
                    downloadButtonOrSomething
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  }
}