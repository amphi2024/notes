import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/note_image.dart';
import '../../utils/image_utils.dart';

class WideImagePage extends StatefulWidget {
  final String filename;
  final String noteId;
  const WideImagePage({super.key, required this.filename, required this.noteId});

  @override
  State<WideImagePage> createState() => _WideImagePageState();
}

class _WideImagePageState extends State<WideImagePage> with TickerProviderStateMixin {

  final photoTransformController = TransformationController();
  late AnimationController _buttonsController;
  late Animation<Offset> buttonsSlide;

  bool _isFullScreen = false;

  @override
  void dispose() {
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    photoTransformController.dispose();
    super.dispose();
  }

  void setFullScreen(bool value) {
    if(value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      setState(() {
        _buttonsController.reverse();
        _isFullScreen = true;
      });
    }
    else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      setState(() {
        _buttonsController.forward();
        _isFullScreen = false;
      });
    }
  }

  @override
  void initState() {
    _buttonsController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    buttonsSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _buttonsController,
        curve: Curves.easeOutQuint,
        reverseCurve: Curves.easeInQuint,
      ),
    );

    _buttonsController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(125, 0, 0, 0),
        body: Stack(
          children: [
          Positioned.fill(
            child: InteractiveViewer(
              maxScale: 30,
              transformationController: photoTransformController,
              scaleEnabled: true,
              panEnabled: true,
              minScale: 0.1,
              onInteractionEnd: (d) {
                if(d.scaleVelocity > 1.0) {
                  setFullScreen(true);
                }
                else {
                  setFullScreen(false);
                }
              },
              child: Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: widget.filename,
                  child: NoteImage(filename: widget.filename, noteId: widget.noteId),
                ),
              ),
            ),
          ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: buttonsSlide,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8, bottom: 8 + MediaQuery.of(context).padding.bottom),
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(180, 0, 0, 0),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                          shareNoteImage(widget.noteId, widget.filename);
                        }, icon: const Icon(
                          Icons.share,
                          size: 15,
                          color: Colors.white,
                        )),
                        IconButton(
                            onPressed: () {
                              exportNoteImage(widget.noteId, widget.filename, context);
                            }, icon: const Icon(
                          Icons.save,
                          size: 15,
                          color: Colors.white,
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            )
        ],),
      ),
    );
  }
}
