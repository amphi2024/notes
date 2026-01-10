import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:notes/utils/screen_size.dart';

class MoveWindowOrSpacer extends StatelessWidget {
  const MoveWindowOrSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    if(isDesktop()) {
      return MoveWindow();
    }
    return const SizedBox.shrink();
  }
}
