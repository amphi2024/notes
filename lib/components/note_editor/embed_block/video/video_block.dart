import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:notes/utils/attachment_path.dart';

class VideoBlock extends StatefulWidget {
  final String filename;
  final String noteId;
  const VideoBlock({super.key, required this.filename, required this.noteId});

  @override
  State<VideoBlock> createState() => _VideoBlockState();
}

class _VideoBlockState extends State<VideoBlock> {

  late final Player player;
  late final VideoController controller;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    player = Player();
    controller = VideoController(player);
    player.open(Media(noteVideoPath(widget.noteId, widget.filename)), play: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Video(
        height: width / (16 / 9),
        controller: controller);
  }
}
