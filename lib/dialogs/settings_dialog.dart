import 'package:flutter/material.dart';
import 'package:notes/models/app_settings.dart';

import '../views/settings_view.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        appSettings.save();
      },
      child: Dialog(
        child: SizedBox(
          width: 450,
          height: 550,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, icon: Icon(Icons.cancel_outlined))
                ],
              ),
              Expanded(child: SettingsView()),
            ],
          ),
        ),
      ),
    );
  }
}