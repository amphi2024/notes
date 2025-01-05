import 'package:flutter/material.dart';
import 'package:notes/components/main/floating_button/titled_floating_button.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/main.dart';
import 'package:notes/models/icons.dart';

class FloatingNoteButton extends StatelessWidget {

  final bool showing;
  final void Function() onPressed;
  const FloatingNoteButton({super.key, required this.showing, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  AnimatedPositioned(
        duration: Duration(milliseconds: showing? 1000 : 1250),
        curve: Curves.easeOutQuint,
        right: showing ? 20 : -160,
        bottom: bottomPaddingIfAndroid3Button(context) + 95,
        child: TitledFloatingButton(
          icon: AppIcons.note,
          title: AppLocalizations.of(context).get("@note"),
          onPressed: onPressed,
        ));
  }
}
