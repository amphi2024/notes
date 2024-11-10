import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/models/app_theme.dart';

class ThemeItem extends StatefulWidget {
  final AppTheme appTheme;
  final VoidCallback onTap;
  final double size;
  final VoidCallback onLongPressed;
  final VoidCallback onButtonPressed;
  final void Function()? onBelowButtonPressed;
  final bool eventAllowed;
  const ThemeItem(
      {super.key,
      required this.appTheme,
      required this.onTap,
      this.size = 100,
      required this.onLongPressed,
      required this.onButtonPressed,
      this.onBelowButtonPressed,
      this.eventAllowed = true});

  @override
  State<ThemeItem> createState() => _ThemeItemState();
}

class _ThemeItemState extends State<ThemeItem> {
  bool editButtonShowing = false;
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPressed,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? widget.appTheme.lightTheme.backgroundColor
                    : widget.appTheme.darkTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 5,
                      bottom: 40,
                      right: 5,
                      left: 5,
                      child: Container(
                          decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? widget.appTheme.lightTheme.noteBackgroundColor
                            : widget.appTheme.darkTheme.noteBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  Positioned(    // button on bottom
                      right: 5,
                      bottom: 5,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onHover: (event) {
                          if( (Platform.isLinux || Platform.isMacOS || Platform.isWindows) && widget.eventAllowed) {
  setState(() {
                            editButtonShowing = true;
                          });
                          }
                        
                        },
                        onExit: (event) {
                          Future.delayed(
                            Duration(milliseconds: 1500),
                            () {
                              if (!hovering) {
                                setState(() {
                                  editButtonShowing = false;
                                });
                              }
                            },
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            if(widget.onBelowButtonPressed != null && widget.eventAllowed) {
       widget.onBelowButtonPressed!();
                            }
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness == Brightness.light
                                      ? widget.appTheme.lightTheme
                                          .floatingButtonBackground
                                      : widget.appTheme.darkTheme
                                          .floatingButtonBackground,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? widget.appTheme.lightTheme
                                          .floatingButtonIconColor
                                      : widget.appTheme.darkTheme
                                          .floatingButtonIconColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                  AnimatedPositioned(
                      duration: Duration(milliseconds: 1000),
                      bottom: 35,
                      right: editButtonShowing ? 5 : -60,
                      curve: Curves.easeOutQuint,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onHover: (event) {
                          setState(() {
                            hovering = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            hovering = false;
                            editButtonShowing = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: widget.eventAllowed ? widget.onButtonPressed : () {},
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? widget.appTheme.lightTheme
                                      .floatingButtonBackground
                                  : widget.appTheme.darkTheme
                                      .floatingButtonBackground,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? widget.appTheme.lightTheme
                                          .floatingButtonIconColor
                                      : widget.appTheme.darkTheme
                                          .floatingButtonIconColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Text(
            widget.appTheme.title,
          )
        ],
      ),
    );
  }
}
