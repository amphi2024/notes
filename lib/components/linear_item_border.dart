import 'package:flutter/material.dart';

class LinearItemBorder {
  BorderRadius borderRadius = BorderRadius.zero;
  late BorderSide borderSide;

  LinearItemBorder({
    required int index, required int length, required BuildContext context
  }) {
    borderSide = BorderSide(
    color: Theme.of(context).dividerColor,
    width: 1,
    );
    if(index == 0) {
      borderRadius = const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight:  Radius.circular(0), bottomLeft: Radius.circular(0));
    }
    else if(index == length - 1) {
      borderRadius = const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomRight:  Radius.circular(15), bottomLeft: Radius.circular(15));
      borderSide = const BorderSide(
        color: Colors.transparent,
        width: 1,
      );
    }
    if(length == 1) {
      borderRadius = BorderRadius.circular(15);
      borderSide = const BorderSide(
        color: Colors.transparent,
        width: 1,
      );
    }
  }
}
