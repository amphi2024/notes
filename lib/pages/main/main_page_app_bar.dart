import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/notes_view_sort_menu.dart';
import 'package:notes/models/app_cache_data.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/sort_option.dart';
import 'package:notes/providers/notes_provider.dart';

import '../../icons/icons.dart';
import '../../dialogs/choose_folder_dialog.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';

import '../../providers/selected_notes_provider.dart';

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
                  return ChooseFolderDialog(folderId: folder.id);
                });
          }),
      IconButton(
          icon: const Icon(AppIcons.trash),
          onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return ConfirmationDialog(
                  title: AppLocalizations.of(context).get("@dialog_title_move_to_trash"),
                  onConfirmed: () {
                    final selectedNotes = ref.watch(selectedNotesProvider);
                    if(selectedNotes != null) {
                      for(var id in selectedNotes) {
                        final note = ref.watch(notesProvider).notes.get(id);
                        note.deleted = DateTime.now();
                        note.save();
                      }

                      ref.read(notesProvider.notifier).moveNotes(selectedNotes, folder.id, "!TRASH");
                      ref.read(selectedNotesProvider.notifier).endSelection();
                    }
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
            notesViewSortMenuHeader(context: context, label: AppLocalizations.of(context).get("@popup_menu_leading_view_as")),
            notesViewSortMenuViewModeButton(label: AppLocalizations.of(context).get("@popup_menu_item_grid"), context: context, folder: folder, icon: AppIcons.grid, viewMode: "grid", ref: ref),
            notesViewSortMenuViewModeButton(label: AppLocalizations.of(context).get("@popup_menu_item_list"), context: context, folder: folder, icon: AppIcons.linear, viewMode: "linear", ref: ref),
            notesViewSortMenuHeader(context: context, label: AppLocalizations.of(context).get("@popup_menu_leading_sort_by")),

            notesViewSortMenuSortButton(context: context, label: AppLocalizations.of(context).get("@title"), folderId: folder.id, sortOption: SortOption.title, sortOptionDescending: SortOption.titleDescending, ref: ref),
            notesViewSortMenuSortButton(context: context, label: AppLocalizations.of(context).get("@created_date"), folderId: folder.id, sortOption: SortOption.created, sortOptionDescending: SortOption.createdDescending, ref: ref),
            notesViewSortMenuSortButton(context: context, label: AppLocalizations.of(context).get("@modified_date"), folderId: folder.id, sortOption: SortOption.modified, sortOptionDescending: SortOption.modifiedDescending, ref: ref)
          ];
        })
  ];
}