import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/settings/edit_theme_dialog.dart';

import 'package:notes/models/theme_model.dart';
import 'package:notes/utils/generate_id.dart';
import 'package:notes/utils/screen_size.dart';


class CreateThemeButton extends StatelessWidget {
  const CreateThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final id = await generatedThemeId();
            showDialog(
                context: context,
                builder: (context) {
                  return EditThemeDialog(
                      themeModel: ThemeModel(
                          id: id));
                });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Center(
                child: Container(
                  width: isDesktopOrTablet(context) ? 100 : 70,
                  height: isDesktopOrTablet(context) ? 70 : 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, spreadRadius: 3, blurRadius: 5, offset: const Offset(0, 3))],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).disabledColor,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Text(AppLocalizations.of(context).get("@new_theme"))
      ],
    );
  }
}
