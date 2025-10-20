import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/popup_menu_item.dart';
import 'package:notes/extensions/sort_extension.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/icons/icons.dart';

import '../../models/app_storage.dart';

class TrashViewPopupMenuButton extends StatelessWidget {
  const TrashViewPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    Color accentColor = Theme.of(context).colorScheme.primary;
    return PopupMenuButton(
        // icon: Icon(
        //   appSettings.viewMode == "linear" ? AppIcons.linear : AppIcons.grid,
        // ),
        itemBuilder: (context) {
          return [
          //   CustomPopupMenuItem.title(
          //       label: AppLocalizations.of(context).get("@popup_menu_leading_view_as"), color: Theme.of(context).colorScheme.primary),
          //   CustomPopupMenuItem.withIcon(
          //       label: AppLocalizations.of(context).get("@popup_menu_item_grid"),
          //       icon: AppIcons.grid,
          //       color: appSettings.viewMode == "linear" ? textColor : accentColor,
          //       onTap: () {
          //         // appState.notifySomethingChanged(() {
          //         //   appSettings.viewMode = "linear";
          //         // });
          //         appSettings.save();
          //       }),
          //   CustomPopupMenuItem.withIcon(
          //       label: AppLocalizations.of(context).get("@popup_menu_item_list"),
          //       icon: AppIcons.linear,
          //       color: appSettings.viewMode == "grid" ? textColor : accentColor,
          //       onTap: () {
          //         // appState.notifySomethingChanged(() {
          //         //   appSettings.viewMode = "grid";
          //         // });
          //         appSettings.save();
          //       }),
          //   CustomPopupMenuItem.title(
          //       label: AppLocalizations.of(context).get("@popup_menu_leading_sort_by"), color: Theme.of(context).colorScheme.primary),
          //   CustomPopupMenuItem.text(
          //       label: AppLocalizations.of(context).get("@title"),
          //       color: appSettings.sortBy == "title" ? accentColor : textColor,
          //       icon: appSettings.descending ? Icons.arrow_downward : Icons.arrow_upward,
          //       iconEnabled: appSettings.sortBy == "title",
          //       onTap: () {
          //         // appState.notifySomethingChanged(() {
          //         //   appSettings.setSortOption("title");
          //         //   appStorage.notes.updateAll((home, list) {
          //         //     list.sortByOption();
          //         //     return list;
          //         //   });
          //         // });
          //         appSettings.save();
          //       }),
          //   CustomPopupMenuItem.text(
          //       label: AppLocalizations.of(context).get("@created_date"),
          //       color: appSettings.sortBy == "created" ? accentColor : textColor,
          //       icon: appSettings.descending ? Icons.arrow_upward : Icons.arrow_upward,
          //       iconEnabled: appSettings.sortBy == "created",
          //       onTap: () {
          //         // appState.notifySomethingChanged(() {
          //         //   appSettings.setSortOption("created");
          //         //   appStorage.notes.updateAll((home, list) {
          //         //     list.sortByOption();
          //         //     return list;
          //         //   });
          //         // });
          //         appSettings.save();
          //       }),
          //   CustomPopupMenuItem.text(
          //       label: AppLocalizations.of(context).get("@modified_date"),
          //       color: appSettings.sortBy == "modified" ? accentColor : textColor,
          //       icon: appSettings.descending ? Icons.arrow_upward : Icons.arrow_upward,
          //       iconEnabled: appSettings.sortBy == "modified",
          //       onTap: () {
          //         // appState.notifySomethingChanged(() {
          //         //   appSettings.setSortOption("modified");
          //         //   appStorage.notes.updateAll((home, list) {
          //         //     list.sortByOption();
          //         //     return list;
          //         //   });
          //         // });
          //         appSettings.save();
          //       }),
          //   CustomPopupMenuItem.text(
          //       label: AppLocalizations.of(context).get("@deleted_date"),
          //       color: appSettings.sortBy == "deleted" ? accentColor : textColor,
          //       icon: appSettings.descending ? Icons.arrow_upward : Icons.arrow_upward,
          //       iconEnabled: appSettings.sortBy == "deleted",
          //       onTap: () {
          //         // appState.notifySomethingChanged(() {
          //         //   appSettings.setSortOption("deleted");
          //         //   appStorage.notes.updateAll((home, list) {
          //         //     list.sortByOption();
          //         //     return list;
          //         //   });
          //         // });
          //       })
          ];
        });
  }
}
