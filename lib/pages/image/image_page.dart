import 'dart:async';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/components/note_image.dart';

import 'package:notes/icons/icons.dart';

import '../../models/app_theme.dart';
import 'image_page_bottom_bar.dart';
import 'image_page_title_bar.dart';

const double imagePageTitleBarHeight = 40;

class ImagePage extends StatefulWidget {
  final String filename;
  final String noteId;
  const ImagePage({super.key, required this.filename, required this.noteId});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> with TickerProviderStateMixin {
  final photoTransformController = TransformationController();
  late AnimationController _bottomController;
  late Animation<Offset> _bottomSlide;

  late AnimationController _topController;
  late Animation<Offset> topSlide;

  late AnimationController _animationController;
  late Animation<Matrix4> _animation;

  bool _isFullScreen = false;

  double _dragOffset = 0.0;
  double _scale = 1.0;
  Alignment _alignment = Alignment.center;
  late Color backgroundColor = Theme
      .of(context)
      .scaffoldBackgroundColor;

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (photoTransformController.value.getMaxScaleOnAxis() > 1.2) {
      return;
    }
    setState(() {
      _dragOffset += details.delta.dy;
      _dragOffset = _dragOffset.clamp(0, 200);
      _scale = 1.0 - (_dragOffset / 400);
      _alignment = Alignment(0, _dragOffset / 400);
      backgroundColor = Color.fromRGBO(backgroundColor.red, backgroundColor.green, backgroundColor.blue, _scale);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_scale < 0.8) {
      Navigator.pop(context);
    }
    else {
      setState(() {
        _dragOffset = 0.0;
        _scale = 1.0;
        _alignment = Alignment.center;
      });
    }
  }

  @override
  void dispose() {
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    _bottomController.dispose();
    _animationController.dispose();
    photoTransformController.dispose();
    _topController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bottomController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.addListener(() {
      photoTransformController.value = _animation.value;
    });

    _bottomSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _bottomController,
        curve: Curves.easeOutQuint,
        reverseCurve: Curves.easeInQuint,
      ),
    );
    _bottomController.forward();

    _topController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    topSlide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _topController,
        curve: Curves.easeOutQuint,
        reverseCurve: Curves.easeInQuint,
      ),
    );

    _topController.forward();

    super.initState();
  }

  void animateScaleBy(Matrix4 matrix) {
    final begin = photoTransformController.value;

    _animation = Matrix4Tween(begin: begin, end: matrix).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward(from: 0);
  }

  void setFullScreen(bool value) {
    if(value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      setState(() {
        _topController.reverse();
        _bottomController.reverse();
        _isFullScreen = true;
      });
    }
    else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      setState(() {
        _topController.forward();
        _bottomController.forward();
        _isFullScreen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: _isFullScreen ? AppTheme.black : backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              onDoubleTap: () {
                if(photoTransformController.value.getMaxScaleOnAxis() > 1) {
                  animateScaleBy(Matrix4.identity());
                  setFullScreen(false);
                }
                else {
                  animateScaleBy(Matrix4.identity()..scale(1.5));
                  setFullScreen(true);
                }
              },
              onTap: () {
                setFullScreen(!_isFullScreen);
              },
              child: InteractiveViewer(
                maxScale: 30,
                transformationController: photoTransformController,
                scaleEnabled: true,
                panEnabled: true,
                minScale: 0.5,
                onInteractionUpdate: (d) {
                  if(d.scale > 1.0) {
                    setFullScreen(true);
                  }
                },
                child: AnimatedAlign(
                  alignment: _alignment,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: AnimatedScale(
                    scale: _scale,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: Hero(
                      tag: widget.noteId,
                      child: NoteImage(filename: widget.filename, noteId: widget.noteId),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SlideTransition(
                position: topSlide,
                child: const ImagePageTitleBar()
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _bottomSlide,
              child: ImagePageBottomBar(noteId: widget.noteId, filename: widget.filename),
            ),
          ),
        ],
      ),
    );
  }
}
