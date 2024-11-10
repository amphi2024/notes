import 'package:flutter/material.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/note.dart';

class ParsedContents extends StatelessWidget {

  final Note note;
  const ParsedContents({super.key, required this.note});

  @override
  Widget build(BuildContext context) {

    List<Widget> children = [];

    for(Content content in note.contents) {
      if(content.type == "text") {
        if(content.style != null) {

          Map<String, dynamic> style = content.style!;
          children.add(
              Text(
                content.value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: style.containsKey("color") ? Color(int.parse( style["color"].substring(1) , radix: 16)) :  Theme.of(context).textTheme.bodyMedium!.color,
                  fontSize: style.containsKey("size") ? 20: 15,
                  fontWeight: style.containsKey("bold") ? FontWeight.bold : FontWeight.normal
                ),
              )
          );
        }
        else {
          children.add(
              Text(
                content.value.trim(),
                overflow: TextOverflow.ellipsis,
              )
          );
        }

      }
      else if(content.type == "img") {
        // children.add(
        //     Image.file(File("${note.appStorage.imagesPath}/${content.value}"))
        // );
      }
      else if(content.type == "video") {
        // VideoPlayerController videoPlayerController = VideoPlayerController.file(File("${note.videosPath}/${content.value}"));
        // children.add(
        //     FutureBuilder(
        //       future: videoPlayerController.initialize(),
        //       builder: (context, snapshot) {
        //         return AspectRatio(
        //             aspectRatio: videoPlayerController.value.aspectRatio,
        //             child: VideoPlayer(videoPlayerController));
        //       }
        //     )
        // );
      }
    }


    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 800,
        minHeight: 0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
