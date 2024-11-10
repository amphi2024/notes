import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/models/icons.dart';

class ImagePageView extends StatefulWidget {

  final String path;
  const ImagePageView({super.key, required this.path});

  @override
  State<ImagePageView> createState() => _ImagePageViewState();
}

class _ImagePageViewState extends State<ImagePageView> {

  double _scale = 1.0; // 기본 확대/축소 비율
  double _previousScale = 1.0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(AppIcons.back)),
        actions: [
          IconButton(icon: Icon(Icons.zoom_out), onPressed: () {
            setState(() {
              _scale -= 0.1;
            });
          }),
          IconButton(icon: Icon(Icons.zoom_in), onPressed: () {
            setState(() {
              _scale += 0.1;
            });
          })
        ],
      ),
      body: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          _previousScale = _scale;
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            _scale = _previousScale * details.scale;
          });
        },
        onScaleEnd: (ScaleEndDetails details) {
          _previousScale = 1.0;
        },
        child: Center(
          child: Transform.scale(
            scale: _scale,
            child: Image.file(
              fit: BoxFit.contain,
                File(widget.path)
            ),
          )
        ),
      ),
    );
  }
}
