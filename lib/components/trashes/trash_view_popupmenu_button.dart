import 'package:flutter/material.dart';
import 'package:notes/components/main/popup_menu_item.dart';
import 'package:notes/extensions/sort_extension.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/icons.dart';

class TrashViewPopupMenuButton extends StatelessWidget {

  const TrashViewPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {

    Color textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    Color accentColor = Theme.of(context).colorScheme.primary;
    return  PopupMenuButton(
        icon: Icon(
          appSettings.fragmentIndex == 0
              ? AppIcons.linear
              : AppIcons.grid,
        ),
        itemBuilder: (context) {
          return [
            CustomPopupMenuItem.title(label: AppLocalizations.of(context).get("@popup_menu_leading_view_as"), color: Theme.of(context).colorScheme.primary),
            CustomPopupMenuItem.withIcon(
                label: AppLocalizations.of(context).get("@popup_menu_item_grid"),
                icon: AppIcons.grid,
                color: appSettings.fragmentIndex == 0 ? textColor : accentColor,
                onTap: () {
                  appState.notifySomethingChanged(() {
                    appSettings.fragmentIndex = 1;
                  });
                  appSettings.save();
                }
            ),
            CustomPopupMenuItem.withIcon(
                label: AppLocalizations.of(context).get("@popup_menu_item_list"),
                icon: AppIcons.linear,
                color: AppSettings.getInstance().fragmentIndex == 1 ? textColor : accentColor,
                onTap: () {
                  appState.notifySomethingChanged(() {
                    AppSettings.getInstance().fragmentIndex = 0;
                  });
                  AppSettings.getInstance().save();
                }
            ),

            CustomPopupMenuItem.title(label: AppLocalizations.of(context).get("@popup_menu_leading_sort_by"), color: Theme.of(context).colorScheme.primary),
            CustomPopupMenuItem.text(
                label: AppLocalizations.of(context).get("@title"),
                color: AppSettings.getInstance().sortOption == SORT_OPTION_TITLE ? accentColor : textColor,
                icon: AppSettings.getInstance().reverseSorting ?  Icons.arrow_downward : Icons.arrow_upward,
                iconEnabled: AppSettings.getInstance().sortOption == SORT_OPTION_TITLE,
                onTap: () {
                  appState.notifySomethingChanged(() {
                    AppSettings.getInstance().setSortOption(SORT_OPTION_TITLE);
                    AppStorage.getInstance().notes.updateAll((home, list) {
                      list.sortByOption();
                      return list;
                    });
                  });
                  AppSettings.getInstance().save();
                }
            ),
            CustomPopupMenuItem.text(
                label: AppLocalizations.of(context).get("@created_date"),
                color: AppSettings.getInstance().sortOption == SORT_OPTION_CREATE_DATE ? accentColor : textColor,
                icon: AppSettings.getInstance().reverseSorting ?  Icons.arrow_upward : Icons.arrow_upward,
                iconEnabled:  AppSettings.getInstance().sortOption == SORT_OPTION_CREATE_DATE,
                onTap: () {
                  appState.notifySomethingChanged(() {
                    AppSettings.getInstance().setSortOption(SORT_OPTION_CREATE_DATE);
                    AppStorage.getInstance().notes.updateAll((home, list) {
                      list.sortByOption();
                      return list;
                    });
                  });
                  AppSettings.getInstance().save();
                }
            ),
            CustomPopupMenuItem.text(
                label: AppLocalizations.of(context).get("@modified_date"),
                color: AppSettings.getInstance().sortOption == SORT_OPTION_MODIFIED_DATE ? accentColor : textColor,
                icon: AppSettings.getInstance().reverseSorting ?  Icons.arrow_upward : Icons.arrow_upward,
                iconEnabled:  AppSettings.getInstance().sortOption == SORT_OPTION_MODIFIED_DATE,
                onTap: () {
                  appState.notifySomethingChanged(() {
                    AppSettings.getInstance().setSortOption(SORT_OPTION_MODIFIED_DATE);
                    AppStorage.getInstance().notes.updateAll((home, list) {
                      list.sortByOption();
                      return list;
                    });
                  });
                  AppSettings.getInstance().save();
                }
            ),
            CustomPopupMenuItem.text(
                label: AppLocalizations.of(context).get("@deleted_date"),
                color: AppSettings.getInstance().sortOption == SORT_OPTION_DELETED_DATE ? accentColor : textColor,
                icon: AppSettings.getInstance().reverseSorting ?  Icons.arrow_upward : Icons.arrow_upward,
                iconEnabled:  AppSettings.getInstance().sortOption == SORT_OPTION_DELETED_DATE,
                onTap: () {
                  appState.notifySomethingChanged(() {
                    AppSettings.getInstance().setSortOption(SORT_OPTION_DELETED_DATE);
                    AppStorage.getInstance().notes.updateAll((home, list) {
                      list.sortByOption();
                      return list;
                    });
                  });
                }
            )
          ];
        });
  }
}
