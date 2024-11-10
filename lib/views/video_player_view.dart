import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/video/video_player_widget.dart';
import 'package:notes/models/app_theme.dart';

class VideoPlayerView extends StatefulWidget {

  final String path;
  final int position;
  const VideoPlayerView({super.key, required this.path, this.position = 0});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      // onPopInvoked: (value) {
      //   appMethodChannel.setPortrait();
      // },
      child: Scaffold(
        backgroundColor: AppTheme.black,
        body: Center(
          child: VideoPlayerWidget(path: widget.path, type: 1, position: widget.position,),
        ),
      ),
    );
  }
}
