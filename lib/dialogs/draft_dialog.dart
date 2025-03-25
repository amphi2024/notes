import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';

class DraftDialog extends StatelessWidget {

  final void Function() onConfirmed;
  final void Function() onCanceled;
  const DraftDialog({super.key, required this.onConfirmed, required this.onCanceled});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).get("@dialog_title_draft_exists"),
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      actions: [
        TextButton(
          child: Text(
            AppLocalizations.of(context).get("@dialog_action_no"),
          ),
          onPressed: () {
            Navigator.pop(context);
            onCanceled();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            AppLocalizations.of(context).get("@dialog_action_yes"),
            style:  TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirmed();
          },
        )
      ],
    );
  }
}
