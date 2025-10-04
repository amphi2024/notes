import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/app_cache_data.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/sort_option.dart';
import 'package:notes/providers/notes_provider.dart';

import '../icons/icons.dart';
import 'main/choose_folder_dialog.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';

List<Widget> appbarActions({
  required BuildContext context,
  required List<String>? selectedNotes,
  required WidgetRef ref,
  required Note folder
}) {
  if (selectedNotes != null) {
    return [
      IconButton(
          icon: const Icon(AppIcons.move),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return ChooseFolderDialog();
                });
          }),
      IconButton(
          icon: const Icon(AppIcons.trash),
          onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return ConfirmationDialog(
                  title: "@dialog_title_move_to_trash",
                  onConfirmed: () {
                    // setState(() {
                    //   AppStorage.moveSelectedNotesToTrash(widget.location);
                    // });
                  },
                );
              }))
    ];
  }

  return [
    PopupMenuButton(
        icon: Icon(
          appCacheData.viewMode(folder.id) == "linear" ? AppIcons.linear : AppIcons.grid,
        ),
        itemBuilder: (context) {
          return [
            _header(context: context, label: AppLocalizations.of(context).get("@popup_menu_leading_view_as")),
            _viewModeButton(label: AppLocalizations.of(context).get("@popup_menu_item_grid"), context: context, folder: folder, icon: AppIcons.grid, viewMode: "grid"),
            _viewModeButton(label: AppLocalizations.of(context).get("@popup_menu_item_list"), context: context, folder: folder, icon: AppIcons.linear, viewMode: "linear"),
            _header(context: context, label: AppLocalizations.of(context).get("@popup_menu_leading_sort_by")),

            _sortButton(context: context, label: AppLocalizations.of(context).get("@title"), folder: folder, sortOption: SortOption.title, sortOptionDescending: SortOption.titleDescending, ref: ref),
            _sortButton(context: context, label: AppLocalizations.of(context).get("@created_date"), folder: folder, sortOption: SortOption.created, sortOptionDescending: SortOption.createdDescending, ref: ref),
            _sortButton(context: context, label: AppLocalizations.of(context).get("@modified_date"), folder: folder, sortOption: SortOption.modified, sortOptionDescending: SortOption.modifiedDescending, ref: ref)
          ];
        })
  ];
}

PopupMenuItem _header({required String label, required BuildContext context}) {
  return PopupMenuItem(
    height: 25,
    enabled: false,
    child: Text(label,
        style: TextStyle(
            color: Theme.of(context).highlightColor,
            fontSize: 12
        )
    ),
  );
}

PopupMenuItem _viewModeButton({required String label, required BuildContext context, required Note folder, required IconData icon, required String viewMode}) {
  return PopupMenuItem(
      height: 40,
      onTap: () {
        appCacheData.setViewMode(id: folder.id, value: viewMode);
        appCacheData.save();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                color: appCacheData.viewMode(folder.id) == viewMode ? Theme.of(context).highlightColor : Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 15
            ),
          ),
          Icon(
            icon,
            size: 20,
            color: appCacheData.viewMode(folder.id) == viewMode ? Theme.of(context).highlightColor : Theme.of(context).textTheme.bodyMedium?.color,
          )
        ],
      ));
}

PopupMenuItem _sortButton({required String label, required BuildContext context, required Note folder, required String sortOption, required String sortOptionDescending, required WidgetRef ref}) {
  final currentSortOption = appCacheData.sortOption(folder.id);
  return PopupMenuItem(
    height: 40,
    onTap: () {
      if(currentSortOption == sortOption) {
        appCacheData.setSortOption(sortOption: sortOptionDescending, id: folder.id);
      }
      else {
        appCacheData.setSortOption(sortOption: sortOption, id: folder.id);
      }

      appCacheData.save();
      ref.read(notesProvider.notifier).sortNotes(folder.id);
    },
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                color: currentSortOption == sortOption || currentSortOption == sortOptionDescending ? Theme.of(context).highlightColor : Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 15
            ),
          ),
          if(currentSortOption == sortOption || currentSortOption == sortOptionDescending) ... [
            Icon(
              appCacheData.sortOption(folder.id) == sortOption ? Icons.arrow_upward : Icons.arrow_downward,
              size: 20,
              color: appCacheData.sortOption(folder.id).contains(sortOption) ? Theme.of(context).highlightColor : Theme.of(context).textTheme.bodyMedium?.color,
            )
          ]
        ])
  );
}