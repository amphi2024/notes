import 'package:amphi/utils/file_name_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_sync.dart';
import 'package:notes/channels/app_web_upload.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/note_embed_blocks.dart';

class FileBlockWidget extends StatelessWidget {

  final String blockKey;
  const FileBlockWidget({super.key, required this.blockKey});

  @override
  Widget build(BuildContext context) {
    var model = noteEmbedBlocks.getFile(blockKey);
    var themeData = Theme.of(context);

    if(model.uploaded) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.basic,
              child: Container(
                width: 300,
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
                        child: Text(model.filename, style: themeData.textTheme.bodyLarge, maxLines: 1,overflow: TextOverflow.ellipsis,),
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.download))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircularProgressIndicator()
          ],
        ),
      );
    }

  }
}