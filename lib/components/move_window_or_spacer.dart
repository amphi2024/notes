import 'package:amphi/models/app.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class MoveWindowOrSpacer extends StatelessWidget {
  const MoveWindowOrSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    if(App.isDesktop()) {
      return MoveWindow();
    }
    return const SizedBox.shrink();
  }
}
