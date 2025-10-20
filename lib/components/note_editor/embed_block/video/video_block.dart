import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/services/videos_service.dart';

import '../../../../utils/byte_utils.dart';

class VideoBlock extends StatefulWidget {
  final String noteId;
  final String filename;

  const VideoBlock({super.key, required this.filename, required this.noteId});

  @override
  State<VideoBlock> createState() => _VideoBlockState();
}

class _VideoBlockState extends State<VideoBlock> {

  int? _total;
  int? _received;

  @override
  void initState() {
    videosService.get(widget.filename).player.stream.error.listen((event) {
      if(appSettings.useOwnServer) {
        appWebChannel.downloadNoteVideo(id: widget.noteId, filename: widget.filename, onSuccess: () {
          setState(() {
            _total = null;
            _received = null;
            videosService.refresh(widget.filename);
          });
        }, onProgress: (received, total) {
          setState(() {
            _total = total;
            _received = received;
          });
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_total != null && _received != null) {
      return Column(
        children: [
          LinearProgressIndicator(value: _received! / _total!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(formatBytes(_received!)), Text(formatBytes(_total!))],
          )
        ],
      );
    }

    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Video(
        height: width / (16 / 9),
        controller: videosService.get(widget.filename).controller);
  }
}
