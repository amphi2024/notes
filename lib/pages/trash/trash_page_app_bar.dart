import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/notes_view_sort_menu.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/providers/selected_notes_provider.dart';

import '../../icons/icons.dart';
import '../../models/app_cache_data.dart';
import '../../models/sort_option.dart';

List<Widget> trashPageAppbarActions({required BuildContext context, required List<String>? selectedNotes, required WidgetRef ref}) {
  if (selectedNotes != null) {
    return [
      IconButton(icon: const Icon(Icons.restore), onPressed: () {
        for(var id in selectedNotes) {
          ref.watch(notesProvider).notes.get(id).deleted = null;
          ref.watch(notesProvider).notes.get(id).parentId = "";
          ref.watch(notesProvider).notes.get(id).save();
        }

        ref.read(notesProvider.notifier).moveNotes(selectedNotes, "!TRASH", "");
        ref.read(selectedNotesProvider.notifier).endSelection();
      }),
      IconButton(
          icon: const Icon(AppIcons.trash),
          onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return ConfirmationDialog(
                  title: AppLocalizations.of(context).get("@dialog_title_delete_selected_notes"),
                  onConfirmed: () {
                    for(var id in selectedNotes) {
                      ref.watch(notesProvider).notes.get(id).delete();
                    }

                    ref.read(notesProvider.notifier).deleteNotes(selectedNotes);
                    ref.read(selectedNotesProvider.notifier).endSelection();
                  },
                );
              }))
    ];
  }

  final folder = Note(id: "!TRASH");

  return [
    PopupMenuButton(
        icon: Icon(
          appCacheData.viewMode("!TRASH") == "linear" ? AppIcons.linear : AppIcons.grid,
        ),
        itemBuilder: (context) {
          return [
            notesViewSortMenuHeader(context: context, label: AppLocalizations.of(context).get("@popup_menu_leading_view_as")),
            notesViewSortMenuViewModeButton(
                label: AppLocalizations.of(context).get("@popup_menu_item_grid"),
                context: context,
                folder: folder,
                icon: AppIcons.grid,
                viewMode: "grid",
                ref: ref),
            notesViewSortMenuViewModeButton(
                label: AppLocalizations.of(context).get("@popup_menu_item_list"),
                context: context,
                folder: folder,
                icon: AppIcons.linear,
                viewMode: "linear",
                ref: ref),
            notesViewSortMenuHeader(context: context, label: AppLocalizations.of(context).get("@popup_menu_leading_sort_by")),
            notesViewSortMenuSortButton(
                context: context,
                label: AppLocalizations.of(context).get("@title"),
                folderId: folder.id,
                sortOption: SortOption.title,
                sortOptionDescending: SortOption.titleDescending,
                ref: ref),
            notesViewSortMenuSortButton(
                context: context,
                label: AppLocalizations.of(context).get("@created_date"),
                folderId: folder.id,
                sortOption: SortOption.created,
                sortOptionDescending: SortOption.createdDescending,
                ref: ref),
            notesViewSortMenuSortButton(
                context: context,
                label: AppLocalizations.of(context).get("@modified_date"),
                folderId: folder.id,
                sortOption: SortOption.modified,
                sortOptionDescending: SortOption.modifiedDescending,
                ref: ref),
            notesViewSortMenuSortButton(
                context: context,
                label: AppLocalizations.of(context).get("@deleted_date"),
                folderId: folder.id,
                sortOption: SortOption.deleted,
                sortOptionDescending: SortOption.deletedDescending,
                ref: ref)
          ];
        })
  ];
}
