import 'dart:async';

import 'package:amphi/models/app.dart';
import 'package:flutter/material.dart';
import 'package:notes/services/audio_service.dart';

import '../../../../channels/app_web_channel.dart';
import '../../../../models/app_settings.dart';
import '../../../../utils/byte_utils.dart';

class AudioBlock extends StatefulWidget {
  final String noteId;
  final String filename;

  const AudioBlock({super.key, required this.noteId, required this.filename});

  @override
  State<AudioBlock> createState() => _AudioBlockState();
}

class _AudioBlockState extends State<AudioBlock> {
  double position = 0;
  int? _total;
  int? _received;

  @override
  void initState() {
    audioService.get(widget.filename).player.stream.position.listen((d) {
      setState(() {
        position = d.inMilliseconds.toDouble();
      });
    });
    audioService.get(widget.filename).player.stream.error.listen((event) {
      if(appSettings.useOwnServer) {
        appWebChannel.downloadNoteAudio(id: widget.noteId, filename: widget.filename, onSuccess: () {
          setState(() {
            _total = null;
            _received = null;
            audioService.refresh(widget.filename);
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
    final themeData = Theme.of(context);

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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        child: Container(
           width: App.isWideScreen(context) ? 450 : null,
          height: 45,
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
              IconButton(
                  onPressed: () {
                    // if (audioService.get(widget.filename).isPlaying) {
                    //   setState(() {
                    //     audioService.get(widget.filename).isPlaying = false;
                    //     audioService.get(widget.filename).player.pause();
                    //   });
                    // } else {
                    //   setState(() {
                    //     audioService.get(widget.filename).isPlaying = true;
                    //     audioService.get(widget.filename).player.resume();
                    //   });
                    // }
                    if (audioService.get(widget.filename).isPlaying) {
                      setState(() {
                        audioService.get(widget.filename).isPlaying = false;
                        audioService.get(widget.filename).player.pause();
                      });
                    } else {
                      setState(() {
                        audioService.get(widget.filename).isPlaying = true;
                        audioService.get(widget.filename).player.play();
                      });
                    }
                  },
                  icon: Icon(audioService.get(widget.filename).isPlaying ? Icons.pause : Icons.play_arrow)),
              Text(convertedDuration(position.toInt())),
              Expanded(
                child: Slider(
                    max: audioService.get(widget.filename).player.state.duration.inMilliseconds.toDouble(),
                    min: 0,
                    value: position,
                    onChanged: (value) {
                      audioService.get(widget.filename).player.seek(Duration(milliseconds: value.toInt()));
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(convertedDuration(audioService.get(widget.filename).player.state.duration.inMilliseconds)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatTime(int timeUnit) {
  return timeUnit.toString().padLeft(2, '0');
}

String convertedDuration(int totalMilliseconds) {
  int hours = totalMilliseconds ~/ (3600 * 1000);
  int remainingMinutesAndSeconds = totalMilliseconds % (3600 * 1000);
  int minutes = remainingMinutesAndSeconds ~/ (60 * 1000);
  int remainingSeconds = remainingMinutesAndSeconds % (60 * 1000);
  int seconds = remainingSeconds ~/ 1000;

  if (hours == 0) {
    if (minutes == 0) {
      return '0:${_formatTime(seconds)}';
    }
    return '${_formatTime(minutes)}:${_formatTime(seconds)}';
  }
  return '${_formatTime(hours)}:${_formatTime(minutes)}:${_formatTime(seconds)}';
}
