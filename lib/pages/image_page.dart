import 'dart:async';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/components/image_from_storage.dart';

import 'package:notes/icons/icons.dart';


class ImagePage extends StatefulWidget {
  final String imageFilename;
  final String noteName;
  const ImagePage({super.key, required this.imageFilename, required this.noteName});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  late var imageHeight = MediaQuery.of(context).size.height;
  var toolbarVisible = false;
  Timer? timer;

  var controller = TransformationController();
  bool isFullscreen = false;

  void fullscreenListener(bool fullscreen) {
    setState(() {
      isFullscreen = fullscreen;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    appMethodChannel.fullScreenListeners.remove(fullscreenListener);
    super.dispose();
  }

  @override
  void initState() {
    appMethodChannel.fullScreenListeners.add(fullscreenListener);
    super.initState();
  }
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
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
    var themeData = Theme.of(context);

    List<Widget> children = [
      IconButton(
          icon: Icon(Icons.save),
          onPressed: () async {
            // String filePath = PathUtils.join(appStorage.notesPath, widget.noteName, "images" ,widget.imageFilename);
            // File originalFile = File(filePath);
            // var bytes = await originalFile.readAsBytes();
            // var selectedPath = await FilePicker.platform.saveFile(
            //     fileName: "image.${FilenameUtils.extensionName(widget.imageFilename)}",
            //     bytes: bytes
            // );
            // if(selectedPath != null) {
            //   var file = File(selectedPath);
            //   await file.writeAsBytes(bytes);
            //   showToast(context, AppLocalizations.of(context).get("@toast_message_image_export_success"));
            // }
          }),
      IconButton(
          icon: Icon(Icons.zoom_out),
          onPressed: () {
            timer?.cancel();
            toolbarVisible = true;
            setState(() {
              controller.value = Matrix4.identity()..scale(controller.value.getMaxScaleOnAxis() - 0.01);
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
    ];

    if(Platform.isWindows) {
      var colors = WindowButtonColors(
        iconMouseOver: Theme.of(context).textTheme.bodyMedium?.color,
        mouseOver: Color.fromRGBO(125, 125, 125, 0.1),
        iconNormal: Theme.of(context).textTheme.bodyMedium?.color,
        mouseDown: Color.fromRGBO(125, 125, 125, 0.1),
        iconMouseDown: Theme.of(context).textTheme.bodyMedium?.color,
      );
      children.add(  MinimizeWindowButton(
        colors: colors,
      ));
      children.add(   appWindow.isMaximized
          ? RestoreWindowButton(
        onPressed: maximizeOrRestore,
        colors: colors,
      )
          : MaximizeWindowButton(
        onPressed: maximizeOrRestore,
        colors: colors,

      ));
      children.add(CloseWindowButton());
    }

    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(
          color: themeData.iconTheme.color,
          size: 30
        )
      ),
      child: Scaffold(
        body: MouseRegion(
          onHover: (e) {
            toggleToolbarVisible();
          },
          child: GestureDetector(
            onTap: () {
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
                    minScale: 0.5,
                    child: Hero(
                      tag: widget.noteName,
                      child: ImageFromStorage(
                          fit: BoxFit.contain,
                          filename: widget.imageFilename, noteId: widget.noteName),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(left: isFullscreen || !Platform.isMacOS ? 7.5 : 77.5, right: 7.5, top: MediaQuery.of(context).padding.top + 7.5),
                      child: Visibility(
                        visible: toolbarVisible,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(AppIcons.times)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: children,
                            )

                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
