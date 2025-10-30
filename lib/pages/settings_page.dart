import 'package:flutter/material.dart';
import 'package:notes/components/draggable_page.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/icons/icons.dart';
import 'package:notes/views/settings_view.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return DraggablePage(
      canPopPage: true,
      onPopInvoked: (value, result) {

      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 300,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     const Icon(
                      AppIcons.back,
                      size: 25,
                    ),
                    Text(AppLocalizations.of(context).get("@settings"))
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SettingsView()
      ),
    );
  }
}