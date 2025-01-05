import 'dart:async';
import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/image_from_storage.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/utils/toast.dart';

class ImagePageView extends StatefulWidget {
  final String imageFilename;
  final String noteName;
  const ImagePageView({super.key, required this.imageFilename, required this.noteName});

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
    var themeData = Theme.of(context);
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
                    child: ImageFromStorage(
                        fit: BoxFit.contain,
                        imageFilename: widget.imageFilename, noteName: widget.noteName),
                  ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7.5, right: 7.5, top: MediaQuery.of(context).padding.top + 7.5),
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
                                    icon: Icon(Icons.save),
                                    onPressed: () async {
                                      String filePath = PathUtils.join(appStorage.notesPath, widget.noteName, "images" ,widget.imageFilename);
                                      File originalFile = File(filePath);
                                      var bytes = await originalFile.readAsBytes();
                                      var selectedPath = await FilePicker.platform.saveFile(
                                          fileName: "image.${FilenameUtils.extensionName(widget.imageFilename)}",
                                        bytes: bytes
                                      );
                                      if(selectedPath != null) {
                                        var file = File(selectedPath);
                                        await file.writeAsBytes(bytes);
                                        showToast(context, AppLocalizations.of(context).get("@toast_message_image_export_success"));
                                      }
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
                              ],
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
