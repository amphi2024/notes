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
  late var imageHeight = MediaQuery.of(context).size.height;
  var toolbarVisible = false;
  Timer? timer;

  var controller = TransformationController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
  var left = 0.0;
  var top = 0.0;

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
              left: 0,
              top: 0,
              bottom: 0,
              right: 0,
              child: InteractiveViewer(
                maxScale: 30,
                transformationController: controller,
                scaleEnabled: true,
                panEnabled: true,
                child: Image.file(
                  fit: BoxFit.contain,
                  File(widget.path),
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
                                  controller.value = Matrix4.identity()..scale(1.0);
                                });
                              }),
                          IconButton(
                              icon: Icon(Icons.zoom_out),
                              onPressed: () {
                                timer?.cancel();
                                toolbarVisible = true;
                                setState(() {
                                  if(controller.value.getMaxScaleOnAxis() > 1.0) {
                                    controller.value = Matrix4.identity()..scale(controller.value.getMaxScaleOnAxis() - 0.01);
                                  }
                                });
                              }),
                          IconButton(
                              icon: Icon(Icons.zoom_in),
                              onPressed: () {
                                timer?.cancel();
                                toolbarVisible = true;
                                setState(() {
                                  controller.value = Matrix4.identity()..scale(controller.value.getMaxScaleOnAxis() + 0.01);
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
