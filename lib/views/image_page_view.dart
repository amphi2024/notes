import 'dart:async';
import 'dart:io';

import 'package:amphi/models/app.dart';
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
  late var imageHeight = MediaQuery.of(context).size.height;
  var toolbarVisible = false;
  Timer? timer;

  var verticalController = ScrollController();
  var horizontalController = ScrollController();

  @override
  void dispose() {
    verticalController.dispose();
    horizontalController.dispose();
    super.dispose();
  }

  void toggleToolbarVisible() {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: 2000), () {
      setState(() {
        toolbarVisible = false;
      });
    });
    setState(() {
      toolbarVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: MouseRegion(
        onHover: (e) {
          toggleToolbarVisible();
        },
        child: Stack(
          children: [
            Positioned(
              left: -100,
              right: -100,
              bottom: -100,
              top: -100,
              child: GestureDetector(
                onScaleStart: (ScaleStartDetails details) {
                  _previousScale = _scale;
                },
                onScaleUpdate: (ScaleUpdateDetails details) {
                  toggleToolbarVisible();
                  setState(() {
                    imageHeight += details.scale;
                  });
                },
                onScaleEnd: (ScaleEndDetails details) {
                  if (imageHeight < screenHeight) {
                    setState(() {
                      imageHeight = screenHeight;
                    });
                  }
                },
                child: AnimatedContainer(
                  height: imageHeight,
                  curve: Curves.easeOutQuint,
                  duration: Duration(milliseconds: 200),
                  child: Image.file(
                    fit: BoxFit.contain,
                    File(widget.path),
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Visibility(
                  visible: toolbarVisible,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(AppIcons.back)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: Icon(Icons.zoom_in_map),
                              onPressed: () {
                                timer?.cancel();
                                toolbarVisible = true;
                                setState(() {
                                  imageHeight = screenHeight;
                                });
                              }),
                          IconButton(
                              icon: Icon(Icons.zoom_out),
                              onPressed: () {
                                timer?.cancel();
                                toolbarVisible = true;
                                setState(() {
                                  if (imageHeight > screenHeight) {
                                    imageHeight -= 5;
                                  }
                                  else {
                                    imageHeight = screenHeight;
                                  }
                                });
                              }),
                          IconButton(
                              icon: Icon(Icons.zoom_in),
                              onPressed: () {
                                timer?.cancel();
                                toolbarVisible = true;
                                setState(() {
                                  imageHeight += 5;
                                });
                              })
                        ],
                      )

                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
