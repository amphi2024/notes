import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  static const int embedBlock = 0;
  static const int view = 1;

  final String videoFilename;
  final int type;
  final int position;
  final String noteFileNameOnly;
  const VideoPlayerWidget({super.key, required this.videoFilename, this.type = embedBlock, this.position = 0, required this.noteFileNameOnly});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  //  late VideoPlayerController videoPlayerController;
  //
  // late Future<void> initController;
  //
  //  bool buttonsShowing = false;
  //  bool volumeEditing = false;
  //  double position = 0;
  //  Duration duration = Duration.zero;
  //  Timer? timer;
  //  Timer? volumeTimer;
  //
  //  @override
  //  void dispose() {
  //
  //   if(videoPlayerController.value.isPlaying) {
  //     videoPlayerController.pause();
  //   }
  //   videoPlayerController.dispose();
  //    super.dispose();
  //  }
  //
  //  @override
  //  void initState() {
  //    videoPlayerController = VideoPlayerController.file(
  //        File(widget.path),
  //    );
  //    initController = videoPlayerController.initialize().then((value) {
  //      videoPlayerController.seekTo(Duration(milliseconds: widget.position));
  //    });
  //
  //    videoPlayerController.addListener(() {
  //      setState(() {
  //       // position = videoPlayerController.value.position.inSeconds.toDouble();
  //        duration = videoPlayerController.value.position;
  //      });
  //     // print(videoPlayerController.value.position);
  //    });
  //    super.initState();
  //  }
  //
  //  @override
  //  Widget build(BuildContext context) {
  //    // final screenWidth = MediaQuery.of(context).size.width;
  //    // final screenHeight = MediaQuery.of(context).size.height;
  //    return FutureBuilder(
  //        future: initController,
  //        builder: (context, snapshot) {
  //          if (snapshot.connectionState == ConnectionState.done) {
  //            return GestureDetector(
  //              behavior: HitTestBehavior.opaque,
  //              onPanStart: (d) {
  //                timer?.cancel();
  //                volumeTimer?.cancel();
  //              },
  //              onTap: () {
  //                setState(() {
  //                  buttonsShowing = !buttonsShowing;
  //                });
  //                timer = Timer(Duration(milliseconds: 2000), () {
  //                  setState(() {
  //                    buttonsShowing = false;
  //                  });
  //                });
  //              },
  //              child: AspectRatio(
  //                  aspectRatio: videoPlayerController.value.aspectRatio ,
  //                  child: Stack(
  //                    fit: StackFit.passthrough,
  //                    children: [
  //                      Positioned(
  //                          left: 0,
  //                          right: 0,
  //                          bottom: 0,
  //                          top: 0,
  //                          child: VideoPlayer(videoPlayerController)),
  //                      AnimatedOpacity(
  //                        opacity: buttonsShowing ? 1 : 0,
  //                        duration: const Duration(milliseconds: 750),
  //                        curve: Curves.easeOutQuint,
  //                        child: Stack(
  //                          children: [
  //                            Positioned(
  //                                left: 0,
  //                                right: 0,
  //                                bottom: 0,
  //                                top: 0,
  //                                child: Container(
  //                                  color: AppTheme.black.withOpacity(0.3),
  //                                )),
  //                            Positioned(
  //                                left: 10,
  //                                bottom: 50,
  //                                child: IconButton(
  //                                  icon: Icon(
  //                                    videoPlayerController.value.volume >= 0.5 ? Icons.volume_up :
  //                                    videoPlayerController.value.volume >= 0.1 ? Icons.volume_down : Icons.volume_mute,
  //                                    color: Colors.white,
  //                                  ),
  //                                  onPressed: () {
  //                                    setState(() {
  //                                      volumeEditing = !volumeEditing;
  //                                    });
  //                                    if(volumeEditing) {
  //                                      Timer(Duration(milliseconds: 2000), () {
  //                                        setState(() {
  //                                          volumeEditing = false;
  //                                        });
  //                                      });
  //                                    }
  //                                  },
  //                                )),
  //                            Positioned(
  //                                left: 50,
  //                                bottom: 50,
  //                                child: Visibility(
  //                                  visible: volumeEditing,
  //                                  child: Slider(
  //                                    onChanged: (value) {
  //                                      if(volumeEditing) {
  //                                        videoPlayerController.setVolume(value);
  //                                      }
  //                                    },
  //                                    onChangeEnd: (value) {
  //                                      if(volumeEditing) {
  //                                        setState(() {
  //                                          volumeEditing = false;
  //                                        });
  //                                      }
  //                                    },
  //                                    value: videoPlayerController.value.volume,
  //                                    max: 1,
  //                                  ),
  //                                )),
  //                            Positioned(
  //                                right: 10,
  //                                bottom: 50,
  //                                child: widget.type == VideoPlayerWidget.view ? IconButton(
  //                                  icon: const Icon(
  //                                    Icons.crop_rotate,
  //                                    color: Colors.white,
  //                                  ),
  //                                  onPressed: () {
  //                                    appMethodChannel.rotateScreen();
  //                                  },
  //                                ) :
  //                                IconButton(
  //                                  icon: const Icon(
  //                                    Icons.zoom_out_map,
  //                                    color: Colors.white,
  //                                  ),
  //                                  onPressed: () {
  //                                    if(videoPlayerController.value.isPlaying) {
  //                                      videoPlayerController.pause();
  //                                    }
  //                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                                      return VideoPlayerView(
  //                                        path: widget.path,
  //                                        position: videoPlayerController.value.position.inMilliseconds,
  //                                      );
  //                                    }));
  //                                  },
  //                                ),
  //                            ),
  //                            Positioned(
  //                                left: 0,
  //                                right: 0,
  //                                bottom: 0,
  //                                top: 0,
  //                                child: Row(
  //                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                  crossAxisAlignment: CrossAxisAlignment.center,
  //                                  children: [
  //                                    IconButton(
  //                                      icon: const Icon(
  //                                          Icons.rotate_left,
  //                                        color: Colors.white,
  //                                      ),
  //                                      onPressed: () async {
  //                                        Duration currentPosition = videoPlayerController.value.position;
  //                                        Duration targetPosition = currentPosition - const Duration(seconds: 5);
  //                                        videoPlayerController.seekTo(targetPosition);
  //                                      },
  //                                    ),
  //                                    IconButton(
  //                                      icon: Icon(
  //                                        videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
  //                                        color: Colors.white,),
  //                                      onPressed: () {
  //                                        if(buttonsShowing) {
  //                                          if(videoPlayerController.value.isPlaying) {
  //                                            videoPlayerController.pause();
  //                                          }
  //                                          else {
  //                                            setState(() {
  //                                              videoPlayerController.play();
  //                                            });
  //                                          }
  //                                          Future.delayed(const Duration(milliseconds: 2000),() {
  //                                            setState(() {
  //                                              buttonsShowing = false;
  //                                            });
  //                                          });
  //                                        }
  //                                        else {
  //                                          setState(() {
  //                                            buttonsShowing = true;
  //                                          });
  //                                        }
  //                                      },
  //                                    ),
  //                                    IconButton(
  //                                      icon: const Icon(
  //                                          Icons.rotate_right,
  //                                        color: Colors.white,
  //                                      ),
  //                                      onPressed: () {
  //                                        Duration currentPosition = videoPlayerController.value.position;
  //                                        Duration targetPosition = currentPosition + const Duration(seconds: 5);
  //                                        videoPlayerController.seekTo(targetPosition);
  //                                      },
  //                                    ),
  //                                  ],
  //                                )),
  //                            Positioned(
  //                              left: 10,
  //                              right: 10,
  //                              bottom: 0,
  //                              child: Row(
  //                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                children: [
  //                                  DurationWidget(
  //                                          duration: videoPlayerController.value.position,
  //                                  ),
  //                                  Expanded(child: Slider(
  //                                    onChanged: (d) {
  //                                      setState(() {
  //                                        duration = Duration(milliseconds: d.toInt());
  //                                      });
  //                                    },
  //                                    onChangeEnd: (d) {
  //                                      videoPlayerController.seekTo(
  //                                          Duration(milliseconds: d.toInt()));
  //                                    },
  //                                    value: duration.inMilliseconds.toDouble(),
  //                                    max: videoPlayerController.value.duration.inMilliseconds.toDouble(),
  //                                  )),
  //                                  DurationWidget(
  //                                    duration: videoPlayerController.value.duration,
  //                                  ),
  //                                ],
  //                              ),
  //                            )
  //                          ],
  //                        ),
  //                      ),
  //
  //                    ],
  //                  )),
  //            );
  //          } else {
  //            return const Center(child: CircularProgressIndicator());
  //          }
  //        });

  // }
  // void moveToTime(d) async {
  //   videoPlayerController.seekTo(Duration(seconds: d.toInt()));
  //   videoPlayerController.play();
  // }

  late final controller = VideoPlayerController.file(File(widget.noteFileNameOnly));

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(controller);
    // return VideoPlayer(
    //     path: PathUtils.join(appStorage.notesPath, widget.noteFileNameOnly, "videos", widget.videoFilename),
    //     errorBuilder: () {
    //       appWebChannel.downloadVideo(noteName: widget.noteFileNameOnly, filename: widget.videoFilename);
    //
    //       return VideoPlayerNetwork(
    //         url: "${appWebChannel.serverAddress}/notes/${widget.noteFileNameOnly}/videos/${widget.videoFilename}",
    //         headers: {"Authorization": appWebChannel.token},
    //       );
    //     });
  }
}
