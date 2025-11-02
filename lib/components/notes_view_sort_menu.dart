import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_cache_data.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../providers/providers.dart';

PopupMenuItem notesViewSortMenuHeader({required String label, required BuildContext context}) {
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

PopupMenuItem notesViewSortMenuViewModeButton({required String label, required BuildContext context, required Note folder, required IconData icon, required String viewMode, required WidgetRef ref}) {
  return PopupMenuItem(
      height: 40,
      onTap: () {
        appCacheData.setViewMode(id: folder.id, value: viewMode);
        appCacheData.save();
        ref.read(viewModeProvider.notifier).setViewMode(folder.id, viewMode);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                color: (ref.watch(viewModeProvider)[folder.id] ?? appCacheData.viewMode(folder.id)) == viewMode ? Theme.of(context).highlightColor : Theme.of(context).textTheme.bodyMedium?.color,
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

PopupMenuItem notesViewSortMenuSortButton({required String label, required BuildContext context, required String folderId, required String sortOption, required String sortOptionDescending, required WidgetRef ref}) {
  final currentSortOption = appCacheData.sortOption(folderId);
  return PopupMenuItem(
      height: 40,
      onTap: () {
        if(currentSortOption == sortOption) {
          appCacheData.setSortOption(sortOption: sortOptionDescending, id: folderId);
        }
        else {
          appCacheData.setSortOption(sortOption: sortOption, id: folderId);
        }

        appCacheData.save();
        ref.read(notesProvider.notifier).sortNotes(folderId);
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
                appCacheData.sortOption(folderId) == sortOption ? Icons.arrow_upward : Icons.arrow_downward,
                size: 20,
                color: appCacheData.sortOption(folderId).contains(sortOption) ? Theme.of(context).highlightColor : Theme.of(context).textTheme.bodyMedium?.color,
              )
            ]
          ])
  );
}