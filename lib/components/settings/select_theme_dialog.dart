import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/settings/edit_theme_dialog.dart';
import 'package:notes/components/settings/create_theme_button.dart';
import 'package:notes/components/settings/theme_item.dart';
import 'package:notes/main.dart';
import 'package:notes/models/app_settings.dart';

import 'package:notes/models/theme_model.dart';

import '../../providers/themes_provider.dart';

class SelectThemeDialog extends ConsumerStatefulWidget {
  const SelectThemeDialog({super.key});

  @override
  ConsumerState<SelectThemeDialog> createState() => _SelectThemeDialogState();
}

class _SelectThemeDialogState extends ConsumerState<SelectThemeDialog> {

  late Brightness brightness = Theme.of(context).brightness;

  @override
  Widget build(BuildContext context) {
    final idList = ref.watch(themesProvider).idList;

    return Dialog(
      child: SizedBox(
        width: 375,
        height: 600,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(brightness == Brightness.light ? Icons.light_mode : Icons.dark_mode_outlined),
                    onPressed: () {
                      setState(() {
                        brightness = brightness == Brightness.light ? Brightness.dark : Brightness.light;
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.cancel_outlined),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0, // Spacing between rows
                  ),
                  itemCount: idList.length + 2,
                  itemBuilder: (context, index) {
                    if (index == idList.length + 1) {
                      return CreateThemeButton();
                    } else if (index == 0) {
                      return GestureDetector(
                          onTap: () {
                            mainScreenKey.currentState?.setState(() {
                              appSettings.themeModel = ThemeModel(created: DateTime.now(), modified: DateTime.now());
                            });
                            Navigator.pop(context);
                          },
                          child: ThemeItem(id: "", brightness: brightness));
                    } else {
                      final id = idList[index - 1];
                      final themeModel = ref.watch(themesProvider).themes.get(id);
                      return GestureDetector(
                          onTap: () {
                            mainScreenKey.currentState?.setState(() {
                              appSettings.themeModel = ThemeModel.copy(themeModel);
                            });
                            Navigator.pop(context);
                          },
                          onLongPress: () {
                            showDialog(context: context, builder: (context) {
                              return EditThemeDialog(themeModel: themeModel, showDeleteButton: true);
                            });
                          },
                          child: ThemeItem(id: id, brightness: brightness));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
