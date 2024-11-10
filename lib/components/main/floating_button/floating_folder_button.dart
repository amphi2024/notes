import 'package:flutter/material.dart';
import 'package:notes/components/main/floating_button/titled_floating_button.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/icons.dart';

class FloatingFolderButton extends StatelessWidget {

  final bool showing;
  final void Function() onPressed;
  const FloatingFolderButton({super.key, required this.showing, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  AnimatedPositioned(
      duration: Duration(milliseconds: showing ? 1250 : 1000),
      curve: Curves.easeOutQuint,
      right: showing ? 20 : -160,
      bottom: 170,
      child: TitledFloatingButton(
        title: AppLocalizations.of(context).get("@folder"),
        icon: AppIcons.folder,
        onPressed: onPressed,
      ),
    );
  }
}
