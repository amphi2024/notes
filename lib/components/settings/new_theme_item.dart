import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/settings/edit_theme_dialog.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme.dart';

class NewThemeItem extends StatelessWidget {
  final void Function(AppTheme) onSave;
  const NewThemeItem({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    String filename = FilenameUtils.generatedFileName("theme", AppStorage.getInstance().themesPath);
                    return EditThemeDialog(
                        appTheme: AppTheme(
                            filename: filename,
                            created: DateTime.now(),
                            modified: DateTime.now(),
                            path: PathUtils.join(appStorage.themesPath, filename)),
                        onSave: onSave);
                  });
            },
            child: Container(
              width: 100,
              height: 100,
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
        Text(AppLocalizations.of(context).get("@new_theme"))
      ],
    );
  }
}
